TAG=v1.0.0
REPO_PREFIX=binchenq/microservices-demo
app=adservice
image=$(REPO_PREFIX):$(app)-$(TAG)

build_all:
	cd hack && sh make-docker-images.sh $(TAG) $(REPO_PREFIX)

build_service:
	cd src/$(app) && docker build -t $(image) .
	docker push $(image)


recover:
 	export https_proxy=127.0.0.1:44787
