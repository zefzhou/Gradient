#!/bin/bash

# ip="4.5.6.7"
# converted="${ip//./-}"
# echo "$converted"

CONFIG_FILE_NAME=$1
# CONTAINER_NAME="Gradient-${CONFIG_FILE_NAME//./-}"
# echo "$CONTAINER_NAME"

CONFIG_FILE="$(pwd)/${CONFIG_FILE_NAME}.txt"
echo "$CONFIG_FILE"
