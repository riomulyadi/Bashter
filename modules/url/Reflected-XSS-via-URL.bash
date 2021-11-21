#!/bin/bash

function discordBot(){
	MESSAGE="${1}"
	curl -v \
		-H "Authorization: OTExNDkxNDU5NjI1MTQ0MzYw.YZiKkg.Bu3zNik2z26YgEd3LcNv2x1PJPU" \
		-H "User-Agent: BashterXSS (http://github.com/riomulyadi/Bashter, v0.1)" \
		-H "Content-Type: application/json" \
		-X POST \
		-d '{"content": "'"${MESSAGE}"'"}' \
		https://discord.com/api/webhooks/911501193715523595/sIepWYxHROpq_hbwhNW3eW8nDWskt2zc0aDLO4AKo2pbDlzmd34uO5KEmrPdNuBH-hWx
}

function ReflectedXSSviaUrl() {
	URL="${1}"
	SOURCECODE="${2}"
	HOME_DIR="$(cd "$(dirname "$0")/../../" ; pwd -P)"
	LOGFILE="${HOME_DIR}/scan-logs/$(echo "${URL}" | sed 's|/| |g' | awk '{print $2}')-issues.log"

	if [[ $(echo "${URL}" | grep '?' | grep '&') ]]
	then
		TESTATTACK=$(echo "${URL}" | sed 's/=\([a-zA-Z0-9]*\)$/=\1Bashter%22XSS/g' | sed 's/=\([a-zA-Z0-9]*\)\&/=\1Bashter%22XSS\&/g')
		if [[ ! -z $(curl -skL --connect-timeout 5 --max-time 5 -A "Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:59.0) Gecko/20100101 Firefox/59.0" "${TESTATTACK}" | grep 'Bashter"XSS') ]]
		then
			RESULT="FATAL: XSS! Potential: Reflecting XSS on URL "${TESTATTACK}""
			discordBot "${RESULT}"
			echo "$(date +"[%H:%M:%S]") FATAL: XSS! Potential: Reflectings (\") on URL \"${TESTATTACK}\""
			echo "$(date +"[%H:%M:%S]") FATAL: XSS! Potential: Reflecting (\") on URL \"${TESTATTACK}\"" >> ${LOGFILE}
		fi
	else
		if [[ ! -z $(curl -skL --connect-timeout 5 --max-time 5 -A "Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:59.0) Gecko/20100101 Firefox/59.0" "${URL}/Bashter%22XSS" | grep 'Bashter"XSS') ]]
		then
			RESULT="FATAL: XSS! Potential: Reflecting XSS on URL "${URL}"/Bashter%22XSS"
			discordBot "${RESULT}"
			echo "$(date +"[%H:%M:%S]") FATAL: XSS! Potential: Reflecting (\") on URL \"${URL}/Bashter%22XSS\""
			echo "$(date +"[%H:%M:%S]") FATAL: XSS! Potential: Reflecting (\") on URL \"${URL}/Bashter%22XSS\"" >> ${LOGFILE}
		fi
	fi
}

ReflectedXSSviaUrl "${1}" "${2}"
