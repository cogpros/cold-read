# Rubric template (pre-register BEFORE any cold dispatch)

Fill and save as `<run-dir>/rubric.md`, then hash it (`scripts/cold-read-setup.sh` does
this) so its timestamp provably predates the cold outputs (design req. 5).

```markdown
# Cold-read rubric — <artifact> — <UTC timestamp>

## Definitions
- CATCH: a substantive finding about the artifact absent from the primed assessment
  (HANDOFF-B). Substantive = would change a decision, a design, or a message to the
  artifact's owner. Tag each: replicated (≥2 cold agents) / singleton / verified-against-artifact.
- MISS: a primed finding the cold read did not surface — counts only if findable from
  the artifact alone (primed knowledge from outside the artifact is not a cold miss).
- AGREEMENT: same substance both sides.
- FRAMING-ONLY: same substance, different words. Not a catch.

## Success / failure thresholds
- Protocol SUCCEEDS if: <e.g. the catches bucket is decision-grade either way — a
  replicated catch exists, OR a confirmed-empty bucket after 2 clean-coldness reads.>
- Protocol FAILS if: <e.g. both cold agents score "reconstructed" on the manipulation
  check; or both disclose training-data recognition of the artifact.>
- An empty catches bucket is a valid result. Registered now, not invoked after the fact.

## Contamination criteria (fixed now — no retroactive additions)
- <e.g. cold agent received any content authored after the primed assessment existed,
  beyond the fixed template; cold agent accessed the excluded paths; probe reveals the
  dispatcher's wanted verdict leaked.>

## Panel
- Cold agents: <N ≥ 2, models/vendors — e.g. claude-sonnet-5, gemini-3-pro>
- Reconciler: <model/agent — must not be the primed side>
```

## Worked example (abbreviated — a "cold POV on my open-source tool" run)

```markdown
# Cold-read rubric — <author>/<tool-repo> — 2026-07-05T23:30Z
## Definitions — as template.
## Success / failure
- SUCCEEDS: report to the author is decision-grade: ≥1 replicated catch about
  usefulness/efficiency, or confirmed-empty bucket with both agents' coldness = clean/suspected.
- FAILS: both agents reconstruct the comparison setup, or both recognize the repo from training.
## Contamination criteria
- Any mention of the prior assessment, its memory file, or the dispatcher's own
  integration plans for the tool reaches a cold agent → that run void.
## Panel
- Cold: claude-sonnet-5 (as-is arm), google/gemini-3-pro via OpenRouter (as-is arm 2).
  Optional third: de-branded copy.
- Reconciler: fresh subagent, sees only frozen outputs + HANDOFF-B + this rubric.
```
