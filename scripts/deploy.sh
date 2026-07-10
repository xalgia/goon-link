#!/usr/bin/env bash
set -euo pipefail

REMOTE_HOST="${REMOTE_HOST:-linuxuser@45.77.138.117}"
REMOTE_ROOT="${REMOTE_ROOT:-/srv/goonlink}"
REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
RELEASE_ID="${RELEASE_ID:-$(date -u +%Y%m%dT%H%M%SZ)}"
RELEASE_DIR="${REMOTE_ROOT}/releases/${RELEASE_ID}"

cd "${REPO_DIR}"
npm run build

ssh "${REMOTE_HOST}" "sudo mkdir -p '${REMOTE_ROOT}/releases' && sudo chown -R \$(id -un):\$(id -gn) '${REMOTE_ROOT}'"
rsync -az --delete "${REPO_DIR}/dist/" "${REMOTE_HOST}:${RELEASE_DIR}/"
ssh "${REMOTE_HOST}" "set -e; cd '${REMOTE_ROOT}'; ln -s 'releases/${RELEASE_ID}' current.next; mv -Tf current.next current"

echo "Goon Link release ${RELEASE_ID} is live at ${REMOTE_ROOT}/current"
