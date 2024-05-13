#!/bin/bash

for FILE in *.mov
do
	DEST=(${FILE:0:4}/${FILE:4:2}/${FILE:6:2})
	mkdir -p $DEST
	mv $FILE $DEST
done
