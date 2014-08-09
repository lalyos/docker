#!/bin/bash

: ${S3_TARGET:="sequenceiq/builds"}

: << KOMMENT
KOMMENT

echo [INFO] pulls latest docker source from github and build darwin and linux 64 bit binary
docker run --name docker-hack -it --privileged \
  -e TESTFLAGS -e TESTDIRS -e DOCKER_GRAPHDRIVER \
  -e DOCKER_EXECDRIVER -e DOCKER_CROSSPLATFORMS="linux/amd64  darwin/amd64" \
  --entrypoint /bin/bash \
  docker-dev:latest \
  -c 'ln -s /go/src/github.com/dotcloud /go/src/github.com/docker && git checkout master && git fetch origin && git reset --hard origin/master && hack/make.sh binary cross'

echo [INFO] copies binaries out
docker cp docker-hack:/go/src/github.com/dotcloud/docker/bundles .

VER=$(ls -rt1 bundles|tail -1)
echo [INFO] version=$VER

cd  bundles/$VER/cross
for file in $(find . -name docker-$VER); do
  filePath=${file:2}
  echo [UPLOAD] s3://$S3_TARGET/$filePath ...
  aws s3 cp $file s3://$S3_TARGET/$filePath --acl public-read
  echo [DOWNLOADLINK] https://s3-eu-west-1.amazonaws.com/${S3_TARGET}/$filePath
echo
done

cd -
docker rm docker-hack
