% =============================================================================
% sustech-labreport.cls — General SUSTech Lab Report Class (MSE teaching labs)
% =============================================================================
% Merged from:
%   - sustech-exp-report-2026sp.cls (PhyChemExp / GOrganicExp, Spring 2026),
%     including the later evolved variant (chemfig/mhchem/subfig/makecell,
%     biblatex+biber, footnote spacing fix, centered captions)
%   - the official BB report template .docx for
%     "Experiments for Advanced Materials Science and Engineering I"
%     (材料科学与工程系教学实验室实验报告通用模板) — cover fields follow the
%     docx: Name / Student ID / Date of experiment / Date of submission /
%     Team member.
%
% Course-agnostic: every course-specific value is an argument of \makesutitle.
%
% Usage:
%   \documentclass{sustech-labreport}      % 12pt (小四) baked in
%   \begin{document}
%   \makesutitle
%     {<Course name>}
%     {Experiment N: <Experiment title>}
%     {<name>}        % name (Chinese OK — xeCJK)
%     {<sid>}      % student ID
%     {YYYY/MM/DD}    % date of experiment
%     {YYYY/MM/DD}    % date of submission
%     {<teammates>}   % teammates joined with ， (full-width comma); {} if none
%   \section{Objectives}      % headings auto-numbered: 1., 2., ...
%
% =============================================================================
% HARD RULES — VIOLATING THESE BREAKS THE PDF OR THE RUBRIC
% =============================================================================
%  1. LABEL PLACEMENT:
%     Equation: \label on SAME LINE as \begin{equation}
%     Float:    \label IMMEDIATELY after \caption (own line)
%     NEVER put \label on a line by itself.
%  2. CAPTION SETUP: Table caption ABOVE the table, figure caption BELOW.
%  3. NO BLANK LINE BEFORE DISPLAY MATH.
%  4. Red/annotation text from the .docx template is NEVER included in a
%     submission (it is instruction/example text).
%  5. Chinese via xeCJK: \textbf{<name>}, no font commands.
%  6. NO blank line inside \begin{align}...\end{align}.
%  7. Report ~6 pages total (cover 5% / format 25% / content 70% of grade).
%     Principles section stays within one page.
% =============================================================================

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{sustech-labreport}[2026/09/07 General SUSTech Lab Report Class]

% =============================================================================
% PARENT CLASS — 12pt baked in (小四 per the BB template); oneside A4
% =============================================================================
\LoadClass[a4paper,12pt,oneside]{article}

% =============================================================================
% MARGINS — 2.5 cm all sides (BB template)
% =============================================================================
\RequirePackage[
  top=2.5cm,
  bottom=2.5cm,
  left=2.5cm,
  right=2.5cm,
  headheight=1.24cm,
  headsep=0cm,
  footskip=0.5cm,
]{geometry}

% =============================================================================
% FONTS — XeLaTeX / LuaLaTeX preferred (Times New Roman + xeCJK for 中文),
% pdflatex falls back to the times package.
% =============================================================================
\RequirePackage{iftex}
\ifLuaTeX
  \RequirePackage{fontspec}
  \setmainfont{Times New Roman}[BoldFont={Times New Roman Bold}]
\else\ifXeTeX
  \RequirePackage{fontspec}
  \setmainfont{Times New Roman}[BoldFont={Times New Roman Bold}]
  \RequirePackage{xeCJK}
\else
  \RequirePackage{times}
  \RequirePackage[T1]{fontenc}
\fi\fi

% =============================================================================
% CAPTION SETUP — centered captions, tight spacing
% =============================================================================
\RequirePackage[labelsep=quad, font=normal, skip=5pt]{caption}
\captionsetup[figure]{skip=2pt}
\captionsetup[table]{skip=0pt}
\captionsetup{justification=centering}

% =============================================================================
% LINE SPACING — 1.5 (docx: "固定值 20磅 或 1.5倍行距")
% =============================================================================
\RequirePackage{setspace}
\setstretch{1.5}
\parindent=0.64cm

% =============================================================================
% AMS MATH
% =============================================================================
\RequirePackage{amsmath,amssymb}
\numberwithin{equation}{section}

% =============================================================================
% GRAPHICS & FLOATS — three-line tables, sub-figures, chemistry typesetting
% =============================================================================
\RequirePackage{graphicx}
\RequirePackage{float}
\RequirePackage{booktabs}
\RequirePackage{chemfig}
\RequirePackage[version=4]{mhchem}
\RequirePackage{subfig}
\RequirePackage{makecell}
\counterwithin{figure}{section}
\counterwithin{table}{section}

