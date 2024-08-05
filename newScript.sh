#!/bin/bash

SRCE_DIR="."
DEST_DIR_LOCAL="/data/VideoRecordeArch/Temp_Local"

if [ ! -d "$SRCE_DIR" ]; then
	echo "Source directory does not exist."
	exit 1
fi

if [ ! -d "$DEST_DIR_LOCAL" ]; then
	echo "Local destination directory does not exist."
	exit 1
fi
