#!/bin/sh
set -e

if [ -n "$WERCKER_DOCKER_BUILD_FORCE_RM" ]; then
  FORCE_RM="--force-rm $WERCKER_DOCKER_BUILD_FORCE_RM"
fi

if [ -n "$WERCKER_DOCKER_BUILD_NO_CACHE" ]; then
  NO_CACHE="--no-cache $WERCKER_DOCKER_BUILD_NO_CACHE"
fi

if [ -n "$WERCKER_DOCKER_BUILD_QUIET" ]; then
  QUIET="--quiet $WERCKER_DOCKER_BUILD_QUIET"
fi

if [ -n "$WERCKER_DOCKER_BUILD_RM" ]; then
  RM="--rm $WERCKER_DOCKER_BUILD_RM"
fi

if [ -n "$WERCKER_DOCKER_BUILD_TAG" ]; then
  TAG="--tag $WERCKER_DOCKER_BUILD_TAG"
fi

type_exists() {
  if [ $(type -P $1) ]; then
    return 0
  fi
  return 1
}

# Check for Docker
if ! type_exists 'docker'; then
  fail 'Docker is not installed on this box.'
  info 'Please use a box with docker installed : http://devcenter.wercker.com/articles/docker'
  exit 1
fi

# Check a Dockerfile is present
if [ -f 'Dockerfile' ]; then
  fail 'A Dockerfile is required.'
  info 'Please create a Dockerfile : https://docs.docker.com/reference/builder/'
  exit 1
fi

# Build the docker image
info 'building docker image'

set +e
DOCKER_BUILD="docker build $FORCE_RM $NO_CACHE $QUIET $RM $TAG ."
debug "$DOCKER_BUILD"
DOCKER_BUILD_OUTPUT=$($DOCKER_BUILD)

if [[ $? -ne 0 ]];then
  warn $DOCKER_BUILD_OUTPUT
  fail 'docker build failed';
else
  success 'docker build succeed';
fi
set -e
