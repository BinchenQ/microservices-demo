#!/bin/bash

# Copyright 2019 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Builds and pushes docker image for each demo microservice.

# set -euo pipefail
set -e 

SCRIPTDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

log() { echo "$1" >&2; }

TAG="${TAG:?TAG env variable must be specified}"
REPO_PREFIX="${REPO_PREFIX:?REPO_PREFIX env variable must be specified}"

code_dirs=`find "${SCRIPTDIR}/../src" -mindepth 1 -maxdepth 1 -type d`
for dir in ${code_dirs};do
# while IFS= read -d $'\0' -r dir; do
    # build image
    svcname="$(basename "${dir}")"
    builddir="${dir}"
    if [ $svcname == "cartservice" ] 
    then
        builddir="${dir}/src"
    fi
    image="${REPO_PREFIX}:$svcname-$TAG"
    (
        cd "${builddir}"
        log "Building: ${image}"
        docker build -t "${image}" .

        log "Pushing: ${image}"
        docker push "${image}"
    )
done

log "Successfully built and pushed all images."
