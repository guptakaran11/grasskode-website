#!/bin/bash

src=$1
dest=$2

if [ ! -d $src ]
then
	echo "Invalid source"
	exit 2
fi

if [ ! -d $dest ]
then
	echo "Invalid destination"
	exit 2
fi

for d in $src/*/ ; do
	src_dir="${d}*"
	dest_dir="${dest}/$(basename ${d})"
	cp -v $src_dir $dest_dir
done
