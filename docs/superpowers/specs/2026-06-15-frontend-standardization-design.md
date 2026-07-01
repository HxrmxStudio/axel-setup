# Frontend Standardization for Team AXEL — Design Spec

**Date:** 2026-06-15
**Author:** Emiliano (HxrmxStudio)
**Status:** Approved (design) — pending implementation plan
**Repo:** `HxrmxStudio/axel-setup` (fork of `cveralyon/axel-setup`)
**Target branch:** `feat/frontend-standards-team` → merge into `fork/main`

---

## 1. Problem

Other engineers — currently **Alex** — touch frontend in shared repos (SKYLINE-V9, Career-Site, minder-job-hub, traqeer-web-2, thinkeat_new, back-office) without following the UX/UI quality bar and Clean Code frontend standards the team lead (Emiliano) enforces. The result is a repeating, expensive loop: review → detect → correct → realign → redo decisions that should never have been made differently.

The frontend standards, UX/UI taste, design-audit discipline, and Clean Code conventions are encoded in **Emiliano's personal Claude Code config** (`~/.claude/CLAUDE.md` + personal skills in `~/.agents/skills/`). They do **not** travel to teammates. Alex's AXEL therefore starts every frontend task without them.

## 2. Goal

Make **Alex's AXEL build frontend with the same standards from the start**, so post-hoc correction drops to a minimum. Concretely: the same UX/UI skills, the same visual decisions, the same Clean Code / SoC discipline, and a gate that catches violations before they reach the lead's review.

### Non-goals (YAGNI)
- Not building new UX/UI skills from scratch — the standards already live in `design-audit`.
- Not contributing to `cveralyon` upstream in this iteration — team layer lives in the fork.
- Not vendoring `impeccable`'s `reference/` tree — that's drift; reference it as an (optional) plugin.
- Not rewriting Emiliano's personal `rules/` system into the package.

## 3. Locked decisions

| Decision | Choice | Rationale |
|---|---|---|
| Where the standardization lives | **Directly in `fork/main`** (HxrmxStudio) | Fork is the team's AXEL; diverges from upstream with team additions. |
| Alex's current state | **Already runs AXEL** | Delivery = new files (installed directly) + upgrade-proposals for existing files. |
| Enforcement level | **Auto-activation + PR gate** | "No depender de revisión posterior" requires more than docs. |
| Approach | **A — Skill-centric + PR gate** | New files reach an existing-AXEL user reliably; skills auto-activate; agent is the gate. |

## 4. Distribution reality (the constraint that shapes everything)

Because Alex already has AXEL, the bootstrap is **additive and non-destructive**. Content reaches him by two channels:

- **New files** (skills, agents, commands, hooks, scripts) → copied directly into `~/.claude/` → **reach him reliably and auto-activate.** This is the primary channel.
- **Existing files** (his `~/CLAUDE.md`, `settings.json`, existing hooks) → staged as upgrade-proposals in `~/.claude/axel-upgrades/` → he reviews via `REVIEW.md`. **Secondary channel — depends on him accepting.**

**Design consequence:** lean on new files (skills + agent). Treat `templates/CLAUDE.md` edits as reinforcement, not the load-bearing vehicle.

## 5. Architecture (Approach A)

Five components, all on `fork/main`:

### 5.1 Capability packaging — vendor the missing skills
- `skills/design-audit/` ← copy from `~/.agents/skills/design-audit/` (SKILL.md + `agents/openai.yaml`). Already encodes Emi's production HARD RULES + Mainder/Traqeer/ThinkEat vocabulary. **This is the canonical container of the standards.**
- `skills/emil-design-eng/` ← copy from `~/.agents/skills/emil-design-eng/` (polish, animation, micro-interactions).
- `skills/ui-ux-pro-max/`, plugin `frontend-design` → **already ship** ✅.
- `impeccable` → **optional**, documented manual install (see 5.5). It's from a non-official marketplace (`impeccable@impeccable`), so it is NOT added to the `PLUGINS` array. `design-audit` is the always-on default audit path (`design-audit ↔ impeccable audit`).

