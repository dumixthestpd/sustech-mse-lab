# LaTeX conventions — SUSTech MSE lab reports

The mechanics: how every element of the report is typeset. Read this with
`templates/template.tex`, which carries the same recipes in place. Prose rules
live in `writing-style.md`.

## Chemical formulas

**Every formula goes through `\ce{}`** — prose, captions, table cells,
Objectives, Questions:

```latex
The salt \ce{[H3N(CH2)2NH3]CuCl4} forms from \ce{CuCl2.2H2O} and
\ce{NH2(CH2)2NH2.2HCl}; the anion \ce{[CuCl4]^2-} pairs with the cation
\ce{[H3N(CH2)2NH3]^2+}.
```

Typed as plain text the same formula prints without its subscripts, so the
report renders one compound two different ways.

## Tables

A cell names the quantity and its unit in words — "Mass of `\ce{CuCl2.2H2O}`
(g)", never `<symbol>(<formula>) / <unit>`, which makes the reader parse a
formula to reach a number. Headers carry the unit the same way
(`Temperature ($^\circ$C)`).

```latex
\begin{center}
  \captionof{table}{Amounts charged and the product obtained.}\label{tab:data}
  \begin{tabular}{lc}
    \toprule
    Quantity & Value \\
    \midrule
    Mass of \ce{CuCl2.2H2O} (g)         & 0.85 \\
    Amount of \ce{CuCl2.2H2O} (mmol)    & 4.99 \\
    Limiting reagent                     & \ce{CuCl2.2H2O} \\
    Theoretical product mass (g)         & 1.3336 \\
    Product mass (g)                     & 1.2321 \\
    Yield (\%)                           & 92.4 \\
    \bottomrule
  \end{tabular}
\end{center}
```

- Three-line booktabs only; caption ABOVE with `\label` right after it. A large
  table uses a `table` float; a small one stays inline with `\captionof` so it
  cannot drift to another page.