% =============================================================================
% HYPERLINKS
% =============================================================================
\RequirePackage{hyperref}
\hypersetup{colorlinks=false, pdfborder={0 0 0}, hidelinks}

% =============================================================================
% PAGE HEADER — "SUSTech / Department of MSE", NO page numbers (BB docx
% header1: two centred lines)
% =============================================================================
\RequirePackage{fancyhdr}
\pagestyle{fancy}
\fancyhf{}
\fancyhead[C]{%
  \fontsize{10.5pt}{12.5pt}\selectfont\bfseries
  Southern University of Science and Technology\par
  Department of Material Science and Technology}
\fancyfoot{}
\makeatletter
\def\headrulewidth{0pt}
\def\footrulewidth{0pt}
\makeatother

% =============================================================================
% SECTION FORMATTING — titlesec
% =============================================================================
\RequirePackage{titlesec}
\titleformat{\section}{\fontsize{12pt}{20pt}\selectfont\bfseries}{\thesection.}{0.5em}{}[]
\titleformat{\subsection}{\fontsize{12pt}{20pt}\selectfont}{\thesubsection}{0.5em}{}[]
\titleformat{\subsubsection}{\fontsize{12pt}{20pt}\selectfont}{\thesubsubsection}{0.5em}{}[]
\titlespacing*{\section}{0pt}{0pt}{0pt}
\titlespacing*{\subsection}{0pt}{0pt}{0pt}
\titlespacing*{\subsubsection}{0pt}{0pt}{0pt}
\RequirePackage{indentfirst}

% =============================================================================
% ENUMERATE — (1), (2), (3) ... format
% =============================================================================
\RequirePackage{enumitem}
\setlist[enumerate]{label={(\arabic*)},leftmargin=\parindent,itemindent=0pt,parsep=0pt,partopsep=0pt,topsep=6pt}

% =============================================================================
% BIBLIOGRAPHY — biblatex with biber. Must load AFTER hyperref.
% Each report supplies its own refs.bib in the same folder.
% =============================================================================
\RequirePackage[backend=biber,style=numeric,sorting=none]{biblatex}

% =============================================================================
% FOOTNOTE SPACING — setstretch{1.5} above would make footnotes run long.
% Reset the footnote text block to single spacing and a smaller font.
% =============================================================================
\makeatletter
\renewcommand{\@makefntext}[1]{%
  \setstretch{1.0}\footnotesize\noindent
  \hb@xt@1.8em{\hss\@makefnmark\,}#1}
\makeatother

% =============================================================================
% COVER PAGE — \makesutitle{course}{title}{name}{id}{expdate}{subdate}{teammates}
% Mirrors the BB docx cover: course name / Lab Report / Experiment N: Title /
% Name / Student ID / Date of experiment / Date of submission / Team member
% =============================================================================
\newcommand\makesutitle[7]{%
  \vspace*{0pt plus 1fill}%
  \begin{center}
    {\fontsize{18pt}{22pt}\selectfont\bfseries
      #1\par
    }%
  \end{center}
  \vspace{1.2cm}%
  \begin{center}
    {\fontsize{18pt}{22pt}\selectfont\bfseries Lab Report\par}%
  \end{center}
  \vspace{1.2cm}%
  \begin{center}
    {\fontsize{20pt}{24pt}\selectfont\bfseries
      #2\par
    }%
  \end{center}
  \vspace{6cm}%
  \hfill
  \begin{tabular}{r l}
    {\fontsize{12pt}{20pt}\selectfont\bfseries Name:} &
    \textbf{#3}\protect\\[10pt]
    {\fontsize{12pt}{20pt}\selectfont\bfseries Student ID:} &
    \textbf{#4}\protect\\[10pt]
    {\fontsize{12pt}{20pt}\selectfont\bfseries Date of experiment:} &
    \textbf{#5}\protect\\[10pt]
    {\fontsize{12pt}{20pt}\selectfont\bfseries Date of submission:} &
    \textbf{#6}\protect\\[10pt]
    {\fontsize{12pt}{20pt}\selectfont\bfseries Team member (if any):} &
    \textbf{#7}\protect\\
  \end{tabular}
  \par
  \vspace*{0pt plus 1fill}%
  \newpage
}

\endinput
