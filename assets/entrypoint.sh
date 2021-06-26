#!/bin/bash

EXTRA_GROUPS=
if [ -e "/var/run/docker.sock" ]; then
  DOCKER_GID=$(stat -c %g /var/run/docker.sock)
  groupadd -g ${DOCKER_GID} docker || true
  EXTRA_GROUPS=docker
fi

if [ -z "$1" ]; then
  echo "No command given."
  exit 1
fi

RUN_AS_USERNAME=me
RUN_AS_HOME=/${RUN_AS_USERNAME}
if [ ! -z "${RUN_AS_UID}" ]; then
  if [ "${UID}" != "0" ]; then
    echo "Cannot switch to ${RUN_AS_UID}, not running as root."
    exit 1
  fi

  if [ -z "${RUN_AS_GID}" ]; then
    echo "Env variable RUN_AS_GID is missing."
    exit 1
  fi

  groupadd -g ${RUN_AS_GID} ${RUN_AS_USERNAME}
  useradd -u ${RUN_AS_UID} -g ${RUN_AS_GID} -G "${EXTRA_GROUPS}" -d ${RUN_AS_HOME} ${RUN_AS_USERNAME}
  chown ${RUN_AS_USERNAME}.${RUN_AS_USERNAME} ${RUN_AS_HOME}
  exec gosu ${RUN_AS_USERNAME} bash -c "$@" 
else
  exec "$@"
fi
