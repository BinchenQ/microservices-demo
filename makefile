TAG=v1.0.0
REPO_PREFIX=binchenq/microservices-demo
app=adservice
image=$(REPO_PREFIX):$(app)-$(TAG)

build_all:
	TAG=$(TAG) REPO_PREFIX=$(REPO_PREFIX) cd hack && sh make-docker-images.sh

build_service:
	cd src/$(app) && docker build -t $(image) .
	docker push $(image)

release:
	# This script creates a new release by:
	# - 1. building/pushing images
	# - 2. injecting tags into YAML manifests
	# - 3. creating a new git tag
	# - 4. pushing the tag/commit to main.
	TAG=$(TAG) REPO_PREFIX=$(REPO_PREFIX) cd hack && sh make-release.sh

recover:
 	export https_proxy=127.0.0.1:44787
