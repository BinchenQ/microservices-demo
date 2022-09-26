#!/bin/bash

set -e
SCRIPTDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
[[ -n "${DEBUG:-}" ]] && set -x

log() { echo "$1" >&2; }

TAG="${TAG:?TAG env variable must be specified}"
REPO_PREFIX="${REPO_PREFIX:?REPO_PREFIX env variable must be specified}"
OUT_DIR="${OUT_DIR:-${SCRIPTDIR}/../release}"


print_autogenerated_warning() {
    cat<<EOF
# ----------------------------------------------------------
# WARNING: This file is autogenerated. Do not manually edit.
# ----------------------------------------------------------

EOF
}

# define gsed as a function on Linux for compatibility
[ "$(uname -s)" == "Linux" ] && gsed() {
    sed "$@"
}


mk_kubernetes_manifests() {
    print_autogenerated_warning > $1
    echo '# [START release_kubernetes_manifests_microservices_demo]' >> $1

    for dir in `ls ${SCRIPTDIR}/../src`
    do
        svcname="$(basename "${dir}")"
        image="$REPO_PREFIX:$svcname-$TAG"
        pattern="^(\s*)image:\s.*$svcname(.*)(\s*)"
        replace="\1image: $image\3"
        yaml_temp=`find "${SCRIPTDIR}/../kubernetes-manifests" -name '*.yaml' -type f -print|grep $svcname `
        gsed -r "s|$pattern|$replace|g" $yaml_temp >> $1
        echo '---' >> $1
        echo $yaml_temp
    done
    cat ${SCRIPTDIR}/../kubernetes-manifests/redis/redis.yaml >> $1

    echo "# [END release_kubernetes_manifests_microservices_demo]" >> $1
}


main() {
    mkdir -p "${OUT_DIR}"
    local k8s_manifests_file
    k8s_manifests_file="${OUT_DIR}/kubernetes-manifests.yaml"
    mk_kubernetes_manifests  ${k8s_manifests_file}
    log "Written ${k8s_manifests_file}"

}

main
