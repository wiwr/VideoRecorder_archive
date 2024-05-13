#!/bin/bash

fMove() {
  echo "------------------------------------------------" >> "$LOGS"
  for FILE in "$1"/*; do
    if [[ -f "$FILE" ]]; then
      DEST="$2/${FILE:0:4}/${FILE:4:2}/${FILE:6:2}"
      FILENAME=$(basename "$FILE")
      if [[ -f "$DEST/$FILENAME" ]]; then
        if ! cmp -s "$FILE" "$DEST/$FILENAME"; then
          cp -v "$FILE" "$DEST/${FILENAME}_updated" 2>> "$LOGS"
          let COUNT_FILES++
        else
          echo "File $FILENAME already exists at destination with the same checksum." >> "$LOGS"
        fi
      else
        mkdir -p "$DEST"
        cp -v "$FILE" "$DEST" 2>> "$LOGS"
        let COUNT_FILES++
      fi
    fi
  done
  echo -e "------------------------------------------------\n" >> "$LOGS"
}

fLocation() {
  echo "$1" | tee -a "$LOGS"
  echo "$3" >> "$LOGS"
  if [[ -d "$3" ]]; then
    fMove "$2" "$3"
  else
    echo "Path ${3} is not available" | tee -a "$LOGS"
  fi
}

calculate_checksum() {
  md5sum "$1" | awk '{print $1}'
}

echo 

DATE=$(date "+%Y%m%d")
TIME=$(date "+%H%M%S")
LOGFOLDER="/data/VideoRecordeArch/log"
LOGS="${LOGFOLDER}/log_${DATE}_${TIME}.log"

[[ ! -d "$LOGFOLDER" ]] && mkdir -p "$LOGFOLDER"
echo -e "Date: ${DATE:0:4}-${DATE:4:2}-${DATE:6:2} Time: ${TIME:0:2}:${TIME:2:2}:${TIME:4:2}\n" >> "$LOGS"

echo "Podaj markę pojazdu, z którego wyciągnięto kartę:"
CARS="Citroen Megane Test"

select CAR in $CARS; do
  echo "Wybrano ${CAR}"
  read -p "Potwierdz ten wybór wpisując 'tak': " TAK
  [[ "$TAK" == "tak" ]] && break
done

echo "$CAR"
COUNT_FILES=0
START_TIME=$(date +'%s')

fLocation "++ lock to external drive" "lock" "/mnt/nfs/Backup/VideoRecordeArch/${CAR}/lock"
fLocation "++ video to external drive" "video" "/mnt/nfs/Backup/VideoRecordeArch/${CAR}/video"
fLocation "++ lock to local drive" "lock" "/data/VideoRecordeArch/${CAR}/lock"

TIME_NEED=$(( $(date +'%s') - START_TIME ))
DISPLAY_TIME="$((TIME_NEED / 3600))h $(((TIME_NEED / 60) % 60))m $((TIME_NEED % 60))s"
echo "Wykonanie trwało ${DISPLAY_TIME}" | tee -a "$LOGS"
echo "Skopiowano ${COUNT_FILES} plików" | tee -a "$LOGS"
DATE=$(date "+%Y-%m-%d")
TIME=$(date "+%H:%M:%S")
echo "Date: ${DATE} Time: ${TIME}" >> "$LOGS"

