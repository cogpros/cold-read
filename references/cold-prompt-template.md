# Cold prompt template

Copy this file's block verbatim and fill only the `<...>` slots. Do not rephrase, expand,
or add context — the contaminated dispatcher's authorship fingerprint is minimized by
keeping the wording fixed (design req. 6).

```
You are evaluating an artifact with no prior context, on purpose. Artifact: <location>.

1. First, disclose: do you recognize this artifact, its author, or the specific project
   from prior knowledge? Answer before reading further. (Recognition is fine — it just
   gets recorded.)
2. Describe what the artifact is and does, in your own words.
3. Evaluate it: usefulness, efficiency, design quality — whatever the artifact's nature
   makes relevant. Support each point from the artifact itself.
4. "Nothing significant to add" is a first-class, fully acceptable answer. Do not
   manufacture findings to look thorough. A short honest verdict beats a long padded one.

Ignore <excluded paths — e.g. any directory or file matching _cold-read/, HANDOFF-*>.
Work from the artifact alone.
```

## De-brand variant (optional arm)

For artifacts with loud self-presentation (README marketing, star counts, version
numbers, known author): copy the artifact to a neutral location, strip badges/marketing/
authorship, and dispatch one additional cold agent at the copy with the same template.
A verdict that moves under de-branding was reading the label, not the wine. Never make
the de-branded arm the only arm — de-branding can over-strip real signal.
