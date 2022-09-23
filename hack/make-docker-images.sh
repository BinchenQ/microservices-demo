#!/bin/sh

set -e

log() { echo "$1" >&2; }

SCRIPTDIR=$(cd `dirname "${BASH_SOURCE[0]}"`;pwd)


# build image with subdir(same with submodule name)
function service_build(){
    TAG="${TAG:?TAG env variable must be specified}"
    REPO_PREFIX="${REPO_PREFIX:?REPO_PREFIX env variable must be specified}"

    service=${1:?service must be specified}
    builddir="${SCRIPTDIR}/../src/${service}"
    if [ $service == "cartservice" ];then
        builddir="${builddir}/src"
    fi
    if [ -d ${builddir} ];then
        image="${REPO_PREFIX}:$service-$TAG"
        (
            cd "${builddir}"
            log "Building: ${image}"
            docker build -t "${image}" .

            log "Pushing: ${image}"
            docker push "${image}"
        )
    else
        echo "NOT FOUND ${builddir} "
        exit 1
    fi
}
code_dirs=${1:-`ls "${SCRIPTDIR}/../src"`}
echo $code_dirs
for dir in ${code_dirs};do
    service_build ${dir}
done

log "Successfully built and pushed all images."
