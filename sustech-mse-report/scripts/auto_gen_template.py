#!/usr/bin/env python3
"""auto_gen_template.py — pre-fill a sustech-mse-report template with live metadata.

Queries the `sustech` CLI (dumixthestpd/sustech_survival or a fork that
provides `context courses last`), then copies templates/template.tex to the
working directory with the cover metadata filled in:
  - course name        (from `sustech bb courses`, instance tag stripped)
  - name + SID         (from `sustech profile --json`, SID falls back to
                        ~/.sustech_survival/credentials.txt)
  - experiment date    (from `sustech context courses last`)

Fields the script cannot know — experiment title (manual), submission date,
teammates — are left as explicit markers or empty braces for the agent/user
to complete. Nothing is ever fabricated: unresolvable fields become markers
and warnings.

Usage:
    python auto_gen_template.py [--course "<name or id>"] [--out report.tex]

If more than one experiment course is enrolled, --course is required; with
exactly one experiment course it is auto-detected.
"""

import argparse
import json
import re
import subprocess
import sys
from pathlib import Path

SKILL_ROOT = Path(__file__).resolve().parent.parent
TEMPLATE = SKILL_ROOT / "templates" / "template.tex"
CREDS = Path.home() / ".sustech_survival" / "credentials.txt"

INSTANCE_TAG = re.compile(r"\s+\d{2}\s+(?:Fall|Spring|Summer|Winter)\s+\d{4}$")
COURSE_LINE = re.compile(r"^\s*(\d+)\s+(.+?)\s*$")
DATE_ISO = re.compile(r"(\d{4})-(\d{2})-(\d{2})")

# No hardcoded course names: `sustech context courses last` takes a display
# name, so try the BB title (instance tag stripped) and, as fallback, the
# raw BB title. --course-tis-name is the manual override for the rare case
# where the TIS display name differs from the BB title.


def run_sustech(args, timeout=120):
    """Run a `sustech` subcommand; return (stdout, returncode)."""
    try:
        proc = subprocess.run(
            ["sustech", *args],
            capture_output=True, text=True, timeout=timeout,
        )
    except FileNotFoundError:
        sys.exit("error: `sustech` not found on PATH — install dumixthestpd/"
                 "sustech_survival or a sustech-cli fork first (see SKILL.md).")
    except subprocess.TimeoutExpired:
        sys.exit(f"error: `sustech {' '.join(args)}` timed out.")
    out = (proc.stdout or "") + (proc.stderr or "")
    return out, proc.returncode


def list_courses():
    out, rc = run_sustech(["bb", "courses"])
    if rc != 0:
        sys.exit(f"error: `sustech bb courses` failed:\n{out}")
    courses = []
    for line in out.splitlines():
        m = COURSE_LINE.match(line)
        if m:
            courses.append((m.group(1), m.group(2).strip()))
    return courses


def pick_course(courses, needle):
    """Return (cid, title). needle may be an id or a title substring."""
    if needle:
        for cid, title in courses:
            if cid == needle or needle.lower() in title.lower():
                return cid, title
        sys.exit(f"error: no enrolled course matches {needle!r}.\n"
                 f"Enrolled: " + "; ".join(f"{cid} {title}" for cid, title in courses))
    exp = [c for c in courses if re.search(r"experiment|实验", c[1], re.I)]
    if len(exp) == 1:
        return exp[0]
    if not exp:
        sys.exit("error: no experiment course detected — pass --course \"<name or id>\".")
    sys.exit("error: several experiment courses enrolled — pass --course to pick one:\n  "
             + "\n  ".join(f"{cid}  {title}" for cid, title in exp))


def course_display_name(title):
    return INSTANCE_TAG.sub("", title).strip()


def last_session_date(course_title):
    out, rc = run_sustech(["context", "courses", "last", course_title])
    m = DATE_ISO.search(out)
    if rc != 0 or not m:
        return None, f"`sustech context courses last` unavailable; fill the experiment date manually.\n{out}"
    y, mo, d = m.groups()
    return f"{y}/{mo}/{d}", None


def profile():
    """Return (sid, name). SID falls back to credentials file."""
    sid = name = None
    try:
        raw, rc = run_sustech(["profile", "--json"])
        if rc == 0 and raw:
            data = json.loads(raw[raw.index("{"):])
            sid = data.get("sid") or None
            name = data.get("name") or None
    except Exception:
        pass
    if not sid and CREDS.exists():
        first = CREDS.read_text(encoding="utf-8").splitlines()[0].strip()
        if ":" in first:
            sid = first.split(":", 1)[0].strip()
    return sid, name


def fill_makesutitle(tex, fields):
    """Replace the block between \\makesutitle and the first numbered section."""
    start = tex.index(r"\makesutitle")
    end = tex.index(r"\section{", start)
    block = "\\makesutitle\n" + "".join(f"  {{{f}}}\n" for f in fields)
    return tex[:start] + block + tex[end:]


def main():
    ap = argparse.ArgumentParser(description=__doc__.splitlines()[1])
    ap.add_argument("--course", help="course name substring or BB course id")
    ap.add_argument("--course-tis-name", help="TIS display name for the date lookup "
                                             "(default: the BB course title)")
    ap.add_argument("--out", default="report.tex", help="output file (default: ./report.tex)")
    args = ap.parse_args()

    if not TEMPLATE.exists():
        sys.exit(f"error: template not found at {TEMPLATE} — is this script inside the skill dir?")

    cid, title = pick_course(list_courses(), args.course)
    course = course_display_name(title)
    exp_date, date_warn = None, None
    for cand in (args.course_tis_name, course, title):
        if not cand:
            continue
        exp_date, date_warn = last_session_date(cand)
        if exp_date:
            break
    sid, name = profile()

    fields = [
        course,
        "Experiment title from manual — FILL",
        name or "Name — FILL (Chinese)",
        sid or "SID — FILL",
        exp_date or "YYYY/MM/DD — FILL (experiment date)",
        "",  # submission date: fill only before submission
        "",  # teammates: Chinese, joined with ，(full-width comma); leave empty if none
    ]
    tex = TEMPLATE.read_text(encoding="utf-8")
    report = fill_makesutitle(tex, fields)
    Path(args.out).write_text(report, encoding="utf-8")

    print(f"wrote {args.out} (course {cid}: {course})")
    print("filled: name/SID/course/experiment date")
    if date_warn:
        print("warning:", date_warn)
    print("still to fill by hand: experiment title (from manual), submission date, teammates")
    print(f"then: xelatex -interaction=nonstopmode -halt-on-error {args.out}")


if __name__ == "__main__":
    main()
