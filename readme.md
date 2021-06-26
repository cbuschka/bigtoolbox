# debian docker container with useful tools

* openssh-client

## User switching

```
docker run --rm -ti \
	-e RUN_AS_UID=$(id -u) \
	-e RUN_AS_GID=$(id -g) \
	-v /var/run/docker.sock:/var/run/docker.sock \
	-v ${HOME}/.ssh:/build/.ssh:ro \
	-v ${PWD}:/work \
	cbuschka/toolbox:latest bash
```

## License
Copyright (c) 2021 by [Cornelius Buschka](https://github.com/cbuschka).

[MIT-0](./license.txt)

