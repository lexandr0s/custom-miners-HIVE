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

json=$(jq -n "{\"_note\": null,\"api-bind\": \"$WEB_PORT:$WEB_HOST\",\"algo\": \"$CUSTOM_ALGO\",\"pools\":[]}")

for (( i=0; i < ${#all_pools[*]}; i++ ))
do
	pool=${all_pools[$i]}
	json=$(echo $json | jq ".pools[.pools | length] |= .+ {\"user\":\"$CUSTOM_TEMPLATE\",\"url\":\"$pool\",\"pass\":\"x\"}")
done

echo $json | jq . > $CUSTOM_JSON_FILENAME


conf="-c $CUSTOM_JSON_FILENAME $CUSTOM_USER_CONFIG"

[[ -z $CUSTOM_CONFIG_FILENAME ]] && echo -e "${RED}No CUSTOM_CONFIG_FILENAME is set${NOCOLOR}" && return 1
echo "$conf" > $CUSTOM_CONFIG_FILENAME

