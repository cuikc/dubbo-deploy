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

#################################
# change config file
#################################

if [[ -e "$DUBBO_PATH""$SERVICE_PATH"/conf/dubbo.properties ]]
then
	echo "dubbo.properties is here";
	PORT_CONF='';
	PORT_CONF=`egrep -c '^dubbo.protocol.port' "$DUBBO_PATH""$SERVICE_PATH"/conf/dubbo.properties`;
	if [[ "$PORT_CONF" == 0 ]]		#PORT_CONF没有找到port设置，则在配置文件末尾添加一行端口参数。
	then
		echo "insert"
		echo "$PORT_CONF";
		sed -i '$a\dubbo.protocol.port='"${2}" "$DUBBO_PATH""$SERVICE_PATH"/conf/dubbo.properties;
	else					#如果有一个或多个port的设置，则替换为参数指定的端口号。
		echo "change"
		echo "$PORT_CONF";
		echo "$2";
		sed -i "s/^dubbo\.protocol\.port=.*/dubbo.protocol.port="$2"/" "$DUBBO_PATH""$SERVICE_PATH"/conf/dubbo.properties;
	fi
	
	NAME_CONF='';
	NAME_CONF=`egrep -c '^dubbo.application.name=' "$DUBBO_PATH""$SERVICE_PATH"/conf/dubbo.properties`
	if [[ "$NAME_CONF" == 0 ]]		#如果没有service-name设置，则在配置文件末尾添加一行service-name参数。
	then
		echo "insert";
		echo "$NAME_CONF";
		sed -i '$a\dubbo.application.name='"${1}" "$DUBBO_PATH""$SERVICE_PATH"/conf/dubbo.properties;
	else					#如果有一个或多个service-name设置，则替换为参数指定的service-name。
		echo "change";
		echo "$NAME_CONF";
		echo "$1";
		sed -i "s/^dubbo\.application\.name=.*/dubbo.application.name="$1"/" "$DUBBO_PATH""$SERVICE_PATH"/conf/dubbo.properties;
		uniq "$DUBBO_PATH""$SERVICE_PATH"/conf/dubbo.properties > "$DUBBO_PATH""$SERVICE_PATH"/conf/dubbo.properties-uniq;
		mv "$DUBBO_PATH""$SERVICE_PATH"/conf/dubbo.properties-uniq "$DUBBO_PATH""$SERVICE_PATH"/conf/dubbo.properties;
	fi
else
	echo "there is no dubbo.properties";
fi

###################################


###################################
#check the prot is useing or not
###################################

PORT_STATUS=`netstat -plnut | awk '{print $4}' | awk -F ":" '{print $2}' | \
while read PORTS 
do
	#echo $PORTS;
	#echo $2;
	if [[ "$PORTS" == $2 ]]
	then
		#echo "The Port is in using by someone,Please choose another one,Thanks.";
		echo "no";
		break;
	#else
		#echo "OK";
	fi
done`;

echo $PORT_STATUS;

if [[ "$PORT_STATUS" == "no" ]]
then
	echo "The Port is in using by someone,Please choose another one,Thanks.";
	exit;
fi
echo "check port complete";




