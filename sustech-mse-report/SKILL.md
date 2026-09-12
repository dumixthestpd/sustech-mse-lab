---
name: sustech-mse-report
description: Generate SUSTech MSE teaching-lab reports end-to-end for ANY experiment course — from reading the experiment manual on BB to a submission-ready PDF named SID+name+keyword, LaTeX via sustech-labreport.cls. Use when the user mentions any experiment course, its experiments, its report template, its experiment data, or report submission.
---

# sustech-mse-report

> **Third-party aid, not an official department product.** This skill is an
> unofficial student-made helper. It can drift from reality and does not
> represent the SUSTech MSE department in the long run. Whenever Blackboard
> (BB) requirements, the official templates, or the teacher's instructions
> contradict anything written here, **the official requirements win.**

Full workflow for writing and submitting **any** lab report for the SUSTech
MSE teaching labs. Self-contained: it never reads or imports what another
skill produced.

## Read these before you draft

This file is the workflow only. The rules live in the files beside it, and a
report written without them fails the rubric:

- **`references/latex-conventions.md`** — how to typeset it: `\ce{}` markup,
  table and caption recipes, the no-Note rule, figure layouts, float
  configuration, typography traps, the compile checklist.
- **`references/writing-style.md`** — how to write it: voice, the required
  prose shapes, claims and numbers, section discipline, spelling.
- **`templates/template.tex`** and `templates/sustech-labreport.cls` — the
  skeleton the report is built from, carrying the same recipes in place.
- **`scripts/auto_gen_template.py`** — the cover pre-fill. Run it; never
  hand-copy the template.
- **`assets/report-template.docx`** — the teacher's rulebook source. Open it
  when a format detail is unclear instead of guessing.

## Workspace

One folder per experiment:

```
$SUSTECH_HOME/.sustech_survival/mse-lab/<semester>/<course-id>-<course-name>/<expN>-<keyword>/
    report.tex                   the report source
    fig/                         its images (template copies + the experiment's
                                 own photos and scans)
    report.pdf                   compiled output
    <SID>+<Name>+<keyword>.pdf   the ONE deliverable
```

`SUSTECH_HOME` anchors the data root, default `~` (so `~/.sustech_survival/`,
the sustech-survival convention). `<semester>` like `2026Fall`;
`<course-id>-<course-name>` from `sustech bb courses` (e.g.
`8613-材料科学与工程高等实验I`); `<expN>-<keyword>` like `exp3-metal-coating`. All
commands run inside this folder; other files may sit in it but only these are
used.

## Requirements — the CLI, and the skill's own surface

`wormforce/sustech-cli` or `dumixthestpd/sustech_survival`, configured (auth in
`~/.sustech_survival/credentials.txt`, `sustech sso check` once).

**Reach for the skill's own surface before hand-rolling anything**, in this
order:

1. `python <skill_root>/scripts/auto_gen_template.py --out report.tex` — writes
   `report.tex` with the cover **pre-filled from the live CLI** (course from
   `bb courses`, experiment date from `context courses last`, name + SID from
   `sustech profile --json`). Never leave a cover field blank while the CLI can
   fill it.
2. `sustech` for the course tree, the manual and the submission.
3. The templates and references here for everything else.

Without the CLI (a user who declines to install it) the workflow still runs:
`cp -r templates/ .`, fill the cover by hand, take the manual as pasted text,
submit through the browser. Say which path you took.

**When the experiment belongs to a different course.** The workflow applies to
any SUSTech teaching lab, and other courses bring their own document class:

- The student's own `.cls` (e.g. a physical-chemistry or organic-chemistry
  course class) is the authority for their cover and typography. Build on it,
  and port the skill's rules onto it — the section names, the caption and
  float conventions, the no-Note rule and the writing rules all still hold.
- `scripts/auto_gen_template.py` emits the MSE class; for another course use
  its metadata (course, name, SID, date) and not its document class.
- If `sustech context courses last <course>` cannot resolve the course (a past
  semester is no longer listed), leave the experiment date empty rather than
  guessing it or reading it off a scan.

## Phase 0 — Find the course, the experiment and the manual

