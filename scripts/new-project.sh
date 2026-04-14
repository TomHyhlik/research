#!/usr/bin/env bash
# new-project.sh — Create a new numbered research project directory
#
# Usage:
#   new-project.sh <project-short-name> [input-prompt]
#
# Example:
#   new-project.sh sleep-optimization "Research the effects of sleep on cognitive performance"
#
# Output:
#   Creates: projects/011-sleep-optimization/
#   Creates: projects/011-sleep-optimization/input-prompt.md  (if prompt provided)
#   Prints the new directory path.

set -euo pipefail

RESEARCH_DIR="$(cd "$(dirname "$0")/.." && pwd)"

if [[ $# -lt 1 ]]; then
    echo "Usage: $0 <project-short-name> [input-prompt]"
    exit 1
fi

NAME="$1"
PROMPT="${2:-}"

# Find highest existing three-digit prefix
LAST=$(ls "$RESEARCH_DIR/projects/" | grep -E '^[0-9]{3}-' | sort | tail -1 | grep -oE '^[0-9]{3}' || echo "000")
NEXT=$(printf "%03d" $(( 10#$LAST + 1 )))

DIR="$RESEARCH_DIR/projects/${NEXT}-${NAME}"
mkdir -p "$DIR"

if [[ -n "$PROMPT" ]]; then
    echo "$PROMPT" > "$DIR/input-prompt.md"
fi

echo "$DIR"
