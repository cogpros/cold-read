#!/bin/bash
# cold-read-setup.sh — scaffold a protocol-grade cold-read run.
# Usage: cold-read-setup.sh <artifact-slug>
# Creates the run dir, seeds the append-only exposure log, and copies the rubric
# template in for filling. Run `cold-read-setup.sh --freeze <run-dir>` after the
# rubric and HANDOFF-B are written to hash them — the hashes prove they predate
# the cold outputs (design reqs. 5 and 7).
set -euo pipefail

BASE="${COLD_READ_RUNS_DIR:-$HOME/.cold-read/runs}"
SKILL_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

if [[ "${1:-}" == "--freeze" ]]; then
  RUN_DIR="${2:?usage: cold-read-setup.sh --freeze <run-dir>}"
  cd "$RUN_DIR"
  for f in rubric.md HANDOFF-B.md; do
    [[ -f "$f" ]] || { echo "ERROR: $f missing — write it before freezing" >&2; exit 1; }
    shasum -a 256 "$f"
  done > preregistration.sha256
  echo "$(date -u +%FT%TZ) | setup-script | rubric.md + HANDOFF-B.md hashed to preregistration.sha256" >> exposure.log
  chmod 444 preregistration.sha256 rubric.md HANDOFF-B.md
  echo "Frozen. Hashes:"
  cat preregistration.sha256
  exit 0
fi

SLUG="${1:?usage: cold-read-setup.sh <artifact-slug>}"
STAMP="$(date -u +%Y%m%dT%H%M%SZ)"
RUN_DIR="$BASE/$STAMP-$SLUG"
mkdir -p "$RUN_DIR"
cp "$SKILL_DIR/references/rubric-template.md" "$RUN_DIR/rubric.md"
{
  echo "# exposure.log — append-only; every context exposure gets a line. Contamination is a ratchet."
  echo "$(date -u +%FT%TZ) | setup-script | run dir created for $SLUG"
} > "$RUN_DIR/exposure.log"
echo "$RUN_DIR"
echo "Next: fill rubric.md, write HANDOFF-B.md, list who is already contaminated in"
echo "exposure.log, then: cold-read-setup.sh --freeze $RUN_DIR"
