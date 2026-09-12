---
name: sustech-mse-preview
description: "SUSTech MSE lab previews, end to end: condense the experiment manual into short, hand-copyable PREVIEW (预习报告) notes. Use when the user prepares a preview before an experiment class or wants the manual condensed into preview notes. Preview content served on zhihuishu (智慧树/知到) is watched and answered by hand — this skill does not automate it."
---

# sustech-mse-preview

> **Third-party aid, not an official department product.** This skill is an
> unofficial student-made helper. It can drift from reality and does not
> represent the SUSTech MSE department in the long run. Whenever Blackboard
> (BB) requirements, the official templates, or the teacher's instructions
> contradict anything written here, **the official requirements win.**

The MSE teaching labs require an in-class **handwritten preview report** on
the official form before each experiment. This skill reads the experiment
manual and condenses it into short, precise notes the user **hand-copies**
onto that form. It never produces a typed report — the typed-report workflow
is a separate skill and this one is fully isolated from it: consume only the
manual, output only preview material.

## Input

The experiment manual and nothing else:
- if the `sustech` CLI (dumixthestpd/sustech_survival or a sustech-cli fork)
  is installed and configured, fetch the manual from `bb` like:

```bash
sustech bb courses                       # complete enrolled list (id + name)
sustech bb page <course_id>              # the course's item tree
sustech bb page <content_id>             # one item + its 📎 attachments
sustech bb download <content_id> --output .   # the manual itself (PDF/docx)
```

Manuals arrive as file attachments under their real filenames; plain numeric
ids work (`8613`, `645443`). Cold logins take 60 s+ (give the tool call 300 s);
never prepend `export SUSTECH_TIMEOUT=...` — the module does not read it.

**Which experiment is "next"?** BB lists the experiments in a fixed numeric
order but carries no week↔experiment map, so don't hunt for a schedule —
`bb search` re-scrapes all pages (20–40 s each) and finds nothing. Use
`sustech context courses last <course>` (last class date + week) together with
what the workspace already holds: the earliest experiment that has no report/
preview folder yet is the next one. State the inference and its evidence
(class date, experiment order, existing workspace dirs) and ask the user to
confirm — never assume silently.

- otherwise take the manual the user pastes. Read it fully: objectives,
  theory, materials with amounts, procedure, expected observations,
  in-manual questions. Never fabricate from outside the manual.

## Output — what to write

One short markdown summary (`preview.md`) plus the same content in chat,
organized under the official form's field headings (their exact wording is
in `assets/preview-template.docx` — open it if a field name is unclear):

1. **Principles** — 2–3 sentences **plus every key equation of the manual, written
   out.** An equation is worth more than a sentence describing it: the form's
   Principles cell is where the marker checks that you know the physics, and a
   paragraph of prose around a missing formula reads as padding.

   Give each equation with what its symbols mean and any value the manual fixes:

   ```
   Bragg's law (Eq. 1):  lambda_max = 2 d_hkl (n_eff^2 - sin^2 theta)^(1/2)
     d_hkl  lattice spacing (= sphere size, 100-300 nm here)
     n_eff  effective refractive index (PS ~1.6)
     theta  angle of incidence
   ```

   The manuals often set their equations as **images**, so the text layer shows a
   gap where the formula should be. Render that page region and read it off — a
   typeset equation in the handout is text to be transcribed, not a lab photo,
   and this is the one case where reading an image is required. If a symbol is
   unreadable, leave `<fill in class>` rather than guessing it.
2. **Experimental setup and reagents** — bullets: each chemical with amount /
   concentration, each apparatus with settings. Only what the manual fixes.
3. **Experimental procedures** — numbered telegraphic steps (default).
   If the user asks for a flowchart (or states it as their default for
   procedure), render a flowchart of the procedure instead (recipe below).
   Do not mix: pick the requested form.
4. **Experimental phenomenon** — what should be observed/expected, briefly.
5. **Data recording** — a blank table skeleton with the columns to fill
   during the lab.

Style: short and telegraphic — every line is meant to be copied by hand.
Bullets and numbers, not prose paragraphs.

Language: **English** — the official form's field headings are English and the
student hand-writes the body in English (check a scanned previous form if one
is on hand). A Chinese rendering may sit beside it as `preview-zh.md` for
comprehension, but `preview.md` is the file that gets hand-copied. If the manual is silent on a
field, write the heading plus "— fill in class / not in manual". Keep it to
roughly one handwritten page.

## Supplementary figures from the manual

The form's Setup and Reagents cell asks for a **graphic of the device**, and the
student draws it by hand — so ship the manual's own device and schematic figures
alongside the notes. Extract them (a photo of the rig is an embedded image, a
schematic may only be vector art, in which case render the page):

