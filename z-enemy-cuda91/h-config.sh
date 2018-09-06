#!/usr/bin/env bash
# This code is included in /hive/bin/custom function



[[ -z $CUSTOM_TEMPLATE ]] && echo -e "${YELLOW}CUSTOM_TEMPLATE is empty${NOCOLOR}" && return 1
[[ -z $CUSTOM_URL ]] && echo -e "${YELLOW}CUSTOM_URL is empty${NOCOLOR}" && return 1
[[ -z $CUSTOM_ALGO ]] && echo -e "${YELLOW}CUSTOM_ALGO is empty${NOCOLOR}" && return 1

all_pools=($CUSTOM_URL)

if [[ -z $WORKER_NAME ]]; then
	CUSTOM_TEMPLATE=$(sed "s/.%WORKER_NAME%//g" <<< "$CUSTOM_TEMPLATE")
	else
	CUSTOM_TEMPLATE=$(sed "s/%WORKER_NAME%/$WORKER_NAME/g" <<< "$CUSTOM_TEMPLATE")
fi

conf=$(jq -n "{\"_note\": null,\"pools\":[],\"api-bind\": \"0.0.0.0:4068\",\"algo\": \"$CUSTOM_ALGO\"}")

for (( i=0; i < ${#all_pools[*]}; i++ ))
do
	pool=${all_pools[$i]}
	conf=$(echo $conf | jq ".pools[.pools | length] |= .+ {\"user\":\"$CUSTOM_TEMPLATE\",\"url\":\"$pool\",\"pass\":\"x\"}")
done


[[ -z $CUSTOM_CONFIG_FILENAME ]] && echo -e "${RED}No CUSTOM_CONFIG_FILENAME is set${NOCOLOR}" && return 1
echo $conf | jq . > $CUSTOM_CONFIG_FILENAME
