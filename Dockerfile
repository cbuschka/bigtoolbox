FROM debian:stretch

ENV TZ=Europe/Berlin
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

RUN export DEBIAN_FRONTEND=noninteractive; \
	echo "deb http://deb.debian.org/debian stretch-backports main" > /etc/apt/sources.list.d/debian-stretch-backports.list \
	apt-get update && \
	apt-get clean && rm -rf /var/lib/apt/lists/*

RUN export DEBIAN_FRONTEND=noninteractive; \
	apt-get update && \
	apt-get install --no-install-recommends -y locales curl python libpng-dev build-essential git procps apt-transport-https ca-certificates software-properties-common apt-utils openssh-client vim make gnupg2 dnsutils jq bash-completion && \
	ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && \
	sed -i 's/^# *\(en_US.UTF-8\)/\1/' /etc/locale.gen && \
	locale-gen en_US.UTF-8 && \
	echo "LANG=\"en_US.UTF-8\"" > /etc/default/locale && \
	apt-get clean && rm -rf /var/lib/apt/lists/*

RUN export DEBIAN_FRONTEND=noninteractive; \
	apt-get update && \
	rm -f /etc/ssl/certs/java/cacerts && \
	apt-get install -y --no-install-recommends -t stretch-backports openjdk-11-jdk-headless && \
	rm /etc/ssl/certs/java/cacerts && \
	update-ca-certificates -f && \
	apt-get clean && rm -rf /var/lib/apt/lists/*
COPY assets/etc/ssl/certs/java/cacerts /etc/ssl/certs/java/cacerts

ENV M2_VERSION 3.6.1
ENV M2_HOME /opt/apache-maven
RUN curl -sS -o /tmp/apache-maven.tgz https://repo.maven.apache.org/maven2/org/apache/maven/apache-maven/${M2_VERSION}/apache-maven-${M2_VERSION}-bin.tar.gz && \
	tar xvfz /tmp/apache-maven.tgz -C /opt/ && \
	mkdir -p /usr/local/bin/ && \
	ln -s /opt/apache-maven/bin/mvn /usr/local/bin/mvn && \
	ln -s /opt/apache-maven-${M2_VERSION} /opt/apache-maven && \
	rm /tmp/apache-maven.tgz

RUN export DEBIAN_FRONTEND=noninteractive; \
	curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add - && \
	add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian stretch stable" && \
	apt-get update && \
	apt-cache policy docker-ce && \
	apt-get install -y --no-install-recommends docker-ce-cli && \
	apt-get clean && rm -rf /var/lib/apt/lists/*

ENV NODE_VERSION v10.15.3
RUN curl -sS -o /tmp/nodejs.tgz https://nodejs.org/dist/${NODE_VERSION}/node-${NODE_VERSION}-linux-x64.tar.gz && \
	tar xvfz /tmp/nodejs.tgz -C /usr/local/ && \
	rm /tmp/nodejs.tgz && \
	ln -s /usr/local/node-${NODE_VERSION}-linux-x64/bin/node /usr/local/bin/node && \
	ln -s /usr/local/node-${NODE_VERSION}-linux-x64/bin/npm /usr/local/bin/npm && \
	ln -s /usr/local/node-${NODE_VERSION}-linux-x64/bin/npx /usr/local/bin/npx && \
	/usr/local/bin/npm install -g yarn && \
	ln -s /usr/local/node-${NODE_VERSION}-linux-x64/bin/yarnpkg /usr/local/bin/yarnpkg && \
	ln -s /usr/local/node-${NODE_VERSION}-linux-x64/bin/yarn /usr/local/bin/yarn

ARG GO_VERSION=1.16.5
ENV GOROOT=/opt/go
ENV PATH=${GOROOT}/bin:${PATH}
RUN curl -fsSL https://golang.org/dl/go${GO_VERSION}.linux-amd64.tar.gz -o /tmp/go${GO_VERSION}.linux-amd64.tar.gz && \
	mkdir -p /usr/local/bin/ && \
	tar xvfz /tmp/go${GO_VERSION}.linux-amd64.tar.gz -C /opt/ && \
	rm /tmp/go${GO_VERSION}.linux-amd64.tar.gz && \
	ln -s /opt/go-${GO_VERSION} /opt/go && \
	go version

ENV GOSU_VERSION 1.13
RUN mkdir -p /usr/local/bin && \
	curl -sSL -o /usr/local/bin/gosu-${GOSU_VERSION} https://github.com/tianon/gosu/releases/download/${GOSU_VERSION}/gosu-amd64 && \
	chmod 755 /usr/local/bin/gosu-${GOSU_VERSION} && \
	ln -s /usr/local/bin/gosu-${GOSU_VERSION} /usr/local/bin/gosu

RUN mkdir -p /ego
WORKDIR /work

COPY /assets/entrypoint.sh /entrypoint.sh

ENTRYPOINT [ "/entrypoint.sh" ]
