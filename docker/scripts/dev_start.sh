#!/usr/bin/bash

WORKING_FOLDER="$( cd "$( dirname "${BASH_SOURCE[0]}" )/../.." && pwd )"
CONTAINER_NAME=dm_vio_dev

IMG=dm_vio_devel_x86:2022-06-13_10-47-04

# rm old container
docker ps -a --format "{{.Names}}" | grep $CONTAINER_NAME 1>/dev/null
if [ $? == 0 ]; then
  echo rm old $CONTAINER_NAME.
  docker stop $CONTAINER_NAME 1>/dev/null
  docker rm -f $CONTAINER_NAME 1>/dev/null
fi

docker run \
  -itd \
  --privileged \
  --gpus all \
  -e NVIDIA_VISIBLE_DEVICES=all \
  -e NVIDIA_DRIVER_CAPABILITIES=all \
  -e DISPLAY=$DISPLAY \
  --name $CONTAINER_NAME \
  -v $WORKING_FOLDER:/slam \
  -v /tmp/.X11-unix:/tmp/.X11-unix \
  -w /slam \
  --net host \
  --pid=host \
  --shm-size='6g' \
  $IMG
