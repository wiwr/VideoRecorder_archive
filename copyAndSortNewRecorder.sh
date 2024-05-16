#!/bin/bash

for folder in emr emr_b norm norm_b; do
    echo ${folder}
    for file in `ls ${folder}`; do
        echo ${file} 
	echo ${file:0:4}-${file:5:2}-${file:8:2}
	dest=../temp_dest/${folder}/${file:0:4}/${file:5:2}/${file:8:2}
	[[ ! -d "${dest}" ]] && mkdir -p ${dest}
    done
done
