# Team Frontend Standardization Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Make a teammate's AXEL (Alex's) build frontend with the same UX/UI + Clean Code standards as the lead, distributed via the `HxrmxStudio/axel-setup` fork, enforced by auto-activating skills and a PR gate.

**Architecture:** Skill-centric (Approach A). Vendor the two missing standards-bearing skills (`design-audit`, `emil-design-eng`), add a lean router skill (`frontend-standards`) and a PR-gate agent (`frontend-review`), reinforce in `templates/CLAUDE.md`, and document onboarding. New files reach an existing-AXEL user directly via the additive bootstrap; CLAUDE.md edits arrive as upgrade-proposals.

**Tech Stack:** Markdown skills (`SKILL.md` + optional `agents/openai.yaml`), markdown agent definitions (frontmatter `description` + `tools`), `bootstrap.sh` (Bash) install verification via `--dry-run`.

**DRY principle (locked):** `design-audit` is the single source of truth for the rules/checklist. `frontend-standards` is build-time discipline + router (no duplication of design-audit's tables). `frontend-review` references design-audit's checklist as its rubric (does not copy it).

**Branch:** `feat/frontend-standards-team` (already created, spec committed at `0f729b3`). Commit format: `type (Scope): message` (enforced by `validate-commit-format.sh` — never `--no-verify`).

**Note on impeccable:** its marketplace source is a local directory (`~/.claude/plugin-sources/impeccable`), so it is NOT distributable to teammates. It stays lead-local. `design-audit` is the default audit path for everyone. The router lists impeccable as "(lead-local, optional)".

---

### Task 1: Vendor the `design-audit` skill into the fork

**Files:**
- Create: `skills/design-audit/SKILL.md` (copied from `~/.agents/skills/design-audit/SKILL.md`)
- Create: `skills/design-audit/agents/openai.yaml` (copied)

- [ ] **Step 1: Copy the skill**

```bash
cd ~/axel-setup
mkdir -p skills/design-audit/agents
cp ~/.agents/skills/design-audit/SKILL.md skills/design-audit/SKILL.md
cp ~/.agents/skills/design-audit/agents/openai.yaml skills/design-audit/agents/openai.yaml
```

- [ ] **Step 2: Verify frontmatter is intact (name + description present)**

Run: `head -5 skills/design-audit/SKILL.md`
Expected: YAML frontmatter with `name: design-audit` and a `description:` line.

- [ ] **Step 3: Verify the bootstrap will install it as a new skill**

Run: `bash bootstrap.sh --dry-run --profile personal --user-name "Test" 2>&1 | grep design-audit`
Expected: a line like `Would add skill asset: design-audit/SKILL.md` (skill is new to a clean target). On the lead's own machine it may show as already present — that is fine; the check is that bootstrap discovers it.

- [ ] **Step 4: Commit**

```bash
git add skills/design-audit/
git commit -m "feat (skills): vendor design-audit skill into team fork"
```

---

### Task 2: Vendor the `emil-design-eng` skill into the fork

**Files:**
- Create: `skills/emil-design-eng/SKILL.md` (copied)
- Create: `skills/emil-design-eng/agents/openai.yaml` (copied)

- [ ] **Step 1: Copy the skill**

```bash
cd ~/axel-setup
mkdir -p skills/emil-design-eng/agents
cp ~/.agents/skills/emil-design-eng/SKILL.md skills/emil-design-eng/SKILL.md
cp ~/.agents/skills/emil-design-eng/agents/openai.yaml skills/emil-design-eng/agents/openai.yaml
```

- [ ] **Step 2: Verify frontmatter**

Run: `head -5 skills/emil-design-eng/SKILL.md`
Expected: frontmatter with `name: emil-design-eng` and a `description:`.

- [ ] **Step 3: Verify bootstrap discovery**

Run: `bash bootstrap.sh --dry-run --profile personal --user-name "Test" 2>&1 | grep emil-design-eng`
Expected: a `skill asset: emil-design-eng/SKILL.md` line.

- [ ] **Step 4: Commit**

```bash
git add skills/emil-design-eng/
git commit -m "feat (skills): vendor emil-design-eng skill into team fork"
```

---

### Task 3: Author the `frontend-standards` router skill (NEW)

**Files:**
- Create: `skills/frontend-standards/SKILL.md`

- [ ] **Step 1: Write the skill file**

Create `skills/frontend-standards/SKILL.md` with exactly:

```markdown
---
name: frontend-standards
description: "Proactive frontend build standards and skill router for the team. Use when writing or modifying frontend code (.tsx/.jsx/.vue/.svelte/.css/.scss) or when the task mentions component, hook, presentational, business logic, SoC, clean code, SRP, DRY, KISS, modular, design, UX, UI, polish, refinar, spacing, layout, popover, tooltip, accessibility, a11y, design tokens. Routes to design-audit (review), emil-design-eng (polish), impeccable (modal workflow, lead-local), frontend-design (greenfield), ui-ux-pro-max (reference)."
license: MIT
---

# Frontend Standards — How the team builds frontend

This skill carries the team's build-time frontend discipline and routes you to the right specialist skill. It is the PROACTIVE counterpart to `design-audit` (which VALIDATES finished work). Do not duplicate design-audit's checklists here — defer to it.

## When this activates
- Writing or editing `.tsx/.jsx/.vue/.svelte/.css/.scss`
- Task mentions: component, hook, presentational, business logic, SoC, clean code, SRP/DRY/KISS, modular, design, UX/UI, polish, refinar, spacing, layout, popover, tooltip, a11y, design tokens

## 1. Clean Code frontend rules (apply WHILE writing)
Robert C. Martin discipline, enforced at build time — not retrofitted in review.

- **Separation of concerns (HARD):**
  - Components (`components/*.tsx`) → presentation only. No business logic, no data fetching.
  - Hooks (`hooks/use*.ts`) → business logic, state, data fetching, side effects.
  - Utils/lib (`lib/`, `utils/`) → pure, side-effect-free, independently testable.
- **SRP / DRY / KISS / YAGNI** — one responsibility per unit; no duplicated logic; smallest valid change first; no speculative abstraction.
- **Add-on principle** — extend existing modules; never fork parallel `*-v2` copies.
- **Naming** — declarative (`handleUserClick`, not `onClick2`); no single-letter vars (only `idx`, `err`); no `any` in TypeScript (use `unknown` + narrow, or a concrete type).
- **Size** — functions < 20 lines, components < 100 lines, files < 400 lines typical (800 max). Growth past this is the signal to extract a hook or split.
- **Immutability** — return new objects; never mutate in place.
- **No magic strings/numbers** — use design tokens and named constants.
- **Errors** — handle explicitly at boundaries; never silently swallow.

## 2. Design system (never hardcode)
- Use design tokens, never raw colors (`#fff`, `rgb(...)`) or random pixel spacing. Use the repo's scale (`p-2/4/6/8`, `bg-background`, `text-foreground`).
- The target repo's design system is authoritative.
- The deep per-repo token/path map lives in `design-audit` — consult it for specifics.

## 3. Skill router — which skill, when
| Intent | Skill | Notes |
|---|---|---|
| Review / refine / audit existing UI; pre-PR visual check | **design-audit** | Default for review/refinement. |
| Polish, animation, micro-interactions, "feel right" | **emil-design-eng** | When functional but lacks feel. |
| Explicit modal workflow (`/impeccable audit|polish|critique|distill|clarify`) | **impeccable** | Lead-local, optional — not in the team package. |
| Greenfield surface (new page/feature from scratch) | **frontend-design** + **ui-ux-pro-max** | In the plan phase. |
| Reference look-up (palette, font pairing, chart pattern) | **ui-ux-pro-max** | Catalog. |

Default operating rule: build with sections 1–2 discipline → reach for `design-audit` before marking any frontend work ready.

## 4. Before marking frontend work ready
Run the **`design-audit` Pre-PR checklist** (architecture, design-system, refinement, a11y, brand voice). For PRs touching frontend files, the **`frontend-review` agent** is the gate — see the team CLAUDE.md "PR Review Process".
```

- [ ] **Step 2: Verify frontmatter parses and required keys exist**

Run: `head -4 skills/frontend-standards/SKILL.md && grep -c "name: frontend-standards" skills/frontend-standards/SKILL.md`
Expected: frontmatter visible; grep count `1`.

- [ ] **Step 3: Verify bootstrap discovery**

Run: `bash bootstrap.sh --dry-run --profile personal --user-name "Test" 2>&1 | grep frontend-standards`
Expected: `Would add skill asset: frontend-standards/SKILL.md`.

- [ ] **Step 4: Commit**

```bash
git add skills/frontend-standards/
git commit -m "feat (skills): add frontend-standards router skill"
```

---

### Task 4: Author the `frontend-review` gate agent (NEW)

**Files:**
- Create: `agents/frontend-review.md`

- [ ] **Step 1: Write the agent file**

Create `agents/frontend-review.md` with exactly:

```markdown
---
description: Frontend/UX quality gate. Reviews a frontend diff against the team's Clean Code + design-system + accessibility + brand-voice standards and reports findings by severity. Run before marking any PR that touches .tsx/.jsx/.vue/.svelte/.css/.scss as ready.
tools: ["Bash", "Read", "Grep", "Glob"]
---

# Frontend Review Agent

You are the team's frontend quality gate. Your job: review the frontend changes in a diff and report violations of the team standards by severity, with concrete fixes. You do not rubber-stamp — you find what the lead would otherwise have to catch.

## Rubric (single source of truth: the `design-audit` skill)
Read `~/.claude/skills/design-audit/SKILL.md` and evaluate the diff against:
1. **Architecture Rules** — components presentational only; business logic in hooks; pure utils in `lib/`. No `any`, no single-letter vars, declarative naming, functions < 20 / components < 100 lines.
2. **Design System Consistency** — no hardcoded colors/spacing; tokens only; repo design system respected.
3. **Component Refinement** — popover-vs-tooltip, modal X-button rules, layout stability, spacing.
4. **Accessibility (CRITICAL)** — contrast 4.5:1, touch targets 44px, focus rings, aria-labels, keyboard nav, form labels, prefers-reduced-motion.
5. **Pre-PR checklist** — mobile breakpoints, dark mode, no `console.log`, lint passing.
6. **Brand voice** (customer-facing copy only) — per design-audit section 6.

## Process
1. Get the diff. Default: `git diff --merge-base origin/main -- '*.tsx' '*.jsx' '*.vue' '*.svelte' '*.css' '*.scss'`. Use the diff/range the caller specifies if given.
2. Read each changed component/hook in full — not just the diff hunks.
3. Report grouped by severity:
   - **BLOCKER** — Architecture Rule or CRITICAL a11y violation. Must fix before ready.
   - **ISSUE** — design-system inconsistency, layout instability.
   - **POLISH** — non-critical refinement opportunity.
4. For BLOCKERs, propose the fix with code — not just "refactor this".
5. If polish needs animation/micro-interaction depth, recommend `emil-design-eng`.

## Output
A structured report: severity → `file:line` → finding → fix. End with a one-line verdict: `READY` (no blockers) or `BLOCKED (n blockers)`.
```

- [ ] **Step 2: Verify frontmatter matches the repo agent convention**

Run: `head -4 agents/frontend-review.md`
Expected: frontmatter with a `description:` line and `tools: ["Bash", "Read", "Grep", "Glob"]` (same shape as `agents/review.md`).

- [ ] **Step 3: Verify bootstrap discovery**

Run: `bash bootstrap.sh --dry-run --profile personal --user-name "Test" 2>&1 | grep frontend-review`
Expected: a line referencing `frontend-review` under agents (new or upgrade).

- [ ] **Step 4: Commit**

```bash
git add agents/frontend-review.md
git commit -m "feat (agents): add frontend-review PR gate agent"
```

---

### Task 5: Reinforce `templates/CLAUDE.md` — Frontend section + PR gate wiring

**Files:**
- Modify: `templates/CLAUDE.md` (insert a new section after "Rules — Always Apply"; augment "PR Review Process")

- [ ] **Step 1: Add the Frontend section**

Insert this block immediately BEFORE the `## Token & Context Efficiency` section:

```markdown
## Frontend Engineering & UX/UI Standards

Applies to any change touching frontend (`.tsx/.jsx/.vue/.svelte/.css/.scss`) or UX/UI.

**Build discipline (Clean Code, enforced while writing):**
- Components are presentational only; business logic lives in hooks; pure helpers in `lib/`/`utils/`.
- SRP / DRY / KISS / YAGNI. Declarative naming, no single-letter vars, no `any`. Functions < 20 lines, components < 100, files < 400 (800 max). Immutable updates. No magic values.
- Never hardcode colors or spacing — use the repo's design tokens and scale. The target repo's design system is authoritative.

**Skills (use them, don't improvise):** the `frontend-standards` skill auto-activates and routes you — `design-audit` (review/refine, default), `emil-design-eng` (polish/animation), `frontend-design` + `ui-ux-pro-max` (greenfield + reference). Reach for `design-audit` before marking any frontend work ready.

**Quality bar:** Linear / Stripe / Notion level — clean hierarchy, calm UX, coherent spacing. No decorative patterns without product value.
```

- [ ] **Step 2: Augment the PR Review Process**

In the `## PR Review Process (HARD RULE)` section, insert a new numbered step between the current step 2 and step 3:

```markdown
2b. **If the PR touches frontend** (`.tsx/.jsx/.vue/.svelte/.css/.scss`): also run the `frontend-review` agent (or the `design-audit` skill) and resolve all BLOCKER findings before marking ready.
```

- [ ] **Step 3: Verify both edits landed and the section stays generic**

Run: `grep -n "Frontend Engineering & UX/UI Standards" templates/CLAUDE.md && grep -n "frontend-review" templates/CLAUDE.md`
Expected: both grep hits present.

Run: `grep -niE "mainder|traqeer|thinkeat|skyline" templates/CLAUDE.md`
Expected: NO hits in the new section — the generic template must not carry company-specific names (those live in `design-audit`). If any appear, remove them.

- [ ] **Step 4: Commit**

```bash
git add templates/CLAUDE.md
git commit -m "feat (template): add frontend standards section and PR gate wiring"
```

---

### Task 6: Author `docs/TEAM-FRONTEND.md` onboarding doc (NEW)

**Files:**
- Create: `docs/TEAM-FRONTEND.md`

- [ ] **Step 1: Write the doc**

Create `docs/TEAM-FRONTEND.md` with exactly:

```markdown
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
```

- [ ] **Step 2: Verify**

Run: `test -f docs/TEAM-FRONTEND.md && grep -c "frontend-review" docs/TEAM-FRONTEND.md`
Expected: count `>= 1`.

- [ ] **Step 3: Commit**

```bash
git add docs/TEAM-FRONTEND.md
git commit -m "docs (frontend-standards): add team frontend onboarding guide"
```

---

### Task 7: Update README.md and CHANGELOG.md

**Files:**
- Modify: `README.md` (Skills + Agents sections)
- Modify: `CHANGELOG.md` (new dated entry at top)

- [ ] **Step 1: Add the new skills to the README Skills section**

In `README.md`, in the `### Skills` list, add three bullets:

```markdown
- **frontend-standards** — proactive frontend build discipline (Clean Code / SoC) + router to the right design skill; auto-activates on frontend edits
- **design-audit** — default UX/UI validator encoding the team's production HARD RULES (architecture, design system, a11y, brand voice)
- **emil-design-eng** — polish, animation, and micro-interaction design engineering
```

- [ ] **Step 2: Add the gate agent to the README Agents table**

In the `### Agents` table, under the **Review** category, add `frontend-review` alongside the existing review agents.

- [ ] **Step 3: Add a CHANGELOG entry**

Insert at the top of `CHANGELOG.md` (after the intro block, before the first dated `## [...]` entry):

```markdown
## [2026-06-15] — Team frontend standardization

Make a teammate's AXEL build frontend with the same UX/UI + Clean Code standards as the lead, so post-hoc correction drops to a minimum.

### Added
- `skills/frontend-standards/` — proactive build-time frontend discipline (SoC, presentational components, business logic in hooks, SRP/DRY/KISS) + a router to the right design skill. Auto-activates on frontend edits and vocabulary.
- `skills/design-audit/` — vendored the lead's production UX/UI validator (the single source of truth for the rules/checklist).
- `skills/emil-design-eng/` — vendored polish/animation/micro-interaction skill.
- `agents/frontend-review.md` — PR gate that reviews a frontend diff against the design-audit rubric and reports BLOCKER/ISSUE/POLISH findings.
- `docs/TEAM-FRONTEND.md` — teammate onboarding (install/update, verify, impeccable note).

### Changed
- `templates/CLAUDE.md` — new "Frontend Engineering & UX/UI Standards" section + a frontend step in the PR Review Process (run `frontend-review` before marking ready).
```

- [ ] **Step 4: Verify**

Run: `grep -c "frontend-standards\|frontend-review" README.md CHANGELOG.md`
Expected: hits in both files.

- [ ] **Step 5: Commit**

```bash
git add README.md CHANGELOG.md
git commit -m "docs (README): document frontend standardization skills and gate"
```

---

### Task 8: End-to-end verification on a clean target

**Files:** none (verification only)

- [ ] **Step 1: Dry-run install against an isolated clean target and confirm all four assets are NEW**

```bash
TMPHOME=$(mktemp -d)
HOME="$TMPHOME" bash bootstrap.sh --dry-run --profile personal --user-name "Alex" --language spanish 2>&1 | grep -E "design-audit|emil-design-eng|frontend-standards|frontend-review"
```
Expected: each of the four appears as a "would add" skill/agent asset (proves a teammate with no prior copy receives them as new files). Clean up: `rm -rf "$TMPHOME"`.

- [ ] **Step 2: Validate every new/edited SKILL.md and agent has valid YAML frontmatter**

```bash
for f in skills/design-audit/SKILL.md skills/emil-design-eng/SKILL.md skills/frontend-standards/SKILL.md agents/frontend-review.md; do
  head -1 "$f" | grep -q '^---$' && echo "OK frontmatter: $f" || echo "MISSING frontmatter: $f"
done
```
Expected: four `OK frontmatter` lines.

- [ ] **Step 3: Confirm generic/specific split — no company names leaked into the generic template**

Run: `grep -niE "mainder|traqeer|thinkeat|skyline|career-site" templates/CLAUDE.md`
Expected: no hits (company specifics are confined to `design-audit`, which is fine — it is the team skill, not the OSS template).

- [ ] **Step 4: Confirm working tree is clean and all tasks committed**

Run: `git status --short && git log --oneline origin/main..HEAD`
Expected: empty status; the commits from Tasks 1–7 listed above the spec commit.

---

### Task 9: PR into `fork/main`

**Files:** none (git/PR ops)

- [ ] **Step 1: Push the branch to the fork**

```bash
git push -u fork feat/frontend-standards-team
```

- [ ] **Step 2: Run the toolkit review + advisor (HARD RULE before ready)**

Run `/pr-review-toolkit:review-pr` against the branch, then call `advisor()`. Resolve any blockers.

- [ ] **Step 3: Create the PR as Draft**

```bash
gh pr create --repo HxrmxStudio/axel-setup --base main --head feat/frontend-standards-team --draft \
  --title "feat: team frontend standardization (skills + PR gate)" \
  --body "$(cat <<'EOF'
## What changed
Distribute the lead's frontend UX/UI + Clean Code standards to teammates' AXEL via the fork.
- Vendored skills: design-audit, emil-design-eng
- New skill: frontend-standards (build discipline + router)
- New agent: frontend-review (PR gate)
- templates/CLAUDE.md: Frontend section + PR gate step
- docs/TEAM-FRONTEND.md: onboarding

## Why
Other engineers (Alex) touch frontend without the team's standards → repeated review/correct/realign loop. This makes the standards auto-activate and adds a gate so violations are caught before the lead's review.

## Spec
docs/superpowers/specs/2026-06-15-frontend-standardization-design.md

## Test plan
- `bootstrap.sh --dry-run` on a clean HOME shows the 3 skills + 1 agent as new.
- All SKILL.md/agent files have valid frontmatter.
- Generic template carries no company-specific names.

## Breaking changes
None. Fully additive; teammates' CLAUDE.md changes arrive as upgrade-proposals.
EOF
)"
```

- [ ] **Step 4: Mark ready only after toolkit review + advisor confirm no blockers**

```bash
gh pr ready <pr-number>
```

---

## Self-Review

**Spec coverage:** §5.1 vendor skills → Tasks 1–2; §5.2 frontend-standards → Task 3; §5.3 frontend-review gate → Task 4; §5.4 templates/CLAUDE.md → Task 5; §5.5 TEAM-FRONTEND.md → Task 6; §6 inventory (README/CHANGELOG) → Task 7; §7 verification → Task 8; distribution/PR → Task 9. All covered.

**Placeholder scan:** No TBD/TODO. impeccable resolved as lead-local (not distributable). The PR number in Task 9 Step 4 is a runtime value from Step 3 output, not a content placeholder.

**Type/name consistency:** Skill/agent names consistent across tasks (`frontend-standards`, `frontend-review`, `design-audit`, `emil-design-eng`). Severity labels consistent (BLOCKER/ISSUE/POLISH) between the agent (Task 4) and CLAUDE.md wiring (Task 5). Diff command identical where reused.
