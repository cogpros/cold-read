---
name: cold-read
description: >
  Blinded evaluation of an artifact by genuinely cold agents, reconciled against the
  primed assessment under a pre-registered rubric. Use when (1) an artifact already has
  a primed/in-session assessment and you want what an unanchored reader catches that the
  briefed one can't; (2) someone asks for a "cold POV" / "fresh eyes" on their tool or
  doc; (3) before shipping a doc/spec/paper rewrite where the author's context may be
  hiding holes. NOT FOR: quick opinions (just ask), artifacts with no primed counterpart
  to reconcile against (that's an ordinary review), decisions needing operator context,
  or anything where the main session's verdict alone is acceptable.
license: MIT
compatibility: >
  Runtime-agnostic protocol; scaffold script requires bash + shasum (macOS/Linux).
  Cold agents need any subagent/fan-out mechanism. Tested with Claude Code.
metadata:
  version: "1.0.0"
  author: "dustinpollock"
  category: "product-verification"
---

# Cold-Read — blinded evaluation with a reconciliation you can trust

A cold model finds things a briefed one can't. But a blind that isn't measured is a
blind that's assumed — and the fields that ran blinded evaluation for decades (clinical
trials, forensics, sensory panels, peer review) all learned the same lesson: **the
blinding fails silently, and the unblinded party grades its own test.** This skill
rebuilds the two-handoff A/B pattern around eight failure modes pulled from those
fields' own literature.
## Roles — who is what (state this before anything runs)

- **Primed side** — whoever already assessed the artifact (usually the main session).
  Contaminated by definition. Authors HANDOFF-B. May NOT author the cold prompt
  free-hand, may NOT score the reconciliation.
- **Cold agent(s)** — fresh subagents, zero session context, dispatched with only the
  filled template below. Never the main session.
- **Reconciler** — a third agent (fresh subagent, ideally a different model or vendor)
  that has seen NEITHER the primed assessment NOR the cold outputs until reconciliation
  time, and scores strictly against the pre-registered rubric.
- **Operator** — approves dispatch, owns the final read. The operator is usually
  contaminated too; the ledger (req. 7) exists so this doesn't live in anyone's head.

## The protocol

### Phase 0 — Pre-register (BEFORE any cold dispatch; this is the gate)

Scaffold with `scripts/cold-read-setup.sh <artifact-slug>` — creates the run dir
(default `~/.cold-read/runs/`, override with `COLD_READ_RUNS_DIR`), seeds the exposure
log, copies in the rubric template. After writing rubric + HANDOFF-B, run
`scripts/cold-read-setup.sh --freeze <run-dir>` to hash them (proof they predate the
cold outputs) and mark them read-only.

The run dir contains:

1. **`rubric.md`** — written, timestamped, and hash-frozen before any cold output
   exists (req. 5). Template + a filled worked example:
   `references/rubric-template.md`. Must define: catch / miss / agreement /
   framing-only-difference; success AND failure thresholds; contamination criteria
   fixed now (no retroactively declaring an inconvenient verdict "contaminated"); and
   the registered commitment that an empty catches-bucket is a valid result.
2. **`exposure.log`** — append-only ledger, one line per event (req. 7):
   `<UTC timestamp> | <who> | <what they were exposed to>`. Starts with who is already
   contaminated and by what. Contamination is a ratchet: once a party (or a memory file
   it wrote) is exposed, it stays disqualified for this artifact across sessions.
3. **`HANDOFF-B.md`** — the primed side's full findings, distilled as the answer key.
   Written now, hash/timestamp it, hand over only after cold outputs are frozen.

### Phase 1 — Dispatch cold agents (N ≥ 2)

One cold read is one draw from a noisy distribution — sensory-panel data shows single
blind verdicts are mostly noise (req. 2). Default **two cold agents, different models or
vendors**. A catch reported by only one of them is labeled `singleton` and must either
replicate on a re-run or verify against the artifact directly before it's called a catch.

The cold prompt is copied verbatim from `references/cold-prompt-template.md` — filled
in, never free-written, so the contaminated author's fingerprint stays minimal (req. 6).
Neutral task wording: "describe what this is and evaluate it" — not "find the problems
with" (eval-shaped wording produces criticism-shaped output regardless of ground truth).
The template's disclosure line is the training-data check (req. 4): recognition doesn't
void the run, but the verdict gets labeled `memorized-prior-risk` and is never silently
pooled with genuinely cold verdicts. Its "nothing significant to add is a first-class
answer" line is the rewarded null (req. 8) — the rubric must score a confirmed null as
a pass, not a failed read. The optional de-brand arm (req. 6) is specified in the same
reference file.

### Phase 2 — Freeze, then manipulation-check

