# cold-read

Blinded evaluation for AI agents — a cold agent reads your artifact with zero context, and the reconciliation against your own primed assessment is scored by a third party under a rubric you froze before anyone ran.

## What it does

- Dispatches **genuinely cold agents** (N ≥ 2, ideally different models) to evaluate an artifact — a repo, doc, spec, or tool — from the artifact alone
- **Pre-registers the rubric**: catch/miss/agreement definitions, success AND failure thresholds, contamination criteria — hash-frozen before any cold output exists
- Runs a **manipulation check** after each cold read: did the agent suspect a prior assessment existed? What verdict did it think was wanted? (The measurement 94% of clinical trials skip.)
- Requires **training-data disclosure**: a cold agent that recognizes the artifact gets labeled, not silently pooled
- Hands reconciliation to a **third agent** — never the primed side grading its own blind test
- Keeps an **append-only exposure log**: who read what, when; contamination is a ratchet
- Labels runs honestly: **protocol-grade** or **informal cold read** — a run that skips the rigor says so

## Why

"Get a fresh pair of eyes on this" fails quietly in the ways blinded evaluation has always failed: the blind leaks, nobody measures whether it held, and the person with the prior opinion scores the comparison. The design here is lifted from the fields that learned this the hard way — clinical-trial blinding assessment, forensic sequential unmasking, sensory-panel repeat-serving, and result-blind peer review — translated to LLM agents, including the one failure mode those fields never had: the evaluator may have read your artifact during training.

## Install

**Claude Code:**
```bash
git clone https://github.com/cogpros/cold-read.git ~/.claude/skills/cold-read
```

Any agent runtime that reads `SKILL.md` files works the same way — the protocol is runtime-agnostic; only the scaffold script assumes bash.

## Usage

Natural language: *"cold-read this repo"*, *"get a cold POV on this doc before I send it"*, *"run a blinded read against my assessment"*.

Manual flow:

```bash
# 1. Scaffold a run (default runs dir: ~/.cold-read/runs, override: COLD_READ_RUNS_DIR)
scripts/cold-read-setup.sh my-artifact

# 2. Fill rubric.md (template + worked example in references/), write HANDOFF-B.md
#    (your primed findings — the answer key), then freeze both:
scripts/cold-read-setup.sh --freeze <run-dir>

# 3. Dispatch cold agents with references/cold-prompt-template.md (verbatim, fill <...> only)
# 4. Freeze outputs, then probe each agent with references/manipulation-check.md
# 5. Hand a third agent the frozen outputs + HANDOFF-B + rubric to score
```

## Files

```
cold-read/
├── SKILL.md                            # the protocol (4 phases + validity bar)
├── references/
│   ├── cold-prompt-template.md          # fixed-wording cold prompt + de-brand variant
│   ├── manipulation-check.md            # post-run blinding probe + coldness scoring
│   └── rubric-template.md               # pre-registration template + worked example
└── scripts/
    └── cold-read-setup.sh               # run scaffold + --freeze hash lock
```

## Limitations

- The dispatcher is usually contaminated and still owns the final read — the exposure log makes that visible, it can't remove it
- Training-data recognition is detectable only by self-report
- N=2 catches gross noise, not subtle spread — widen the panel for high stakes
- De-branding can over-strip; use it as a comparison arm, never the only arm

## License

MIT — see LICENSE.txt. Pollock 2026.
