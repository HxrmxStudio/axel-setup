#!/bin/zsh
# PostToolUse hook (matcher: Edit|Write|MultiEdit): deterministic frontend standards gate.
# After an edit to a frontend file, runs cheap grep checks for common Clean Code /
# design-system violations and reminds to run the design-audit skill / frontend-review
# agent before marking a PR ready. Non-blocking (warnings only, exit 0). Companion to
# the frontend-standards skill and the frontend-review agent. Invoked via bash, so all
# array syntax below is bash-compatible.

# Resolve edited file path (JSON stdin first, then env var) — same pattern as post-edit-lint.sh
FILE=""
if [ -n "$TOOL_INPUT_FILE_PATH" ]; then
  FILE="$TOOL_INPUT_FILE_PATH"
elif [ -n "$HOOK_TOOL_INPUT" ]; then
  FILE=$(echo "$HOOK_TOOL_INPUT" | python3 -c "import sys,json; print(json.loads(sys.stdin.read()).get('file_path',''))" 2>/dev/null)
fi

if [ -z "$FILE" ] || [ ! -f "$FILE" ]; then
  exit 0
fi

# Only act on frontend files
case "$FILE" in
  *.tsx|*.jsx|*.ts|*.vue|*.svelte|*.css|*.scss) ;;
  *) exit 0 ;;
esac

findings=()

# Hardcoded hex colors — only in component files (.css/.scss legitimately define tokens)
case "$FILE" in
  *.tsx|*.jsx|*.vue|*.svelte)
    if grep -nE '#[0-9a-fA-F]{3,8}\b' "$FILE" >/dev/null 2>&1; then
      findings+=("hardcoded hex color — use design tokens (bg-*, text-*), not raw colors")
    fi ;;
esac

# `: any` in TS/TSX
case "$FILE" in
  *.tsx|*.ts)
    if grep -nE ':[[:space:]]*any\b' "$FILE" >/dev/null 2>&1; then
      findings+=("\`: any\` type — use \`unknown\` + narrow, or a concrete type")
    fi ;;
esac

# Leftover console.log / console.debug
if grep -nE 'console\.(log|debug)' "$FILE" >/dev/null 2>&1; then
  findings+=("leftover console.log/debug — remove before PR")
fi

# Inline style objects with raw values
if grep -nE 'style=\{\{' "$FILE" >/dev/null 2>&1; then
  findings+=("inline style={{...}} — prefer design-system classes/tokens")
fi

if [ ${#findings[@]} -eq 0 ]; then
  exit 0
fi

echo "frontend-standards: $(basename "$FILE")" >&2
for finding in "${findings[@]}"; do
  echo "   - $finding" >&2
done
echo "   -> run the design-audit skill / frontend-review agent before marking the PR ready" >&2
exit 0