```python
import fitz, os                      # pip install pymupdf
W = "<the experiment folder>"
doc = fitz.open(os.path.join(W, "manual.pdf"))
os.makedirs(os.path.join(W, "preview", "fig"), exist_ok=True)
for pno in range(doc.page_count):
    for i, im in enumerate(doc[pno].get_images(full=True)):
        pix = fitz.Pixmap(doc, im[0])
        if pix.width >= 150 and pix.height >= 150:      # skip logos and rules
            pix.save(f"{W}/preview/fig/p{pno+1}-img{i+1}.png")
    if "Fig" in doc[pno].get_text():                     # page carries a schematic
        doc[pno].get_pixmap(dpi=110).save(f"{W}/preview/fig/page-{pno+1}.png")
```

- Keep only figures a student would draw: the reaction rig, the setup, the
  measurement schematic. Drop instrument logos, tables and decorative art.
- Reference each one from the notes, under Experimental Setup and Reagents:
  "Device: draw the reaction setup, `preview/fig/p4-img1.png` (manual Fig. 1 —
  three-necked flask, ball condenser and thermometer in the oil bath)."
- Deliver the images in chat next to the notes, so they can be copied or
  sketched straight onto the form.
- This is the one place a manual figure is reproduced. It is supplementary
  material for a form the student fills in by hand, not a claim in a typed
  report, so no credit line is written and neither is any other mention of the
  manual.

Save it at the experiment's preview folder:

```
$SUSTECH_HOME/.sustech_survival/mse-lab/<semester>/<course-id>-<course-name>/<expN>-<keyword>/preview/preview.md
```

(create the folder. `SUSTECH_HOME` is the data-tree anchor, default `~`, so
the root is `$SUSTECH_HOME/.sustech_survival/` — i.e. `~/.sustech_survival/`
by default, the same convention as the sustech-survival module. This mirrors
the shared lab layout.) A rendered flowchart goes next to it as
`preview/flow.png` and is referenced from the summary.

## Flowchart recipe

Only for procedure summaries when the user wants a flowchart.

1. Draw the procedure as Mermaid `flowchart` (editable, also renders in any
   markdown viewer). Branching/loops get diamond decisions; keep ≤ ~12 nodes.
2. Render to PNG locally (no network needed) with mermaid-cli, which drives an
   installed browser, or fall back to graphviz `dot`:

```bash
# mermaid-cli (needs a browser; add PUPPETEER_EXECUTABLE_PATH if it cannot
# find one by itself — point it at the browser installed on this machine)
mmdc -i flow.mmd -o flow.png
dot -Tpng flow.dot -o flow.png          # fallback: graphviz
```

3. **Aspect rule**: the PNG must stay within width/height between 9:16 and
   16:9 (ratio ≥ 9/16 ≈ 0.5625 and ≤ 16/9 ≈ 1.778). Measure, and if it is
   out of bounds re-lay-out instead of stretching:

```bash
sips -g pixelWidth -g pixelHeight flow.png
```

   - ratio < 9/16 (too tall): lay the flow left-to-right (LR) or split into
     two columns; then re-measure.
   - ratio > 16/9 (too wide): lay it top-to-bottom (TB) or single column.
4. Deliver `flow.png` in chat (and saved next to `preview.md`) so the user
   can copy it by hand; keep the `.mmd`/`.dot` source beside it in case the
   layout needs tweaks.

## zhihuishu (智慧树/知到) — the preview platform, not automated

Some preview content (pre-lab videos and their in-video pop quizzes) is served
on the zhihuishu platform. It is named here **only** as part of the preview
workflow: the videos are watched and the quizzes answered by hand in the
browser.

Automation of it is deliberately out of scope — no tooling, installer or
helper script ships with this skill, and none is to be added back, so do not
look for one and do not install one. If the user asks for zhihuishu
automation, say it is not implemented and stop there. Never complete preview
content on the user's behalf.

## Do not

- Do not write a full lab report or long prose — this is copy-able preview material.
- Do not fabricate values, phenomena or data the manual does not state.
- **Do not interpret any image.** No describing what a photo or micrograph
  shows, no reading a thermometer off a picture, no morphology claims. If the
  "Graphic display the device" cell or the phenomenon section needs something
  about the user's own pictures, ask the user what they saw — the user is the
  expert and is the one who will hand-draw the form.
- Do not read, import or reference the typed report or anything another
  skill produced — work from the manual only.
- Do not exceed roughly one handwritten page.
- Do not stretch a flowchart to fit the aspect rule — change its layout.
- Do not automate zhihuishu in any form — its preview videos and quizzes are done by hand.
- Do not put real PII (name/SID/account info) into examples or anything that can leave the machine — censor with 张三 / <sid> placeholders.
