#!/bin/bash

for yml in `find *.yml`
do
	i=$((i+1))
	allyml[$i]=$yml
	if [ -z $1 ]; then
		echo "${i}. ${yml}"
	fi
done

if [ -z $1 ]; then
	read -p "Select yml: " select_yml
else
	let "select_yml = $1"
fi

current_yml=${allyml[${select_yml}]}

if [ -z $2 ]; then
	echo
	echo "1. up"
	echo "2. down"
	echo "3. restart"
	echo "4. build"
	echo "5. pull"
	echo "6. logs"
	echo "7. Enter in webserver container"
	echo "8. Enter in database container"
	echo "9. Enter in postgres container"
	echo "10. Enter in redis container"
	echo "11. Enter in memcache container"
	read -p "Select command: " select_command
else
	let "select_command = $2"
fi

case $select_command in
1) docker compose -f ${current_yml} up -d --remove-orphans;;
2) docker compose -f ${current_yml} down --remove-orphans;;
3) docker compose -f ${current_yml} restart;;
4) COMPOSE_BAKE=true docker compose -f ${current_yml} build;;
5) docker compose -f ${current_yml} pull;;
6) docker compose -f ${current_yml} logs -f;;
7) docker compose -f ${current_yml} exec webserver bash;;
8) docker compose -f ${current_yml} exec database bash;;
9) docker compose -f ${current_yml} exec postgres bash;;
10) docker compose -f ${current_yml} exec redis bash;;
11) docker compose -f ${current_yml} exec memcache bash;;
*) echo "Unknow command";;
esac
