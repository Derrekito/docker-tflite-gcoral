#!/bin/bash

CONTAINER_DIR="/shared"
IMAGE_TAG="tflite-tpu:0.1"
CONTAINER_NAME="tflite-tpu"

if [ $# -eq 0 ]
then
    echo "Warning: No local directory provided. The container will be started without linking to $CONTAINER_DIR."
    docker run -it --name $CONTAINER_NAME $IMAGE_TAG
else
    LOCAL_DIR=$1
    docker run -it -v $LOCAL_DIR:$CONTAINER_DIR --name $CONTAINER_NAME $IMAGE_TAG
fi
