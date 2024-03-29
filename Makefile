OWNER := fabianlee
PROJECT := docker-debian-bullseye-slim-ntpclient
VERSION := 1.0.0
OPV := $(OWNER)/$(PROJECT):$(VERSION)

# you may need to change to "sudo docker" if not a member of 'docker' group
# add user to docker group: sudo usermod -aG docker $USER
DOCKERCMD := "docker"

BUILD_TIME := $(shell date -u '+%Y-%m-%d_%H:%M:%S')
# unique id from last git commit
MY_GITREF := $(shell git rev-parse --short HEAD)


## builds docker image
docker-build:
	@echo MY_GITREF is $(MY_GITREF)
	$(DOCKERCMD) build -f Dockerfile -t $(OPV) .

## cleans docker image
clean:
	$(DOCKERCMD) image rm $(OPV) | true

## runs container in foreground, testing a couple of override values
docker-run-fg:
	$(DOCKERCMD) run -it --rm $(OPV)

## runs container in foreground, override entrypoint to use use shell
docker-debug:
	$(DOCKERCMD) run -it --rm --entrypoint "/bin/bash" $(OPV)

## run container in background
docker-run-bg:
	$(DOCKERCMD) run -d --rm --name $(PROJECT) $(OPV)

## get into console of container running in background
docker-cli-bg:
	$(DOCKERCMD) exec -it $(PROJECT) /bin/bash

## tails $(DOCKERCMD)logs
docker-logs:
	$(DOCKERCMD) logs -f $(PROJECT)

## stops container running in background
docker-stop:
	$(DOCKERCMD) stop $(PROJECT)

## pushes to $(DOCKERCMD)hub
docker-push:
	$(DOCKERCMD) push $(OPV)

## pushes to kubernetes cluster
k8s-apply:
	sed -e 's/1.0.0/$(VERSION)/' k8s-chrony-alpine.yaml | kubectl apply -f -

k8s-delete:
	kubectl delete -f k8s-chrony-alpine.yaml