Scan BB live; never assume course ids, content ids or the experiment set from a
map or a past semester — enrolments and semesters differ.

```bash
sustech bb courses                          # enrolled list (id + name)
sustech context courses last <course>       # latest class date + week
sustech bb page <course_id>                 # the course's item tree
sustech bb page <content_id>                # one item + its 📎 attachments
sustech bb download <content_id> --output .  # the manual (PDF/docx)
```

Manuals are attachments: `bb page <content_id>` prints the 📎 filename and
`bb download` saves it under that real name. Ids are plain numbers (`8613`,
`645443`); the numeric and `_8613_1` forms both work. An empty listing means the
filter or id was wrong — re-read `bb courses`. A cold login (CAS → BB) takes
60 s or more: give the tool call 300 s, and never prepend
`export SUSTECH_TIMEOUT=...`, which the module does not read.

Read the manual in full (objectives, theory, formulas, materials, procedure,
parameters, in-manual questions). Then ask the user for the experiment data,
the photos the manual expects, **what they saw in those photos**, and any
in-class change from the manual. If they opened with everything, skip this —
except the photo question, which `references/writing-style.md` makes mandatory.

## Phase 1 — The handwritten preview

The course requires an in-class **handwritten preview** whose headings are
Principles / Experimental Setup and Reagents / Experimental Procedures /
Experimental Phenomenon / Data Recording. Its scanned pages are appended to the
final PDF as pages — never OCR them, never read them. Remind the user if it is
not ready.

## Phase 2 — Draft the report

**The class is not always `sustech-labreport.cls`.** Some experiment courses ship
their own class with the manual, and it wins over the skill's template:
`sustech-exp-report-2026sp.cls` (PhyChemExp / GOrganicExp, Spring 2026) takes the
cover as `\makesutitle{course}{title}{name}{SID}{exp date}{sub date}{teammates}`
and already loads caption/geometry/fancyhdr/titlesec/enumitem, with figures
numbered `section.n`. When the student supplies a `.cls`, use it, add only the
missing packages (`mhchem`, `subfig`, `placeins`, `needspace`), and say so in the
hand-off. `scripts/auto_gen_template.py` still resolves course/name/SID
correctly, but it writes the old class; take its output as the metadata source,
not as the file to compile.

**`sustech context courses last` only knows the current semester.** For a
past-semester course the TIS lookup returns
`no course matches ...` and the script warns, so the experiment date cannot come
from the CLI. Leave the cover date empty rather than lifting it from a scanned
preview page, and tell the user which cover fields are waiting on them.

Create the folder, run `scripts/auto_gen_template.py --out report.tex`, then
work inside `report.tex`: replace every `<...>`, drop the images into `fig/` and
reference them by filename. The cover arrives pre-filled from the CLI — name,
SID, course and experiment date — while **the submission date stays empty**
(`{}` in `\makesutitle`) unless the user hands you the date, and the teammate
field stays empty unless they name them: today's date is a claim nobody made.
Typesetting rules: `references/latex-conventions.md`; prose rules:
`references/writing-style.md`.

Section names the course already uses — keep this wording; the class numbers
them, so never type a number and never use `\section*`:

1. **Objectives** — 2–3 bullets from the manual, one infinitive and one object
   each. **COPY MANUAL OK.**
2. **Principles** — condensed, formulas + principle figure, **≤ 1 page**.
   **REDUCE FROM MANUAL**.
3. **Experimental Materials and Setups** — Chemicals / Apparatuses / Tools, with
   the apparatus photos. Never in Results; and a sentence belongs to the section
   that owns its subject.
4. **Experimental Procedures** — numbered steps following the in-class
   parameters, which override the manual. **REDUCE FROM MANUAL**.
5. **Results and Discussion** — three sub-sections **in this order**:
   `Phenomena`, `Experimental Data`, `Error Analysis` — the order of the work:
   you see, then you calculate, then you analyze.
6. **Conclusion** — **one paragraph, about 100 words.** The rulebook's "~300
   words" caps the whole section, not each paragraph.
7. **Questions and Further Thoughts** — restate each manual question, then
   answer it, in order.
