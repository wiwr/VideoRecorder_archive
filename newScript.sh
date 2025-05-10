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

copy_file() {
	SRCE_FILE="$1"
	DEST_DIR="$2"
	REL_PATH="${SRCE_FILE#$SRCE_DIR/}"
	DEST_FILE="$DEST_DIR/$REL_PATH"

	CMD_CHECK_EXIST="[ -f '$DEST_FILE' ]"
	CMD_COMPARE="cmp -s '$SRCE_FILE' '$DEST_FILE'"
	CMD_MKDIR="mkdir -p '$(dirname "$DEST_FILE")'"
}
