#!/bin/sh
# raphant fork: shows what T3 changed since our base, before we take it.
# Usage: fork/upstream-report.sh [upstream-ref] [since]
#   upstream-ref: default origin/main. since: a commit; default our merge-base.
#   The daily review (~/shared/runbooks/t3-update-review/) passes the last commit it reviewed.
# Lists every new upstream commit, then flags the ones that touch data sent out,
# files in your home folder, the updater, or login/identity code. Read the flagged
# ones before merging. Run from anywhere; it fetches origin first.
set -eu
cd "$(dirname "$0")/.."
ref="${1:-origin/main}"
git fetch -q origin
base="${2:-$(git merge-base HEAD "$ref")}"
count=$(git rev-list --count "$base..$ref")
echo "T3 has $count new commits since $(git log -1 --format='%h %cs' "$base")."
echo
pathspec='apps/server/src/telemetry apps/server/src/cloud apps/web/src/cloud apps/desktop/src/updates apps/desktop/src/electron/ElectronUpdater.ts packages/shared/src/telemetryId.ts scripts/build-desktop-artifact.ts docs/user/telemetry.md docs/user/managed-policy.md'
words='posthog|ingest\.t3|axiom|otlp|telemetry|analytics|identify|homedir|\.claude\.json|auth\.json|feedurl|autoupdater|setfeedurl|sha256'
echo "== Flagged by path (read these) =="
git log --format='%h %cs %an: %s' "$base..$ref" -- $pathspec
echo
echo "== Flagged by changed code (read these too) =="
git log --format='%h' "$base..$ref" | while read -r c; do
  if git show --format= -U0 "$c" | grep -E '^[+-]' | grep -qiE "$words"; then
    git log -1 --format='%h %cs %an: %s' "$c"
  fi
done
echo
echo "To read one: git show <hash>. To take them all: git merge $ref, then rebuild."
