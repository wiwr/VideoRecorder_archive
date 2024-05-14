#!/bin/bash

fClean() {
  if [ -d "${1}" ]; then
    rm ${1}/.PreAllocFile_* 2> /dev/null
  fi
}

for dir in emr emr_b norm norm_b photo photo_b; do
  echo $dir
  fClean $dir
done
