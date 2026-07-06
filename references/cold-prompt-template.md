# Cold prompt template (v1.1 — post run-1 leak fixes)

Copy this file's block verbatim and fill only the `<...>` slots. Do not rephrase, expand,
or add context — the contaminated dispatcher's authorship fingerprint is minimized by
keeping the wording fixed (design req. 6).

**Before dispatch (v1.1, replaces the old exclusion line):** place the artifact in a
clean location the agent can be pointed at exclusively — clone the repo fresh into a
scratch dir, or copy the doc into an empty folder. Never name excluded paths in the
prompt: run 1 proved "ignore HANDOFF-*" is itself the leak — you can't fence something
off without announcing it exists. Relocate, don't fence.

```
Have a look at this and give me your read: <location>.

1. First, so I can weigh your take: do you recognize this artifact, its author, or the
   specific project from prior knowledge? Answer before reading further. (Recognition
   is fine — it just gets recorded.)
2. Tell me what it is and does, in your own words.
3. Then your evaluation: usefulness, efficiency, design quality — whatever its nature
   makes relevant. Support each point from the artifact itself.
4. "Nothing significant to add" is a first-class, fully acceptable answer. Do not
   manufacture findings to look thorough. A short honest verdict beats a long padded one.

Work from the artifact alone.
```

**Why the casual opener (v1.1):** run 1's probes showed the old opener ("with no prior
context, on purpose") read as lab-coat framing — both cold agents quoted it as evidence
they were in a controlled comparison. An ordinary-work-request register is the active
placebo: the task should feel like any other ask, not a scrubbed experiment.

## De-brand variant (optional arm)

For artifacts with loud self-presentation (README marketing, star counts, version
numbers, known author): copy the artifact to a neutral location, strip badges/marketing/
authorship, and dispatch one additional cold agent at the copy with the same template.
A verdict that moves under de-branding was reading the label, not the wine. Never make
the de-branded arm the only arm — de-branding can over-strip real signal.
