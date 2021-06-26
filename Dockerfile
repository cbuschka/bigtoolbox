FROM debian:stretch

ENV TZ=Europe/Berlin
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime

RUN export DEBIAN_FRONTEND=noninteractive; \
	echo "deb http://deb.debian.org/debian stretch-backports main" > /etc/apt/sources.list.d/debian-stretch-backports.list \
	apt-get update && \
	apt-get clean && rm -rf /var/lib/apt/lists/*

RUN export DEBIAN_FRONTEND=noninteractive; \
	apt-get update && \
	apt-get install --no-install-recommends -y locales curl python build-essential git procps apt-transport-https ca-certificates software-properties-common apt-utils openssh-client && \
	sed -i 's/^# *\(en_US.UTF-8\)/\1/' /etc/locale.gen && \
	locale-gen en_US.UTF-8 && \
	echo "LANG=\"en_US.UTF-8\"" > /etc/default/locale && \
	apt-get clean && rm -rf /var/lib/apt/lists/*

ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

RUN mkdir -p /usr/local/bin && \
	curl -sSL -o /usr/local/bin/gosu-1.13 https://github.com/tianon/gosu/releases/download/1.13/gosu-amd64 && \
	chmod 755 /usr/local/bin/gosu-1.13 && \
	ln -s /usr/local/bin/gosu-1.13 /usr/local/bin/gosu

RUN mkdir -p /ego
WORKDIR /work

COPY /assets/entrypoint.sh /entrypoint.sh

ENTRYPOINT [ "/entrypoint.sh" ]
