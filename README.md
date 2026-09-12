# sustech-mse-lab

Agent skills for the SUSTech MSE teaching labs (材料科学与工程高等实验) — turn an
experiment manual into hand-copyable preview notes, and into a submission-ready
LaTeX lab report.

> **Third-party aid, not an official department product.** Student-made and
> unofficial; it can drift from reality. Whenever Blackboard, the official
> templates or the teacher's instructions contradict anything here, the official
> side wins.

## What's inside

- **`sustech-mse-lab`** — the router. Holds the shared facts (data root, ID
  discovery, privacy) and points to the skill that matches the task.
- **`sustech-mse-preview`** — the in-class handwritten preview (预习报告). Reads
  the manual and writes a one-page telegraphic summary under the official form's
  headings, pulls the rig figure to hand-draw, and renders a procedure flowchart
  on request. zhihuishu, where some preview content lives, is named only as a
  platform — it is not automated.
- **`sustech-mse-report`** — the typed post-lab report. Manual → `report.tex` →
  compiled PDF → one merged submission file named `SID+姓名+keyword.pdf`.

## Install

```bash
npx skills add <owner>/sustech-mse-lab --skill sustech-mse-lab
npx skills add <owner>/sustech-mse-lab --skill sustech-mse-preview
npx skills add <owner>/sustech-mse-lab --skill sustech-mse-report
```

Without npm: copy `SKILL.md`, `sustech-mse-preview/` and `sustech-mse-report/`
into the agent's skills directory (`~/.hermes/skills/` for Hermes).

## Requirements

- **A `sustech` CLI, configured** — `wormforce/sustech-cli` or
  `dumixthestpd/sustech_survival`, with auth in
  `~/.sustech_survival/credentials.txt`. Without it the workflow still runs by
  hand: take a pasted manual, fill the cover yourself, submit through the
  browser.
- **XeLaTeX** — report only: `xelatex`, `biber`, `pdfinfo`.
- **mermaid-cli or graphviz** — only for the optional procedure flowchart.
- **PyMuPDF** — only to extract the manual's figures and equations.

## Data layout

```
$SUSTECH_HOME/.sustech_survival/mse-lab/<semester>/<course-id>-<course-name>/<expN>-<keyword>/
    manual.pdf
    preview/preview.md          preview notes (+ preview/fig/, preview/flow.png)
    report.tex   fig/   report.pdf
    <SID>+<Name>+<keyword>.pdf  the one deliverable
```

`SUSTECH_HOME` anchors the data root and defaults to `~`.

## What the skills will not do

- Fabricate data, dates, answers or photo descriptions — the user supplies those.
- OCR or transcribe the handwritten preview and raw-data scans.
- Interpret the user's own photos and micrographs.
- Cite the course manual in References.
- Automate zhihuishu, or complete preview content on the user's behalf.
- Put a real name, SID or teammate into an example, a skill file, or anything
  that leaves the machine — placeholders (`张三`, `<sid>`) only.

## Contribute

You can:

1. PR in GitHub directly.
2. Directly @ someone that wrote dumix in their name in QQ discussion group of any SUSTech MSE QQ discussion group.
3. Contact me as dumixthestpd@hotmail.com

## License

MIT — see [LICENSE](LICENSE).
