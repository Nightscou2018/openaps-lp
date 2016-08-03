SHELL=/bin/bash
PATH=/home/pi/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/local/games:/usr/games

function error_exit
{
        echo "$1" 1>&2
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

        openaps gather-clean-data || error_exit "LOOP FAIL" 2>&1 > >(logger -t do-loop-gather)
        openaps do-oref0 || error_exit "LOOP FAIL" 2>&1 | logger -t do-loop-predict
        openaps enact-oref0 || error_exit "LOOP FAIL" 2>&1 | logger -t do-loop-enact
        openaps get-basal-status || error_exit "LOOP FAIL" 2>&1 | logger -t do-loop-status
	openaps monitor-pump-history|| error_exit "LOOP FAIL" 2>&1 | logger -t do-loop-status
	openaps report-nightscout || error_exit "LOOP FAIL" 2>&1 | logger -t do-loop-status
fi
