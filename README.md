# Research
Instructions for agents to do research in this repo.

## Tools
Tools to be used in this workflow.
* To convert a file .md to .pdf use the tool at "../text2podcast" ([text2podcast](https://github.com/TomHyhlik/text2podcast))
  * Command: `.venv/bin/python md2pdf.py <file.md>`
  * Output: `<file.pdf>` placed next to the input file
* To convert a file .md or .pdf to .mp3 use the tool at "../text2podcast" ([text2podcast](https://github.com/TomHyhlik/text2podcast))
  * Command: `.venv/bin/python text2podcast.py <file.md|file.pdf>`
  * Output: `<file.mp3>` placed next to the input file
  * Both `.md` and `.pdf` inputs are supported
  * Optional flags: `--voice <voice-name>`, `--offline`, `-o <output.mp3>`
* To send a file use the tool at "../sender-tool" ([sender-tool](https://github.com/TomHyhlik/sender-tool))


## Rules
* Treat every research task as an evidence review, not an opinion essay. Separate measured facts, source claims, expert interpretation, and your own inference.
* State the research question, scope, geography, time period, and important exclusions early in the report when they are not obvious from the prompt.
* Prefer primary and high-quality sources: official statistics, peer-reviewed papers, regulator reports, company filings, court records, reputable datasets, and named expert institutions. Use news articles mainly for recent events, quotes, timelines, or when primary data is unavailable.
* For fast-changing topics, verify recency. Include publication dates or data periods for important sources, and do not present old data as current.
* Cite sources inline with links for all non-obvious factual claims, statistics, rankings, legal claims, medical claims, financial claims, and controversial statements.
* If sources disagree, report the disagreement. Explain the likely reason: different definitions, data periods, samples, geographies, incentives, or methodology.
* If you cite a number that is part of a larger scale, provide the denominator and percentage where possible. Example: `12,000 jobs, equal to 8.4% of the 143,000-job national total`.
* Always define units, currencies, dates, baselines, and whether numbers are nominal, real, seasonally adjusted, annualized, per capita, or index values.
* Include uncertainty. State confidence levels qualitatively when useful, list assumptions, and identify the most important missing data.
* Compare like with like. When comparing countries, cities, time periods, or groups, normalize where appropriate by population, GDP, households, land area, age group, or other relevant denominator.
* Use tables for structured comparisons and charts for important quantitative patterns. If a chart is not possible, include a readable text chart or a clearly labeled table.
* For forecasts and scenarios, provide at least a base case and a stress case, with triggers that would make each case more likely.
* For medical, legal, financial, safety, or public-policy topics, add an explicit limitations note and avoid giving personalized professional advice unless the user asked for general educational analysis only.
* Keep claims proportional to the evidence. Use precise language such as `suggests`, `is consistent with`, `is associated with`, or `is likely` when certainty is limited.
* Preserve enough methodological detail that another researcher could audit the work: key search terms, dataset names, date ranges, and calculations should be visible in the report or source notes when relevant.
* Never do any git tasks unless explicitly instructed to do so.
* Preserve `input-prompt.md` as the original user prompt without rewriting it.



## Structure
* The research file shall start with a short section `About` describing what the report covers, followed by a short section `Summary` describing the main findings.


## Workflow
When asked to research a topic do the following steps :

1. Research the topic in depth on the internet.
2. For every research, create a new directory inside projects/ with the research name, prefixed by an incrementing three-digit number (e.g. 009-research-name). Determine the next number by listing the existing directories and incrementing the highest prefix by one. Save the original input prompt to `input-prompt.md` inside the new directory. **`input-prompt.md` is never converted to PDF — it stays as a plain .md file only.**
3. Inside the research directory create a research_name.md and put the research in it.
4. Create research_name_podcast.md from the research_name.md, which is basically the same, but charts, tables and so are read so it is understandable to somebody who just listens to it and doen'st see it. Don't add any subtitle "Podcast Version" and similar.
5. Convert the research_name.md to research_name.pdf
6. Generate a podcast MP3 audio file research_name.mp3 from the research_name_podcast.md.
7. Send the MP3 and the PDF files.

## Scripts

Two helper scripts in `scripts/` automate the file operations from the workflow above:

### `scripts/new-project.sh <name> [input-prompt]`
Creates the next numbered project directory under `projects/`.
- Auto-detects the highest existing `NNN-` prefix and increments by 1
- If an input prompt is provided, saves it to `input-prompt.md` inside the new directory
- Example: `scripts/new-project.sh sleep-optimization "Research sleep effects"` → creates `projects/011-sleep-optimization/` with `input-prompt.md`

### `scripts/publish.sh <project-dir-name> [mode]`
Converts and sends a finished research project. Runs all three steps by default:
1. Converts `<name>.md` → `<name>.pdf` using `md2pdf.py`
2. Converts `<name>_podcast.md` → `<name>.mp3` using `text2podcast.py`
3. Sends PDF then MP3 sequentially via Telegram (never in parallel — causes 400 errors)

Optional modes:
- `--pdf-only` — only generate the PDF
- `--mp3-only` — only generate the MP3
- `--send-only` — only send existing PDF and MP3

Example: `scripts/publish.sh 009-lucid-dreaming`

## Commands

When the user says `/publish` or "publish <project>", run:
```
scripts/publish.sh <project-dir-name>
```
This executes all file operations (pdf, mp3, send) for the given project.

When the user says `/new-project <name>` or "new project <name>", run:
```
scripts/new-project.sh <name> "<full original user prompt>"
```
Pass the user's full original prompt as the second argument so it is saved to `input-prompt.md` inside the new project directory.
