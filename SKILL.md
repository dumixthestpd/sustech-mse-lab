---
name: sustech-mse-lab
description: Use when an MSE lab course, manual, or report is mentioned.
---

# sustech-mse-lab

Router for the SUSTech MSE teaching-lab workflow. This root file holds no
procedure — load the matching sub-skill with `skill_view` and follow it.

Route on the task, not the platform:

- Manual → hand-copyable preview notes; zhihuishu (知到) content, when a course
  uses it, is handled by hand and only named inside that skill
  → `sustech-mse-preview`
- Typed post-lab report (LaTeX, data, figures, compile, merge, submit)
  → `sustech-mse-report`

Shared facts (restated inside each sub-skill):

- Third-party aid, not an official department product; when BB, official
  templates, or the teacher contradict the skill, the official side wins.
- Data root `$SUSTECH_HOME/.sustech_survival/` (`SUSTECH_HOME` anchors at
  `~`); per-experiment workspace
  `mse-lab/<semester>/<course-id>-<course-name>/<expN>-<keyword>/`.
- Never hardcode course/content IDs — discover them from `bb` every run.
- Personal info (name/SID/teammates) never leaves the machine uncensored
  (张三 / <sid> placeholders in anything exported).
