#!/bin/bash

TAG="tflite-tpu:0.1"

#docker build --no-cache --tag "$TAG" .
docker build --tag "$TAG" .
