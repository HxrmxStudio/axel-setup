---
name: design-audit
description: "Default UX/UI audit skill for existing frontend work. Use for validar visual, design de Mainder, aligned design, popover, tooltip, spacing, layout, polish, refinar, SoC, clean code, presentational components, hooks, design tokens, accessibility, a11y, and pre-PR visual checks across Mainder, Traqeer, ThinkEat, and related repos."
license: MIT
---

# Design Audit — Cross-repo visual + architecture review

Skill especializado para auditar, validar y refinar componentes UI existentes en cualquier repo del usuario. Encarna las HARD RULES de Emi acumuladas en producción.

## Cuándo invocar este skill

**Disparadores explícitos** (keywords del user):
- "validar visual" / "alineado con design de Mainder"
- "polish", "refinar", "ajustar visual"
- "popover" / "tooltip" decisions
- "spacing", "layout", "hover", "shadow"
- "components presentational", "SoC", "clean code"
- "accessibility", "a11y", "design tokens"
- "quitar X del modal", "quitar espacio en blanco"

**Disparadores implícitos** (contexto):
- Edits a `.tsx/.vue/.css/.svelte/.html` en cualquier repo del usuario
- Pre-PR check antes de marcar Done
- Después de implementar funcionalidad que necesita "feel right"

**NO invocar** si:
- Es greenfield (usar `frontend-design`)
- Es animation/micro-interactions focus puro (usar `emil-design-eng`)
- El user explicitamente invocó `$impeccable <cmd>` (ese workflow tiene precedencia en Codex)

---

## 1. Architecture Rules (HARD)

Estricta separación de responsabilidades (Robert C. Martin enforced):

| Capa | Responsabilidad | Path típico |
|------|-----------------|-------------|
| **Componentes** | SOLO presentación (UI). NO business logic. NO data fetching. | `components/*.tsx` |
| **Hooks** | Business logic, state, data fetching, side effects. | `hooks/use*.ts` |
| **Utils / lib** | Funciones puras, sin side effects, testeables aisladamente. | `lib/`, `utils/` |

**Add-on principle**: extender funcionalidad EXISTENTE antes que crear módulos paralelos. Si existe `use-merge-candidate-modal.ts`, extenderlo NO crear `use-merge-candidate-modal-v2.ts`.

**Naming**:
- No `any` en TypeScript (usar `unknown` + narrow, o tipo concreto)
- No single-letter vars (excepto `idx` array index, `err` catch block)
- Funciones <20 líneas, componentes <100 líneas
- Naming declarativo Clean Code: `handleUserClick` > `onClick2`

---

## 2. Design System Consistency

**Paths del design system por repo:**

| Repo | Design tokens | Theme config | Globals |
|------|---------------|--------------|---------|
| SKYLINE-V9 | `app/styles/design-tokens.css` | `tailwind.config.ts` | `app/globals.css` |
| Career-Site | `tailwind.config.ts` | `tailwind.config.ts` | `app/globals.css` |
| minder-job-hub | `tailwind.config.ts` | `tailwind.config.ts` | `src/app/globals.css` |
| traqeer-web-2 | `tailwind.config.ts` | `tailwind.config.ts` | `app/globals.css` |
| thinkeat_new | `tailwind.config.ts` + `DESIGN.md` | `tailwind.config.ts` | `app/globals.css` |
| Webflow (mainder.ai) | Designer MCP headed (NO Data API para tokens) | N/A | N/A |

**Reglas duras:**
- NUNCA hardcodear colores (`#fff`, `rgb(...)`) — usar tokens (`bg-background`, `text-foreground`)
- NUNCA hardcodear spacing en píxeles random — usar escala del design system (`p-2`, `p-4`, `p-6`, `p-8`)
- NUNCA introducir fuentes nuevas sin validar contra design system del repo
- Para Webflow: edits primary locale = Designer MCP (headed); edits metadata/SEO = Data API

---

## 3. Component Refinement Patterns

**Popover vs Tooltip decision tree:**

| Caso | Componente | Razón |
|------|-----------|-------|
| Disclosure clickeable en touch surfaces | **Popover** | Tooltip hover-only falla en touch; abre exposure legal |
| Hint efímero sobre icono que no abre dialog | **Tooltip** | Aceptable cuando es metadata efímera, no contenido legal |
| Helper text que el user necesita LEER | **Popover** | Persistente, accesible, navegable con keyboard |

**Modal patterns:**
- Si el modal cierra con click-outside → REMOVER el botón "X" (redundancia visual)
- Si el modal requiere acción explícita → MANTENER el "X" + bloquear click-outside
- `Escape` key debe cerrar siempre (a11y)

