PROJECT_DIR := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))
VERSION ::= $(shell git describe --always --tags --dirty)

build:
	@cd $(PROJECT_DIR)
	docker build -t toolbox:local .

run:	build
	@cd $(PROJECT_DIR)
	docker run --rm -ti \
		-h toolbox \
		-e RUN_AS_UID=$(shell id -u) \
		-e RUN_AS_GID=$(shell id -g) \
		-v /var/run/docker.sock:/var/run/docker.sock \
		-v ${HOME}/.ssh:/ego/.ssh:ro \
		-v ${PWD}:/work \
		-v $(shell readlink -f ${SSH_AUTH_SOCK}):/ssh-agent \
		-e SSH_AUTH_SOCK=/ssh-agent \
		toolbox:local bash

release:	build
	docker tag toolbox:local docker.io/cbuschka/toolbox:$(VERSION)
	docker tag toolbox:local docker.io/cbuschka/toolbox:latest
	docker push docker.io/cbuschka/toolbox:$(VERSION)
	docker push docker.io/cbuschka/toolbox:latest
