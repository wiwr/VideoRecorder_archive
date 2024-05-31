#!/bin/bash


fCopy() {
    echo "--------------------------------------------------------------------------" >> $LOGS
    for file in `ls ${1}`; do
	dest=${2}/${folder}/${file:0:4}/${file:5:2}/${file:8:2}
	srce=${1}/${file}
	if [[ ! -e "${dest}/${file}" ]]; then
          [[ ! -d "${dest}" ]] && mkdir -p ${dest}
	  echo "Copping $srce to $dest"
#         cp -v $srce $dest 2>> $LOGS
        else
	  if cmp -s "$src_file" "${dest}/${file}"; then
            echo "File $srec exists with same content. No action taken."
	  else
            echo "File $srce coppied with name ${file%.*}_$(date +%Y%m%d%H%M%S).${file##*.}"
	  fi
        fi
#	cp -v $srce $dest 2>> $LOGS
	let count_files++
    done
    echo "--------------------------------------------------------------------------\n" >> $LOGS
}

fCreateDir() {
  [[ ! -d "$1" ]] && mkdir -p ${1}
  echo "Check ${1} and create ${1}"
}

fLocation() {
    echo $1 | tee -a $LOGS
    echo $3 >> $LOGS
    fCreateDir $3
    [[ -d "$3" ]] && fCopy $2 $3 || echo "Path ${3} is not aviable" | tee -a $LOGS
}

DATE=`date "+%Y%m%d"`
TIME=`date "+%H%M%S"`
LOGFOLDER="/data/VideoRecordeArch/log"
LOGS="${LOGFOLDER}/log_${DATE}_${TIME}.log"

[[ ! -d "$LOGFOLDER" ]] && mkdir -p $LOGFOLDER
echo -e "Date: ${DATE:0:4}-${DATE:4:2}-${DATE:6:2} Time: ${TIME:0:2}:${TIME:2:2}:${TIME:4:2}\n" >> $LOGS

count_files=0
START_TIME=$(date +'%s')

#for directory in emr emr_b norm norm_b; do
#    fLocation "++ ${directory} to external drive" "${directory}" "/mnt/nfs/Backup/VideoRecordeArch/Citroen/${directory}"
#done

for directory in emr emr_b norm norm_b; do
    fLocation "++ ${directory} to local drive" "${directory}" "/data/VideoRecordeArch/Citroen/${directory}"
done

TIME_NEED=$(($(date +'%s') - $START_TIME))
DISPLAY_TIME="$((TIME_NEED/3600))h $(((TIME_NEED/60)%60))m $((TIME_NEED%60))s"
echo "Wykonanie trwało ${DISPLAY_TIME}" | tee -a $LOGS
echo "Skopiowano ${count_files} plików" | tee -a $LOGS
DATE=`date "+%Y-%m-%d"`
TIME=`date "+%H:%M:%S"`
echo "Date: ${DATE} Time: ${TIME}" >> $LOGS

