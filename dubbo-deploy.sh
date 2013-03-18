#!/bin/bash

DUBBO_PATH="/ROOT/www/dubbo/"

#################################
# Useage
#################################

if [[ -z $1 || -z $2 || -z $3 ]]
then
	echo "Useage:./dubbo-deploy.sh \"service-name\" \"port\" \"service.tar.gz\"";
	exit 1;
fi
#################################


SERVICE_PATH="$1_$2";
echo "$SERVICE_PATH";

#################################
# check directory
#################################

if [[ ! -d "/ROOT/www/dubbo/$SERVICE_PATH" ]]
then
	#su - webmaster -c "mkdir -p /ROOT/www/dubbo/""$SERVICE_PATH";
	mkdir -p "$DUBBO_PATH""$SERVICE_PATH";
	ls -al "$DUBBO_PATH";
fi
#################################

TAR_TYPE=`echo "$3" | awk -F "." '{print $NF}'`;
echo $TAR_TYPE

if [[ "$TAR_TYPE" == "gz" ]]
then
	echo "start tar gz"
	tar -zxf "$3" -C "$DUBBO_PATH""$SERVICE_PATH";
else
	echo "start tar"
	tar -xf "$3" -C "$DUBBO_PATH""$SERVICE_PATH";
fi