**Layout stability:**
- Las interacciones (click, hover, toggle) NO deben modificar el layout circundante
- Caso real: "chip de cambio semana/día" no debe cambiar de lugar al seleccionar día
- Si necesitás esconder/mostrar contenido, reservá el espacio con `min-h` / `min-w`

**Spacing review:**
- Identificar y eliminar espacio en blanco sin uso (popovers, cards, modals)
- Densidad coherente con design taste (Linear/Notion/Stripe): respirar pero no nadar
- Quitar bordes/círculos decorativos alrededor de iconos si no aportan jerarquía

---

## 4. Accessibility Checklist (CRITICAL)

| Check | Mínimo | Cómo validar |
|-------|--------|--------------|
| Color contrast | 4.5:1 normal text, 3:1 large text | Chrome DevTools / Lighthouse |
| Touch target | 44x44px mínimo | Inspect element box |
| Focus rings | Visibles en todos los interactivos | Tab navigation |
| `aria-label` | Iconos sin texto, botones cerrar | Audit con DevTools accessibility tree |
| Keyboard nav | Tab order matches visual order | Tab + Shift+Tab through component |
| Form labels | Cada input asociado con `<label for>` | Lighthouse a11y audit |
| `prefers-reduced-motion` | Respetar para animaciones >200ms | Settings macOS Accessibility → Reduce Motion |

---

## 5. Pre-PR Validation Checklist

Antes de marcar In Review:

- [ ] Visual alineado con design system del repo (tokens, no hardcoded values)
- [ ] Componente <100 líneas, hooks extraídos si supera
- [ ] No `any`, no single-letter vars, naming declarativo
- [ ] Accessibility checklist (sección 4) cumplido
- [ ] Mobile validated (375px + 390px + 768px breakpoints)
- [ ] Dark mode validated si aplica al repo
- [ ] No `console.log` dejado
- [ ] No comentarios en código (excepto WHY non-obvious — AGENTS.md rule)
- [ ] Lint passing (sin `--no-verify`)
- [ ] Staging environment levantado y validado visual antes de Done (SKYLINE-V9 staging-first lifecycle)

---

## 6. Brand Voice Consistency (customer-facing copy)

Si el componente contiene copy customer-facing, validar:

- "**AI-native ATS, CRM and Sourcing**" (singular AI modifier, NO "AI ATS + AI CRM + AI Sourcing" triple)
- NUNCA "Killer Questions" en copy externo (interno OK)
- NUNCA mencionar proveedores InfoJobs/Idibu/Mako en customer-facing
- Pricing concrete numbers (€24/€69) requieren approval de Samu antes de live
- Features sin paréntesis explicativos
- ES: "propio" (no "propietario"), "millones" (no "miles de millones")

---

## 7. Workflow de invocación

Cuando este skill se activa, seguir este orden:

1. **Identificar repo + stack** (SKYLINE-V9? Career-Site? Webflow? Traqeer?)
2. **Leer el componente target** completo (no parcial)
3. **Aplicar checklist de la sección apropiada** (Architecture → Design System → Refinement → A11y → Pre-PR)
4. **Reportar findings agrupados** por severidad:
   - **Blockers**: violaciones de Architecture Rules o A11y CRITICAL
   - **Issues**: design system inconsistencies, layout stability problems
   - **Polish**: opportunities de refinement no críticas
5. **Proponer fixes con código** para los blockers (no solo "deberías refactorizar")
6. **Sugerir invocar `emil-design-eng`** si los polish requieren animation/micro-interaction depth

---

## 8. Tradeoffs vs otros skills del stack

| Skill | Cubre | Este `design-audit` cubre |
|-------|-------|--------------------------|
| `emil-design-eng` | Animation, polish details, invisible feel | HARD RULES + design system consistency |
| `impeccable` | Workflow modal (`$impeccable audit/critique/polish`) | Auditar contra TUS reglas específicas Mainder |
| `frontend-design` | Greenfield aesthetic direction | NO aplica (greenfield) |
| `ui-ux-pro-max` | Catálogo de estilos/paletas/fonts | NO aplica (referencia) |

`design-audit` se enfoca en VALIDAR contra reglas ya establecidas. No genera ideas nuevas — verifica que lo construido respete el design system + architecture + brand voice de Mainder/Traqeer/ThinkEat.

---

## Filosofía

**Thin harness, fat skill**: este skill es autónomo. No requiere otros skills para funcionar, ni meta-orquestador. Encapsula las HARD RULES acumuladas en producción por el usuario.

**Excelsior**: estándar Linear/Notion/Stripe/Airbnb. Si un componente puede mejorar polish/spacing/clarity sin romper nada, decirlo. Si tiene blockers, no marcarlo Done.