8. **References** — only if real literature is cited. **The course manual is
   never cited**: the whole class works from it. With nothing else to cite,
   omit the section.
9. **Raw Data and Preview Report** — after `\newpage`, holding the scanned
   handwritten preview and the raw-data record.

## Phase 3 — Compile and verify

```bash
xelatex -interaction=nonstopmode -halt-on-error report.tex   # twice
pdfinfo report.pdf
```

Check: cover fields filled, no leftover `<...>`, **zero Overfull `\hbox`**
(grep the log, then fix the sentence rather than the settings), no undefined
references, Principles ≤ 1 page, table captions above, figure captions below,
English throughout, ~6 pages of body (appended scans excluded).

Then **render the pages to PNG and look at them** — a clipped image crop, a
stretched row or a figure stranded from its caption is invisible in the log.

## Phase 4 — Build the ONE submission file

1. Append the scans *in* the report source, the course convention: after
   `\newpage`, a `\section{Raw Data and Preview Report}` with one
   `\begin{center}\includegraphics[width=0.86\textwidth]{...}\end{center}` per
   page (preview first, then raw data). With only a PDF to merge,
   `pdfunite report.pdf scans.pdf out.pdf` is the fallback. Either way the user
   gets **exactly one file** — `report.pdf` alone is not the deliverable.
2. Name it `{SID}+{name}+{keyword}.pdf` (the teacher's rule, SID+姓名+实验名称
   关键字), with the real SID and name from `sustech profile --json`.
3. Submit to the experiment's BB **Report** folder:
   `sustech bb submit <content_id> <file.pdf> [--course <id>]`, dry-run first
   where supported. Verify the attempt row or receipt before reporting success.

## Phase 5 — Hand back

Close every run by telling the user, explicitly:

1. **Re-read the Error Analysis and the Questions line by line.** Agent prose
   goes wrong there most often: it reasons from the manual, not from the bench,
   and the graded understanding belongs to whoever was in the room.
2. **Add the lab-only observations.** Anything that made them stop and think
   belongs in the report, because the reviewer rewards understanding that comes
   only from having done the work. Worked example: the filtration liquid came
   out **very green**, so copper and chloride left the solid with the mother
   liquor and the product is not completely soluble in the alcohol wash — a
   copper loss term for the error analysis. The agent cannot see the bench; it
   can only ask.

## Course rulebook

From the BB template and the teacher's own instructions:

**CRITICAL**: Writing notice

- Language: **English**. Cover and filename carry the Chinese name and SID.
- Grading: cover 5 % / format 25 % / content 70 %. Late: −0.5/day, cap −10.
- Length: recommended **~6 pages**, Principles ≤ 1 page. The target is a
  recommendation: graded content (the error analysis, the answered questions)
  and a figure the student supplied both outrank it. If the body runs to 7
  pages because of them, keep the content and say why.
- Conclusion: one paragraph, ~100 words.
- Questions answered in order with the question restated.
- References only if real literature is used.
- Tables: three-line booktabs, `Table N` + title above, symbols + units.
- Figures: `Fig. N` + caption below, scale bar AND magnification on
  photos/micrographs.
- Raw in-class data is re-tabulated or re-plotted, never screenshotted — the
  raw-data record in §9 is the one scan by design.
- Error analysis is graded: the sources and how to reduce them.
- The template's red text is instruction, not content: remove it.

## Do not

- Do not fabricate SID, name, dates, data, photo descriptions or answers.
- Do not silently override a number the student's own data file already
  computed. If it contradicts the manual (a concentration list derived from a
  reading of the dilution steps the fit cannot support, say), pick the
  defensible one, show the derivation, and leave one `<ASK USER>` marker at the
  point of use rather than quietly replacing their figure.
- Do not OCR or transcribe the handwritten preview or the raw-data scans.
- Do not interpret the user's photos, and do not carry preview content into the
  report — report content comes from the manual and the user's own data.
- Do not cite the course manual, and do not reuse another course's rubric.
- Do not hardcode BB course or content ids — discover them from `bb` every run.
- Do not put real PII (name/SID/teammates) into examples, skill files or
  anything leaving the machine — the report's own cover and filename are the
  one place those values belong.
