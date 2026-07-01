# Team Frontend Standards — AXEL

How any team member's AXEL builds frontend with the same standards as the lead — no per-task re-explanation, minimal post-hoc correction.

## What you get
- **`frontend-standards` skill** — auto-activates on frontend work; carries the Clean Code build discipline + routes you to the right design skill.
- **`design-audit` skill** — the default UX/UI validator; encodes the team's production HARD RULES (architecture, design system, a11y, brand voice).
- **`emil-design-eng` skill** — polish, animation, micro-interactions.
- **`frontend-review` agent** — the PR gate; run before marking any frontend PR ready.
- Plus the shipped `ui-ux-pro-max` skill and the `frontend-design` plugin.

## Install / update
```bash
cd <your clone of HxrmxStudio/axel-setup>
git pull
bash bootstrap.sh --profile personal --user-name "<You>" --language spanish
```
New files (the skills + agent) install directly. Changes to your existing `~/CLAUDE.md` arrive as upgrade-proposals in `~/.claude/axel-upgrades/` — review them by pasting into Claude Code:
```
Read the file ~/.claude/axel-upgrades/REVIEW.md and follow its instructions
```
Restart Claude Code to load the new skills/agent.

## Verify it works
1. Open any `.tsx` file in a frontend repo and start a task — `frontend-standards` / `design-audit` should surface.
2. On a frontend PR, run the `frontend-review` agent and confirm it reports findings by severity (BLOCKER / ISSUE / POLISH).

## Note on `impeccable`
The lead's `/impeccable` modal workflow ships from a local-directory marketplace and is not distributable. It is not part of the team package. `design-audit` is the canonical audit path for everyone.
