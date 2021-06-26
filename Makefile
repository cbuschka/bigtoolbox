PROJECT_DIR := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))
VERSION ::= $(shell git describe --always --tags --dirty)

build:
	@cd $(PROJECT_DIR)
	docker build -t bigtoolbox:local .

run:	build
	@cd $(PROJECT_DIR)
	docker run --rm -ti \
		-h bigtoolbox \
		-e RUN_AS_UID=$(shell id -u) \
		-e RUN_AS_GID=$(shell id -g) \
		-v /var/run/docker.sock:/var/run/docker.sock \
		-v ${HOME}/.ssh:/me/.ssh:ro \
		-v ${HOME}/.docker:/me/.docker:ro \
		-v ${HOME}/.m2:/me/.m2:ro \
		-v ${PWD}:/work \
		-v $(shell readlink -f ${SSH_AUTH_SOCK}):/ssh-agent \
		-e SSH_AUTH_SOCK=/ssh-agent \
		bigtoolbox:local bash

release:	build
	docker tag bigtoolbox:local docker.io/cbuschka/bigtoolbox:$(VERSION)
	docker tag bigtoolbox:local docker.io/cbuschka/bigtoolbox:latest
	docker push docker.io/cbuschka/bigtoolbox:$(VERSION)
	docker push docker.io/cbuschka/bigtoolbox:latest
