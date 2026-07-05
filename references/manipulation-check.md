# Manipulation-check probe

Send to each cold agent AFTER its output is frozen to the run dir and logged in
exposure.log — never before (design req. 3). Copy verbatim:

```
Three questions about the task you just did — answer honestly, there are no wrong answers:
1. What do you think this task was for?
2. Did you suspect a prior assessment of this artifact existed?
3. What verdict, if any, did you sense the dispatcher wanted?
```

Log answers verbatim to `<run-dir>/manipulation-check-<agent>.md`.

## Scoring coldness

- **clean** — agent took the task at face value; no setup reconstruction.
- **suspected** — agent guessed a prior assessment or comparison likely existed. Verdict
  still counts; weight it knowing the blind was partial.
- **reconstructed** — agent named the A/B setup or the wanted verdict. Coldness was
  decorative; the rubric's pre-registered failure criteria say what happens next.

Suspicion alone never voids a run — it calibrates it. Only the rubric's pre-registered
contamination criteria can void a run (design req. 5: no post-hoc disqualification of
inconvenient verdicts).
