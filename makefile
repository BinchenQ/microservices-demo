TAG=v1.0.0
REPO_PREFIX=binchenq/microservices-demo
SERVICE=adservice

build_all:
	TAG=$(TAG) REPO_PREFIX=$(REPO_PREFIX) sh hack/make-docker-images.sh

build_service:
	cat hack/make-docker-images.sh && sleep 5000
	TAG=$(TAG) REPO_PREFIX=$(REPO_PREFIX) sh hack/make-docker-images.sh $(SERVICE)

rls:
	# This script creates a new release by:
	# - 1. building/pushing images
	# - 2. injecting tags into YAML manifests
	# - 3. creating a new git tag
	# - 4. pushing the tag/commit to main.
	TAG=$(TAG) REPO_PREFIX=$(REPO_PREFIX) sh hack/make-release.sh $(TAG)

recover:
 	export https_proxy=127.0.0.1:44787
