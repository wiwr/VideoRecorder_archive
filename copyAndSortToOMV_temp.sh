#!/bin/bash


fMove() {
  echo "------------------------------------------------" >> $LOGS
  for FILE in `ls ${1}`
  do
	  DEST=(${2}/${FILE:0:4}/${FILE:4:2}/${FILE:6:2})
    FILE="${1}/${FILE}"
	  [[ ! -d "$DEST" ]] &&  mkdir -p $DEST
    cp -v $FILE  $DEST 2>> $LOGS
    let COUNT_FILES++
  done
  echo -e "------------------------------------------------\n" >> $LOGS
}

fLocation() {
  echo $1 | tee -a $LOGS
  echo $3 >> $LOGS
  [[ -d "$3" ]] && fMove $2 $3 || echo "Path ${3} is not aviable" | tee -a $LOGS
}

echo 

DATE=`date "+%Y%m%d"`
TIME=`date "+%H%M%S"`
LOGFOLDER="/data/VideoRecordeArch/log"
LOGS="${LOGFOLDER}/log_${DATE}_${TIME}.log"

[[ ! -d "$LOGFOLDER" ]] && mkdir -p $LOGFOLDER
echo -e "Date: ${DATE:0:4}-${DATE:4:2}-${DATE:6:2} Time: ${TIME:0:2}:${TIME:2:2}:${TIME:4:2}\n" >> $LOGS

echo "Podaj markę pojazdu, z którego wyciągnięto kartę:"
CARS="Citroen Megane Test"

select CAR in $CARS; do
  echo "Wybrano ${CAR}"
  read -p "Potwierdz ten wybór wpisując 'tak': " TAK
  [[ "$TAK" == "tak" ]] && break
done

echo $CAR
COUNT_FILES=0
START_TIME=$(date +'%s')

fLocation "++ lock to external drive" "lock" "/mnt/nfs/Backup/VideoRecordeArch/${CAR}/lock"
fLocation "++ video to external drive" "video" "/mnt/nfs/Backup/VideoRecordeArch/${CAR}/video" 
fLocation "++ lock to local drive" "lock" "/data/VideoRecordeArch/${CAR}/lock" 

TIME_NEED=$(($(date +'%s') - $START_TIME))
DISPLAY_TIME="$((TIME_NEED/3600))h $(((TIME_NEED/60)%60))m $((TIME_NEED%60))s"
echo "Wykonanie trwało ${DISPLAY_TIME}" | tee -a $LOGS
echo "Skopiowano ${COUNT_FILES} plików" | tee -a $LOGS
DATE=`date "+%Y-%m-%d"`
TIME=`date "+%H:%M:%S"`
echo "Date: ${DATE} Time: ${TIME}" >> $LOGS
