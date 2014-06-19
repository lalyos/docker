: << KOMMENT
export BOOT2DOCKER_CFG_DIR=~/.boot2docker-v0.7.1-HACK
boot2docker status

docker run --privileged -ti -e TESTFLAGS -e DOCKER_GRAPHDRIVER -e DOCKER_EXECDRIVER  docker:HEAD /bin/bash
KOMMENT

CONTAINER_NAME=docker-hack-build
: ${VERSION:=0.10.0}
: ${DOCKER_BIN:=docker-$VERSION}
: ${DOCKER_HACK_BIN:=${DOCKER_BIN}-HACK}
: ${IMAGE:=docker-hack}
#: ${IMAGE:=docker-dev}

(docker stop -t 1 $CONTAINER_NAME ; docker rm $CONTAINER_NAME )&>/dev/null
docker run -it --name $CONTAINER_NAME -e TESTFLAGS -e DOCKER_GRAPHDRIVER -e DOCKER_EXECDRIVER  --privileged  $IMAGE /bin/bash -c 'git pull --rebase lalyos hack && git log -1 && ./hack/make.sh binary'

echo get docker from container to local dir ...
docker cp $CONTAINER_NAME:/go/src/github.com/dotcloud/docker/bundles/$VERSION/binary/$DOCKER_BIN .
mv $DOCKER_BIN $DOCKER_HACK_BIN

echo scp binary into b2d ...
scp $DOCKER_HACK_BIN b2d:/tmp

echo link new binary...
ssh b2d sudo mv /tmp/$DOCKER_HACK_BIN /usr/local/bin/

echo restart docker ...
ssh b2d sudo /etc/init.d/docker restart
