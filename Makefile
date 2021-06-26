PROJECT_DIR := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))
VERSION ::= $(shell git describe --always --tags --dirty)

build:
	@cd $(PROJECT_DIR)
	docker build -t bigtoolbox:local .

run:	build
	@cd $(PROJECT_DIR)
	BIGTOOLBOX_IMAGE=bigtoolbox:local ./run-bigtoolbox.sh

release:	build
	docker tag bigtoolbox:local docker.io/cbuschka/bigtoolbox:$(VERSION)
	docker tag bigtoolbox:local docker.io/cbuschka/bigtoolbox:latest
	docker push docker.io/cbuschka/bigtoolbox:$(VERSION)
	docker push docker.io/cbuschka/bigtoolbox:latest