### 5.2 `skills/frontend-standards/SKILL.md` (NEW) — the central vehicle
A skill that auto-activates on frontend work (file types `.tsx/.jsx/.vue/.svelte/.css/.scss` + vocabulary: validar visual, design, polish, refinar, spacing, popover, tooltip, layout, presentational, hooks, clean code, SoC, a11y). It contains:
- **Clean Code frontend rules:** presentational components stay presentational; business logic in hooks/utilities; SRP / DRY / KISS / YAGNI; real modularity; clear responsibility boundaries; file-size guidance (200–400 lines typical, 800 max); no single-letter variables; no magic strings; immutable update patterns; explicit error handling at boundaries.
- **Skill decision tree** (which skill, when):
  - review / refine / audit existing UI → **`design-audit`** (default)
  - polish / animation / micro-interactions → **`emil-design-eng`**
  - explicit modal workflow → **`impeccable`** (`/impeccable audit|polish|critique|distill|clarify`) if installed
  - greenfield surface (new page/feature from scratch) → **`frontend-design`** + `ui-ux-pro-max` in plan phase
  - reference look-up (palette, font pairing, chart pattern) → **`ui-ux-pro-max`**
- **Pre-PR checklist** the `frontend-review` agent consumes (single source of truth).

This file is new → installs directly into Alex's `~/.claude/skills/` and auto-activates. It is the load-bearing artifact.

### 5.3 `agents/frontend-review.md` (NEW) — the gate
An adversarial review agent (frontmatter `description` + `tools: ["Bash","Read","Grep","Glob"]`, matching the repo's agent convention) that runs the §5.2 checklist over a frontend diff and reports violations by severity. Two enforcement points:
- Referenced in `templates/CLAUDE.md` → PR Review Process: *PRs touching `.tsx/.jsx/.vue/.svelte/.css/.scss` MUST run `frontend-review` (and/or `design-audit`) before being marked ready.*
- Complements the existing `review` agent and `/pr-review-toolkit:review-pr` flow — does not replace them.

### 5.4 `templates/CLAUDE.md` (EDIT) — reinforcement layer
Add a **"Frontend Engineering & UX/UI Standards"** section: the SoC/Clean Code principles (generic, upstream-safe wording) + the skill decision tree + the PR gate wiring. Reaches fresh installs directly; reaches Alex as an upgrade-proposal. Kept concise — the skill (§5.2) carries the depth.

### 5.5 `docs/TEAM-FRONTEND.md` (NEW) — onboarding
Short doc for teammates: how to update (`git pull` the HxrmxStudio fork + `bash bootstrap.sh --profile personal`), how to install the optional `impeccable` marketplace+plugin, and how to verify the frontend skills/agent auto-activate (e.g. open a `.tsx`, confirm `design-audit`/`frontend-standards` surface).

## 6. File inventory

| Action | Path | Channel to Alex |
|---|---|---|
| Vendor | `skills/design-audit/{SKILL.md,agents/openai.yaml}` | New file → direct |
| Vendor | `skills/emil-design-eng/{SKILL.md,agents/openai.yaml}` | New file → direct |
| New | `skills/frontend-standards/SKILL.md` | New file → direct |
| New | `agents/frontend-review.md` | New file → direct |
| Edit | `templates/CLAUDE.md` (+ Frontend section, + PR gate) | Upgrade-proposal |
| New | `docs/TEAM-FRONTEND.md` | Repo doc |
| Edit | `README.md` / `CHANGELOG.md` | Repo doc |

No changes to `bootstrap.sh` install logic are required — it iterates `skills/` and `agents/` generically. Confirmed by the 2026-06-15 dry-run, which picked up `model-routing`, `context-budget`, and `harness-optimizer` with no per-asset wiring.

## 7. Verification

- `bash bootstrap.sh --dry-run --profile personal` on a clean `~/.claude` shows the 3 skills + 1 agent as "new".
- Frontend skills auto-activate on a `.tsx` edit (manual check + skill description triggers).
- `frontend-review` agent runs against a sample diff and emits the §5.2 checklist findings.
- `templates/CLAUDE.md` validated for the generic-vs-specific split (no `cveralyon`-breaking personal taste in the generic section; Mainder specifics confined to the skill).

## 8. Out of scope / future
- Upstream PR of the generic principles to `cveralyon` (later iteration).
- PostToolUse nudge hook on frontend file edits (lighter reinforcement; the PR gate is the strong enforcement — add only if the gate proves insufficient).
- Porting Emiliano's full `rules/` system.
