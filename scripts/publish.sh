#!/usr/bin/env bash
# publish.sh — Convert and send a research project's PDF and MP3
#
# Usage:
#   publish.sh <project-dir-name>
#   publish.sh <project-dir-name> --pdf-only
#   publish.sh <project-dir-name> --mp3-only
#   publish.sh <project-dir-name> --send-only
#
# Examples:
#   publish.sh 009-lucid-dreaming
#   publish.sh 010-mindfulness-thought-control --send-only

set -euo pipefail

RESEARCH_DIR="$(cd "$(dirname "$0")/.." && pwd)"
TEXT2PODCAST_DIR="/home/fuzz/Repos/text2podcast"
SENDER="$HOME/Repos/sender-tool/telegram/send-file.sh"

usage() {
    echo "Usage: $0 <project-dir-name> [--pdf-only|--mp3-only|--send-only]"
    echo ""
    echo "Available projects:"
    ls "$RESEARCH_DIR/projects/" | sort
    exit 1
}

[[ $# -lt 1 ]] && usage

PROJECT_NAME="$1"
MODE="${2:-}"
PROJECT_DIR="$RESEARCH_DIR/projects/$PROJECT_NAME"

if [[ ! -d "$PROJECT_DIR" ]]; then
    echo "ERROR: Project directory not found: $PROJECT_DIR"
    usage
fi

# Derive base name: strip leading NNN- prefix, then use as stem
STEM="${PROJECT_NAME#[0-9][0-9][0-9]-}"

# Find the main .md file: prefer stem-named file, fall back to any non-podcast, non-input-prompt .md
STEM_MD="$PROJECT_DIR/${STEM}.md"
if [[ -f "$STEM_MD" ]]; then
    MD_FILE="$STEM_MD"
else
    MD_FILE=$(find "$PROJECT_DIR" -maxdepth 1 -name "*.md" ! -name "*_podcast*" ! -name "input-prompt.md" | sort | head -1)
fi
PODCAST_MD=$(find "$PROJECT_DIR" -maxdepth 1 -name "*_podcast.md" | head -1)
PDF_FILE="$PROJECT_DIR/${STEM}.pdf"
MP3_FILE="$PROJECT_DIR/${STEM}.mp3"

if [[ -z "$MD_FILE" ]]; then
    echo "ERROR: No .md file found in $PROJECT_DIR"
    exit 1
fi

echo "Project:    $PROJECT_NAME"
echo "Main MD:    $MD_FILE"
echo "Podcast MD: ${PODCAST_MD:-<not found>}"
echo "PDF:        $PDF_FILE"
echo "MP3:        $MP3_FILE"
echo ""

# Step: Convert MD → PDF
convert_pdf() {
    echo "==> Converting MD → PDF..."
    cd "$TEXT2PODCAST_DIR"
    .venv/bin/python md2pdf.py "$MD_FILE"
    echo "    Done: $PDF_FILE"
}

# Step: Convert podcast MD → MP3
convert_mp3() {
    if [[ -z "$PODCAST_MD" ]]; then
        echo "WARNING: No _podcast.md found; skipping MP3 generation."
        return
    fi
    echo "==> Converting podcast MD → MP3..."
    "$TEXT2PODCAST_DIR/.venv/bin/python" "$TEXT2PODCAST_DIR/text2podcast.py" "$PODCAST_MD" -o "$MP3_FILE"
    echo "    Done: $MP3_FILE"
}

# Step: Send files via Telegram (sequentially — parallel causes 400 errors)
send_files() {
    if [[ -f "$PDF_FILE" ]]; then
        echo "==> Sending PDF: $PDF_FILE"
        "$SENDER" --file "$PDF_FILE" --caption "$PROJECT_NAME"
    else
        echo "WARNING: PDF not found, skipping: $PDF_FILE"
    fi

    if [[ -f "$MP3_FILE" ]]; then
        echo "==> Sending MP3: $MP3_FILE"
        "$SENDER" --file "$MP3_FILE" --caption "$PROJECT_NAME"
    else
        echo "WARNING: MP3 not found, skipping: $MP3_FILE"
    fi
}

case "$MODE" in
    --pdf-only)  convert_pdf ;;
    --mp3-only)  convert_mp3 ;;
    --send-only) send_files ;;
    "")
        convert_pdf
        convert_mp3
        send_files
        ;;
    *)
        echo "ERROR: Unknown option: $MODE"
        usage
        ;;
esac

echo ""
echo "Done."
