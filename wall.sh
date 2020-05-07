#!/bin/bash

#Change this to path to wallpaper folder

path="/home/falk/Pictures/wallpapers/jap"
mute=false

while [ -n "$#" ]; do 
		case "$1" in
				-p) path="$2";;
				-m) mute=true;;
				*) echo "Using directory $path";;
		esac
		shift
		break
done

mkdir -p $path

declare -a files=$(ls "$path")

counter=0
declare -a pics=()

for file in $files 
do
	if [ ! -z $file ]; then
		if [[ ! -d "$path/$file" ]]; then
				if [ ! $mute ]; then
						echo "Adding "$file"..."
				fi
				pics=(${pics[@]} $file)		
				fi
		fi
	let "counter++"
done
if [ "${#pics[@]}" -ne 0 ]; then
		randNum=$(($RANDOM % ${#pics[@]}))
else
		if [ ! $mute ]; then
				echo "No wallpapers were found."
		fi
		exit 0
fi

randomPic=${pics[$randNum]}
picOfTheDay="$path/$randomPic"

feh --bg-scale $picOfTheDay

if [ ! $mute ]; then
		echo "Wallpaper has been set to ""$picOfTheDay"
fi
exit 0
