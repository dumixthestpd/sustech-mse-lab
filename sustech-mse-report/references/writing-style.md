# Writing style — SUSTech MSE lab reports

Origin: accumulated corrections from SUSTech MSE teaching-lab work plus the
department rulebook. They generalize to **any** report built with
`sustech-labreport.cls`, for any student in the department. This file is the
prose side — what to say, how to phrase it, what may never be claimed.
Typesetting mechanics live in `latex-conventions.md`.

## Voice

- Plain typography: no decorative `\textbf{}` emphasis, no `\boxed{}` values
  inside equations, no em dashes in prose (use commas, semicolons or full stops;
  `--` only for numeric ranges).
- **American spelling**: color, characterize, crystallize, vapor, analyze,
  meter, sulfur, liter, aluminum — never colour/characterise/crystallise/
  vapour/analyse/metre/sulphur/litre/aluminium. Hold it everywhere, captions
  and table headers included.
- One language per file. Reports are English; Chinese appears only where it
  belongs — the cover name, the teammate names.
- **Write the quantity, not its complement.** A 92.4 % yield is written 92.4 %,
  never "7.6 % below theoretical" or "a 101.5 mg shortfall"; the loss belongs
  in the report only when the shortfall itself is what the manual asks about.
- **Say nothing about what was not asked.** No "the uncertainty could not be
  quantified" and no instrument-precision lecture: this is not a physics lab
  report, and if no uncertainty is required the report does not mention one.
- **Answer exactly what was asked.** "Give an example" is one example; a
  two-part question gets two parts, not a catalogue. Extra items read as
  padding and dilute the one that answers.
- Typos and half-English phrases in the manual are the manual's — write correct
  English.
- **Two tightly-coupled claims go in one flowing paragraph** (semicolons), not
  an enumerated list. Durations of workup steps are not results: "briefly",
  "until effervescence stopped"; quantify a duration only when it is the
  measured result or a step the handout fixed ("60 °C, 0.5 h").

## Claims and numbers

- Numbers come only from the user, the manual, or a derivation from the real
  data. Recompute every derived value yourself (molar masses, limiting reagent,
  theoretical and percentage yield): a wrong molar mass is silently
  self-consistent and travels into the table, the discussion and the
  conclusion.
- **Never invent an uncertainty** ("±1 °C") that neither the manual nor the
  user stated.
- **No illogical causal chains.** "Complete solid-state conversion is supported
  by the loss of the blue-green colour after grinding" is not evidence: the
  colour goes because the product forms, and a strongly coloured filtrate means
  copper and chloride were washed away — a yield-loss term, not a measure of
  conversion.
- **A raw-data line ending in "is" is the student filling in a blank.**
  `cucl2 2h2o is ` asks for the substance's name (copper(II) chloride
  dihydrate, `\ce{CuCl2.2H2O}`), not a molar mass. Answer what the blank asks.
