---
name: frontend-standards
description: "Proactive frontend build standards and skill router for the team. Use when writing or modifying frontend code (.ts/.tsx/.jsx/.vue/.svelte/.css/.scss) or when the task mentions component, hook, presentational, business logic, SoC, clean code, SRP, DRY, KISS, modular, design, UX, UI, polish, refinar, spacing, layout, popover, tooltip, accessibility, a11y, design tokens. Routes to design-audit (review), emil-design-eng (polish), impeccable (modal workflow, lead-local), frontend-design (greenfield), ui-ux-pro-max (reference)."
license: MIT
---

# Frontend Standards — How the team builds frontend

This skill carries the team's build-time frontend discipline and routes you to the right specialist skill. It is the PROACTIVE counterpart to `design-audit` (which VALIDATES finished work). Do not duplicate design-audit's checklists here — defer to it.

## When this activates
- Writing or editing `.ts/.tsx/.jsx/.vue/.svelte/.css/.scss`
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
