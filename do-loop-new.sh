#!/bin/bash
SHELL=/bin/bash
PATH=/home/pi/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/local/games:/usr/games

START=`date +%s`

function error_exit
{
	END=`date +%s`
	ELAPSED=$(( $END - $START ))

	echo "$1" 1>&2
	logger -t do-loop "$1"
	logger -t do-loop-end "OPENAPS-LP LOOP ERROR ($ELAPSED seconds)"

        exit 1
}

cd /home/pi/openaps-lp

logger -t do-loop-start "OPENAPS-LP LOOP START"

if oref0 fix-git-corruption 2>&1 > >(logger -t do-loop-start); then

        until openaps preflight 2>&1 > >(logger -t do-loop-start);
        do
                sleep 10
		logger -t do-loop-start "Waiting (openaps preflight failed)"
        done

        { openaps gather-clean-data || error_exit "LOOP FAIL"; } 2>&1 > >(logger -t do-loop-gather)
        { openaps do-oref0 || error_exit "LOOP FAIL"; } 2>&1 > >(logger -t do-loop-predict)
        { openaps enact-oref0 || error_exit "LOOP FAIL"; } 2>&1 > >(logger -t do-loop-enact)
	{ openaps report-nightscout || error_exit "LOOP FAIL"; } 2>&1 > >(logger -t do-loop-status)
fi

END=`date +%s`
ELAPSED=$(( $END - $START ))

logger -t do-loop-end "OPENAPS-LP LOOP END ($ELAPSED seconds)"
