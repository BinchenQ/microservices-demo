#!/bin/bash

# This script creates a new release by:
# - 1. building/pushing images
# - 2. injecting tags into YAML manifests
# - 3. creating a new git tag
# - 4. pushing the tag/commit to main.

set -e
SCRIPTDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

log() { echo "$1" >&2; }
fail() { log "$1"; exit 1; }

VERSION="${1:-${TAG:?TAG env variable must be specified}}"
REPO_PREFIX="${REPO_PREFIX:?REPO_PREFIX env variable must be specified}"

if [ "$VERSION" != v* ]; then
    fail "\$VERSION must start with 'v', e.g. v0.1.0 (got: $VERSION)"
fi

# build and push images
"${SCRIPTDIR}"/make-docker-images.sh

# update yaml
"${SCRIPTDIR}"/make-release-artifacts.sh

# create git release / push to new branch
git checkout -b "release/${VERSION}"
git add "${SCRIPTDIR}/../release/"
git commit --allow-empty -m "Release $VERSION"
log "Pushing k8s manifests to release/${VERSION}..."
git tag "$VERSION"
git push --set-upstream origin "release/${VERSION}"
git push --tags

log "Successfully tagged release $VERSION."