- **A characterisation with no data is not claimed.** If the manual asks for an
  FTIR spectrum and none exists, Principles may still explain the principle,
  and §5 depends on what the student said: if the data **states it was not
  performed** ("we did not do FTIR"), write that plainly ("the infrared
  spectrum was not recorded in this session") and leave no marker; if the data
  is **silent**, keep one marker asking whether it was recorded. Either way the
  Conclusion lists only what was measured and never "the identity of the
  compound was checked by infrared spectroscopy" — a marker in §5 beside a
  completed claim in §6 is a contradiction the reader will catch.
- **One marker per gap** — raised once, where the answer is needed, never
  repeated in both the prose and the caption.
- Report the critical derived values, not every intermediate: the result that
  answers "what did you get" (yield, transition temperature, key constant),
  not every raw reading or single-step calculation.
- Describe what a test DID, not its label: "the paper turned dark and slowly
  faded to white", not "pH > 13". Where two spectra or curves look essentially
  the same, say so and state the inference — do not produce a point-by-point
  differential list that shows nothing.

## Photos — never interpret an image

You were not in the lab and the photos belong to someone who was. **Never read a
picture to write a caption or a conclusion**: no "strongly birefringent", no
"sharp angular crystallites", no "the thermometer reads X", no colour claim the
user did not make, no morphology inference from a micrograph.

**Ration the `<ASK USER>` markers.** Ask only when a conclusion must be drawn
FROM the image — a micrograph whose morphology is under discussion, the
before/after pair that is the evidence, a scale bar or reading that has to be
stated. An illustrative photo whose purpose is obvious (apparatus, setup, bench
shot) gets a plain caption and no marker. Every marker costs the user
attention; spend them on real gaps only.

**A filename is the student's own label, so it may name a thing.**
`oil-bath-device.jpg` is the student saying "this is the oil-bath device", so
write "the heating apparatus (oil bath)" and stop — do not add a marker asking
the student to name a device their filename already names. A filename may never
supply a *result*: no scale bar, magnification, morphology or reading is ever
lifted from a name, including the `600x` in one.

When a conclusion does need image content, ask the user what they saw — one
short list of questions, once — and leave an `<ASK USER: ...>` marker until they
answer.

**The user's photo beats the manual's example.** Where the manual shows a picture
of something the user has photographed — the device, the setup, the product, the
phenomenon — use the user's photo and drop the manual's: theirs shows the actual
instrument and the actual result. Keep the manual's figure only where the user
has nothing equivalent (typically the theory diagram in Principles).

**A figure taken from the course handout carries no credit line.** Never write
"reproduced from the manual", "from the handout", "(Ref. 1)" or any equivalent
in a caption: the handout is course material that the whole class works from,
and the report never mentions it — the same rule as the References section.

## Section discipline

- **Objectives: one infinitive and one object per bullet.** Three goals in the
  manual become three bullets; "To characterise the product: to determine X, to
  observe Y, and to measure Z" and "To characterize the product by its A, its B
  and its C" are both the same error — a list wearing a single bullet's clothes.
- Principles: ≤ 1 page, condensed from the manual, and it **carries the manual's
down  key equations written out** — every symbol defined, no derivation. A
  sentence paraphrasing a formula is not a substitute for the formula. The
  reader knows the chemistry — no textbook background.
- Procedure: numbered steps following the in-class parameters, reduced from the
  manual, with no result numbers in them — results live in §5.
- **Section 5 runs `Phenomena` → `Experimental Data` → `Error Analysis`**, the
  order of the work: you see, then you calculate, then you analyze.
  - `Phenomena` is plain prose with no numbers in it, named `Phenomena` —
    nothing observed in a teaching lab is anomalous, and the word tells the
    reader nothing. Something that surprised you gets described in ordinary
    words inside it.
  - A data subsection never opens with the table and is never table-only: two
    or three sentences carry the key measured numbers, then the table.
  - **One loss, one paragraph** — a one-sentence opening that names the sources,
    then a paragraph per source, each closing with the measure that reduces it.
    Keep it physical and short: the real sources, their magnitude where the data
    supports it, the one measure that reduces each. No meta-commentary on the
    balance's precision, no lecture on what could not be quantified, no loss
    counted twice.
- **Conclusion: one paragraph, about 100 words.** The rulebook's "~300 words"
  caps the whole section, never each paragraph. It holds what was made, how, the
  mass, the yield and the one measured temperature:

  > `\ce{[H3N(CH2)2NH3]CuCl4}` was successfully prepared by grinding
  > `\ce{CuCl2.2H2O}` (0.85 g) with `\ce{NH2(CH2)2NH2.2HCl}` (0.67 g) and
  > heating the mixture at 60 °C for 0.5 h; 1.2321 g of yellow product was
  > isolated, 92.4 % of the 1.3336 g expected from the limiting copper salt.
  > The product changed color at 94 °C.

  **The Error Analysis owns the causes; the Conclusion states the result.** The
  loss may be named once in the Error Analysis because explaining it is that
  section's job; the Conclusion gives the yield and stops. Re-adding "the mass
  below the theoretical value is accounted for by ..." there is what makes the
  section grow. No "we learned", no "challenging but rewarding", no personal
  pronouns.
- Questions: restate the manual's question, then answer in two or three
  sentences — one physical reason plus one observation from this experiment. No
  textbook recital.

## References

Real literature only. **The course manual is never cited** — the whole class
works from it. With nothing else to cite, omit the section entirely.

## Test before you send prose

If a sentence does not move the reader closer to the numbers and the cause, cut
it. Verbosity in a lab report is the same sin as verbosity in a code comment.