- **Most tables need no Note: leave it out.** The caption, the unit in the header
  and the row label already say what the numbers are, so a Note has to earn its
  place. Add a `\\ Note:` block only when it carries something the table cannot
  express and the reader needs in order to read a value correctly — an
  uncalibrated instrument, a sample that was measured again, a value taken from
  the manual instead of the bench. A Note that restates the obvious ("the yield
  is referred to the limiting reagent", "the amounts follow from the weighed
  masses") is one to leave out.

## Figures

**One theme per figure.** A result comparison (before/after, tube 1/2/3) never
shares a figure with an apparatus photo — split them, and keep apparatus photos
in §3 or §4.

**`\quad` between subfigures in a row, `\\` (or `\bigskip`) between rows.**
Never `\hfill`: it stretches the row to the margins, so images whose widths do
not sum to `\linewidth` end up with visible gaps. It is tolerable only when
equal-width images already fill the line; `\quad` is never wrong.

**The main caption carries the description and cites the panel letters with
`\protect\subref{...}`**, so letters are never typed by hand:

```latex
\begin{figure}[htbp]
  \centering
  \subfloat[Before heating]{\includegraphics[height=4cm]{fig/before}\label{fig:before}}\quad
  \subfloat[After heating]{\includegraphics[height=4cm]{fig/after}\label{fig:after}}
  \caption{Pictures of the sample before \protect\subref{fig:before} and
  after \protect\subref{fig:after} heating.}
  \label{fig:heating}
\end{figure}
```

Multi-panel figures follow the published style — letters inline, one clause per
letter:

```
Fig. 9 Cross-sectional images ... at 250 °C: (a) no additive, (b) 1 ppm,
       (c) 2 ppm, (d) 5 ppm.
```

So: every `\subfloat` needs BOTH the short `[...]` sub-caption AND a `\label`
inside its `{}`; the caption sits BELOW the figure with `\label` on the next
line; every panel is discussed in prose ("as shown in Fig.~\ref{...}").

**A sub-caption is at most three words**: `[During grinding]`, `[After
grinding]`, `[Before heating]`, `[Oil bath]`.

**Caption name.** Keep `\captionsetup[figure]{name=Fig.}` in the preamble: the
class prints "Figure 5.1" alone, while the rulebook and the last-semester
reports write "Fig. 5.1". Tables stay "Table N". A report without this line
reverts to the class default, which is a format deduction.

**Sizing.** `height=` for photos sharing a row (equal heights keep it tidy),
`width=` for a lone image; never set both without `keepaspectratio`.
Micrographs and measured photos state the **scale bar and the magnification** —
the teacher requires both, so ask when the user has not given them.

**An apparatus photo needs no scale bar or magnification.** A viscometer, a
thermostat bath, a bench shot: there is no magnification and no meaningful
scale, so the caption says what the object is ("The Ubbelohde viscometer
immersed in the thermostat") and spends no marker on numbers that do not
exist. The scale-bar rule is for micrographs and for photos from which a
length is being read.

**When the result is a fit or an extrapolation, generate the plot.** Put the
points, the least-squares line and the extrapolated intercept on the axes,
render it with matplotlib (`dpi=400`), and include it as a normal figure with
the fitted constants in the caption. Tabulated numbers alone do not show a
reader that the extrapolation is sound:

```python
import matplotlib; matplotlib.use("Agg")
import matplotlib.pyplot as plt, numpy as np
k, b = np.polyfit(c, eta_sp_over_c, 1)      # least-squares
plt.plot(c, eta_sp_over_c, 'o', label='data')
plt.plot(c, k*c + b, '-', label=f'fit: {k:.4f} c + {b:.4f}')
plt.axhline(b, ls=':', lw=0.8)              # the intercept read at c = 0
```

**A float-heavy page must not become a float-only page.** With five figures and
a table on ~6 pages the LaTeX defaults (`\floatpagefraction=0.5`) leave the
text jumping over a floats-only page with a blank band between table and
figure, and the log says nothing. Set a standard float configuration in the
preamble — never delete a figure and never leave the gap:

```latex
\setcounter{topnumber}{3}\setcounter{bottomnumber}{2}\setcounter{totalnumber}{4}
\renewcommand{\topfraction}{0.9}\renewcommand{\bottomfraction}{0.5}
\renewcommand{\textfraction}{0.1}\renewcommand{\floatpagefraction}{0.75}
```

Prevent it as well: prefer `[tbp]` over a bare `[h]` (which strands a float
mid-page), shrink an oversized panel (a 5480x3648 micrograph does not need more
than `width=0.6\textwidth`), and **declare floats in the order the text mentions
them** — a float declared early silently swaps figure numbers, so the prose
cites Fig. 5.2 before Fig. 5.3 appears. Re-check the `Fig.~\ref{}` order after
moving any float.

**Never delete a figure the user supplied to save a page.** Recover space from
prose, image height or float placement.

## Paragraph and heading shapes

- **Name the operation, never its step number.** "the mixture during and after
  the 5 min grinding", "the heating apparatus used for the transition
  measurement" — `step (3)` / `step (8)` / `step (10)` belong to the procedure
  list only, and nothing else in the report may depend on that numbering.
- **A section's first subsection precedes its first sentence.**
  `\section{Results and Discussion}` is followed immediately by
  `\subsection{Phenomena}`, with the prose starting inside it; no unscoped
  paragraph sits between them.
- **Section 3's three labels are three paragraphs**, one blank line apart, so
  all three carry the same first-line indent:

```latex
Chemicals: copper(II) chloride dihydrate (\ce{CuCl2.2H2O}), ethylenediamine
dihydrochloride (\ce{NH2(CH2)2NH2.2HCl}), isopropanol.

Apparatuses: electronic balance, suction filtration device, drying oven,
oil bath.

Tools: agate mortar and pestle, thermometer, weighing bottle.
```

  On three consecutive lines they collapse into one paragraph: only
  "Chemicals:" is indented and the other two drop to the left margin.
- **Label placement (from the .cls):** equation `\label` on the same line as
  `\begin{equation}`; float `\label` on its own line immediately after
  `\caption`; subfloat `\label` inside its `{}` group. No blank line before
  display math. Table captions above, figure captions below.

## Typography traps

- **Never hide a line-breaking defect with global settings** — no
  `\emergencystretch`, no `\tolerance` bump. A justified line stretched edge to
  edge before a display equation is exactly that artefact. Fix it where it
  happens: shorten the sentence, or give the long expression its own display
  equation.
- No decorative `\textbf` in prose, no `\boxed` values, no `====` divider
  comments in the `.tex`.

## Compile and verify

```bash
xelatex -interaction=nonstopmode -halt-on-error report.tex   # twice
pdfinfo report.pdf
```

Zero Overfull `\hbox` in the log before you call it done (grep it, then fix the
sentence); no undefined references; Principles within one page. Then render the
pages to PNG and look at them — a clipped image crop, a stretched row or a
figure stranded from its caption never shows up as an error.
