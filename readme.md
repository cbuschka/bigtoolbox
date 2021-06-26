# Debian (stretch) Docker Container with useful Tools
[![github](https://img.shields.io/badge/github-bigtoolbox-green)](https://github.com/cbuschka/bigtoolbox)

## Tools

* curl
* jq
* dnsutils
* build-essential
* make
* python
* git
* openssh-client
* vim
* go 1.16
* maven 3.6
* docker client
* node v10.15
* openjdk 11
* libpng-dev
* yarn
* gnupg2

## Usage

```
docker run --rm -ti \
	-e RUN_AS_UID=$(id -u) \
	-e RUN_AS_GID=$(id -g) \
	-v /var/run/docker.sock:/var/run/docker.sock \
	-v ${HOME}/.ssh:/me/.ssh:ro \
	-v ${HOME}/.docker:/me/.docker:ro \
	-v ${HOME}/.m2:/me/.m2:rw \
	-v ${PWD}:/work \
	-v $(shell readlink -f ${SSH_AUTH_SOCK}):/ssh-agent \
	-e SSH_AUTH_SOCK=/ssh-agent \
	cbuschka/toolbox:latest bash
```

## License
Copyright (c) 2021 by [Cornelius Buschka](https://github.com/cbuschka).

[MIT-0](./license.txt)

