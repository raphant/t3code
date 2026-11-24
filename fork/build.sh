#!/bin/bash
# raphant fork: builds the desktop app with T3 Connect on, usage data and tracing off,
# and no self-updater. Usage: fork/build.sh <linux|mac> <version>
#   <version> must not be older than ~/.t3/userdata/desktop-last-started-version.
# Linux: run inside distrobox t3-build-u24 (Ubuntu 24.04). Mac: run on an arm64 Mac.
# Output: release-fork/ in the checkout. Steps: ~/shared/runbooks/projects/t3code-fork.md
set -euo pipefail
cd "$(dirname "$0")/.."
platform=$1; version=$2
set -a; . fork/connect.env; set +a
# Never bake in an update feed or tracing: keep these unset.
unset GITHUB_REPOSITORY T3CODE_DESKTOP_UPDATE_REPOSITORY T3CODE_RELAY_CLIENT_OTLP_TRACES_URL \
  VITE_RELAY_OTLP_TRACES_URL VITE_RELAY_OTLP_TRACES_DATASET VITE_RELAY_OTLP_TRACES_TOKEN
export PATH="$PWD/node_modules/.bin:$PATH"
# Staging needs several GB; bazzite's /tmp is a shared tmpfs that fills up (EDQUOT, "system error -122").
export TMPDIR="$HOME/.cache/t3code-fork-build"; mkdir -p "$TMPDIR"
case $platform in
  linux) args=(--platform linux --target AppImage --arch x64) ;;
  mac) args=(--platform mac --target dmg --arch arm64) ;;
  *) echo "usage: fork/build.sh <linux|mac> <version>" >&2; exit 2 ;;
esac
pnpm install --frozen-lockfile
node scripts/build-desktop-artifact.ts "${args[@]}" --build-version "$version" --output-dir "$PWD/release-fork"
