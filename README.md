# Research Workflow
Instructions for agents to do research in this repo and its workflow.

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
* If you cite a number of a scale, provide also its percentage as the constext of the full scale. For example a (number) of jobs opened in a country, which is a (number) % of the total scale.
* The research file shall start with a short section "About" describint what is it about and anfter that is a short section "Summary" describing the results found.
* Never do any git tasks unless you are explicitly instructed to do so.
* Focus on the data and plot charts if possible.

## Making a Research
* When asked to research a topic do the following steps from 1 till the last.

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
