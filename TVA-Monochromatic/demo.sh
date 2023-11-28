#!/usr/bin/env bash
RED='\033[1;31m'
GREEN='\033[1;32m'
YLLW='\033[1;33m'
NC='\033[0m'
# Check if runing as root user
if [ "$EUID" -ne 0 ]; then
	echo -e "[${RED}ERROR${NC}]\nThis script needs to run as ${YLLW}root user${NC}, please use \"${GREEN}sudo ./show-splash.sh${NC}\" instead";
	exit 1;
fi



# Starting plymouth deamon to show splashscreen
echo -n "Starting plymounthd                              >>>   ";
plymouthd ;
if [ $? -gt 0 ]; then
	echo -e "[${RED}ERROR${NC}]\nError occoured while starting plymounthd" ;
	echo "Quitting Plymouthd <<<"
	plymouth --quit ;
	if [ $? -gt 0 ]; then
		echo "Error occoured stopping plymouthd" ;
		echo "Plymouthd might be still running in background"
		exit 1;
	fi
	exit 1;
fi
echo -e "[${GREEN}OK${NC}]" ;



echo -n "Showing currently selected splash screen theme   >>>   ";
plymouth show-splash ;
sleep 10 ;
echo -e "[${GREEN}OK${NC}]" ;



echo -n "Quitting Plymouthd                               >>>   ";
plymouth --quit ;
if [ $? -gt 0 ]; then
	echo -e "${RED}ERROR${NC}]\nError occoured stopping plymouthd, retring" ;
	n=0 ;
	while [ $? -gt 0 -a $n -le 20 ]; do
		plymouth --quit ;
		n=$(( n+1 )) ;
	done
fi
echo -e "[${GREEN}OK${NC}]" ;



exit 0;
