#!/bin/bash

# A POSIX variable
OPTIND=1         # Reset in case getopts has been used previously in the shell.

path=""

while getopts ":p:" opt; do
	case "$opt" in
		\?)
			# ignore
	        ;;
	    p)  
			path="$OPTARG"
			;;
	esac
done

shift $((OPTIND-1))
[ "$1" = "--" ] && shift

echo "path=$path, Leftovers: $@"

trap 'exit' ERR

if [[ $path != "" ]]
then
	cd "$path"
fi

for file in *.jpg
do
	name=${file##*/}
	orig_size=`stat --printf="%s" $name`
	if [ $orig_size -gt 8000000 ]
		then
		echo "++ compressing ${name}..."
		quality=77
		cmd="convert ${name} -quality ${quality} c_${name}"
		echo $cmd
		eval $cmd
		size=`stat --printf="%s" c_$name`
		echo "++ compressed ${name} from ${orig_size} to ${size} at quality ${quality}"
	else
		cmd="cp ${name} c_${name}"
		eval $cmd
		echo "-- skipping ${name}..."
	fi	
done
