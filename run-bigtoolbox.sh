#!/bin/bash

BIGTOOLBOX_IMAGE=${BIGTOOLBOX_IMAGE:-cbuschka/bigtoolbox:latest}

docker run --rm -ti \
	-h bigtoolbox \
	-e RUN_AS_UID=$(id -u) \
	-e RUN_AS_GID=$(id -g) \
	-v /var/run/docker.sock:/var/run/docker.sock \
	-v ${HOME}/.ssh:/me/.ssh:ro \
	-v ${HOME}/.docker:/me/.docker:ro \
	-v ${HOME}/.m2:/me/.m2:ro \
	-v ${PWD}:/work \
	-v $(readlink -f ${SSH_AUTH_SOCK}):/ssh-agent \
	-e SSH_AUTH_SOCK=/ssh-agent \
	${BIGTOOLBOX_IMAGE} bash