When a cold agent returns: write its output to the run dir unaltered, log the event in
`exposure.log`, THEN send the same agent the probe from
`references/manipulation-check.md` (req. 3) and log its answers verbatim. This is the
blinding measurement the trial literature says almost nobody does (5.6% of RCTs).
Coldness scores as **clean / suspected / reconstructed** per the reference file —
suspicion alone never voids a run, it calibrates the weight the verdict carries; only
the rubric's pre-registered criteria can void one.

### Phase 3 — Reconcile (not by the primed side)

Hand the reconciler: the frozen cold outputs, `HANDOFF-B.md`, and `rubric.md` — nothing
else. It scores every divergence into the rubric's categories, verbatim quotes on both
sides, cold conclusions preserved unaltered before any delta narrative (a disagreement
is reported as a disagreement, not absorbed into the primed side's framing). The primed
side may append a response section afterward — clearly labeled, never edits the scoring
(req. 1). Six of seven field lenses independently converged on this requirement; it is
the one non-negotiable in the skill.

### Phase 4 — Deliverable

`reconciliation.md` in the run dir:

- **Catches** — what cold caught that primed missed (each tagged: replicated / singleton
  / verified-against-artifact).
- **Misses** — what primed had that cold didn't (findable-from-artifact only).
- **Agreements** and **framing-only differences** — separated, per the rubric.
- **Coldness report** — manipulation-check answers, recognition disclosures, any
  de-brand delta.
- **Protocol verdict** — did the run meet its own pre-registered validity bar? If any of
  {rubric predates cold output, manipulation check logged, reconciler ≠ primed side} is
  missing, the run is labeled **informal cold read**, not protocol-grade — report it as
  such rather than dressing it up (same discipline as grill-the-field's falsifier).

## Observability

- Run record = the run dir itself (rubric, exposure log, frozen outputs, reconciliation).
- Emit a completion signal to whatever event bus or run log your stack uses, carrying at
  minimum: artifact, catch count (replicated vs singleton), coldness verdict, and
  whether the run was protocol-grade.
## Leak channels (measured in run 1, 2026-07-05 — mitigations wired, one open)

Run 1's manipulation checks caught the blind leaking through three channels; both agents
reconstructed the comparison setup (steer-clean — verdicts held, calibrated down):

1. **The exclusion line** ("ignore HANDOFF-*") announced what it hid. FIXED v1.1:
   relocate the artifact to a clean scratch location; never name exclusions in the prompt.
2. **Lab-coat framing** ("no prior context, on purpose") — quoted by both agents as the
   tell. FIXED v1.1: template opener rewritten as an ordinary work request.
3. **The skill's own registry entry** — subagents inherit the session's skill list, and
   /cold-read's description describes this exact protocol. OPEN: real fix is clean-room
   dispatch (`claude -p` with an isolated config dir — no skills, no identity files, no
   memory). Until built, expect "suspected" coldness as the realistic ceiling and let the
   probe measure the residue — that's what it's for.

## Known limitations

- **The operator is usually contaminated** and still owns the final read. The ledger
  makes that visible; it can't remove it.
- **Training-data priors are detectable only by self-report** — a model can recognize
  an artifact without knowing it does. Disclosure lowers, not eliminates, the risk.
- **N=2 is a floor, not statistics.** It catches gross noise, not subtle spread. For
  high-stakes runs, widen the panel (prism-panel's vendor roster applies).
- **De-branding can over-strip** — removing a README can remove real signal, not just
  frame. Use the variant as a comparison arm, never the only arm.
- **Cost:** each protocol-grade run = ≥2 cold agents + probes + 1 reconciler. For a
  casual "fresh eyes?" ask, an informal cold read (1 agent, no rubric) is fine — just
  label it informal.

## Dependencies

- `scripts/cold-read-setup.sh` — run-dir scaffold, exposure-log seed, pre-registration
  hash-freeze (`--freeze`).
- `references/cold-prompt-template.md` · `references/manipulation-check.md` ·
  `references/rubric-template.md` (includes a filled worked example) — the three
  fixed-wording artifacts every run copies from.
- Agent fan-out (Agent tool or Workflow `parallel()`) — cold panel + reconciler dispatch.
- Cross-vendor cold seats: OpenRouter key (`OPENROUTER_API_KEY`) or per-vendor access.
  Optional — two same-vendor different-model cold agents is a valid floor.
- An event bus or run log for the completion signal (optional).
## Lineage

The design requirements are the 8 ranked questions a cross-domain interrogation sweep
(clinical-trial blinding, sensory panels, forensic sequential unmasking, peer review)
raised against a first-generation two-handoff A/B protocol — each maps to a numbered
req. above. The A/B pattern predates this skill and was, by this skill's own standard,
an informal cold read.