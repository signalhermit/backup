#!/bin/bash

# This script rotates a VPN connection in a specified time interval

TIME=10
VPN="nordvpn"
useCity=false

while [ -n "$#" ]; do

		case "$1" in

				-t) TIME="$2";;
				-v) VPN="$2";;
				-c) useCity=true;;
		esac

		shift
		break;
done


nordVpn()
{
		connectors=()

		if [ "$useCity" ]; then
				rawData=$(nordvpn cities)
		else 
				rawData=$(nordvpn countries)
		fi

		for OB in $rawData; do
				
				if [ $OB != " " ] ; then
						connectors=(${connectors[@]} $OB)
				elif [ $OB != " " && $OB == *"login"* ]; then
						echo "You are not logged in. Please enter your login credentials. Excecution will continue afterwards."
						read -p "Press [Enter] to continue."
				fi
		done

		# Setting VPN connection to a random tunnel for $TIME

		randNum=()
		for i in ${#connectors[@]}; do
				randNum=(${randNum[@]} $(($RANDOM % ${#connectors[@]})))
				echo "${randNum[$i]}"
		done

		while true; do

				for n in $randNum; do
						(eval "nordvpn connect ${connectors[${randNum[$n]}]}")
						sleep $TIME 
						read stop &
						if [[ $stop == "q" ]]; then
								exit 0;
						fi

				done

		done
		return
}

if [ "$VPN" == "nordvpn" ]; then
		nordVpn
		exit 0
elif [ "$VPN" == "fastd"]; then
		fastD
		exit 0
fi


