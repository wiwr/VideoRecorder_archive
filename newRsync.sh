#!/bin/bash

SOURCE_PATH="."
DEST_SERVER="vr_backup"
DEST_PATH="/srv/dev-disk-by-uuid-65f0a1f4-213b-45b9-9029-3ec71adb9e45/Backup/VideoRecordeArch"
EXTRA_SPACE=70000
SINGLE_FILE_SIZE=100
check_space() {
  ssh "$DEST_SERVER" "df -m \"$DEST_PATH\" | tail -1 | awk '{print \$4}'"
}

check_size() {
  #du -ms "$SOURCE_PATH" | cut -f1
  find "$SOURCE_PATH" -not -path '*/\.*' -type f -exec du -b {} + | awk '{sum += $1} END {print int(sum / (1024 * 1024))}'

}

count_files_to_remove() {
  local SPACE_NEEDED=$((EXPECTED_SPACE - AVAILABLE_SPACE))
  local NUMBER_OF_FILES_TO_REMOVE=$((SPACE_NEEDED / SINGLE_FILE_SIZE))
  echo $NUMBER_OF_FILES_TO_REMOVE
}

remove_oldest_file() {
  FILES=$1
  echo "Removing ${FILES} files..."
  ssh "$DEST_SERVER" \
	  "find \
	  	${DEST_PATH}/Citroen/norm \
	  	${DEST_PATH}/Citroen/norm_b \
	  	${DEST_PATH}/Citroen/video \
	  	${DEST_PATH}/Megane/video \
	   -type f -printf '%T+ %p\\n' | sort | head -n ${FILES} | awk '{print \$2}' | xargs rm -f "
}


FILES_SIZE=$(check_size)
echo "Size of files to be coppied is: ${FILES_SIZE}"

EXPECTED_SPACE=$((FILES_SIZE + EXTRA_SPACE))
echo "Needed space for files is:      ${EXPECTED_SPACE}"

AVAILABLE_SPACE=$(check_space)
echo "Available space on dest is:     ${AVAILABLE_SPACE}"

while [[ "$AVAILABLE_SPACE" -lt "$EXPECTED_SPACE" ]]; do 
  NUMBER_TO_REMOVE=$(count_files_to_remove) 
  remove_oldest_file $NUMBER_TO_REMOVE
  AVAILABLE_SPACE=$(check_space)

done

