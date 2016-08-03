SHELL=/bin/bash
PATH=/home/pi/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/local/games:/usr/games

function error_exit
{
        echo "$1" 1>&2
        exit 1
}

echo do-loop-new.sh Started

cd /home/pi/openaps-lp

logger -t do-loop-start "OPENAPS-LP LOOP START"

echo do-loop-new.sh Testing git corruption ...

if oref0 fix-git-corruption 2>&1 | logger -t do-loop-start; then

        until mm-stick warmup
        do
                sleep 5
        done

        (openaps preflight || error_exit "LOOP FAIL") 2>&1 | logger -t do-loop-preflight
        (openaps gather-clean-data || error_exit "LOOP FAIL") 2>&1 | logger -t do-loop-gather
        (openaps do-oref0 || error_exit "LOOP FAIL") 2>&1 | logger -t do-loop-predict
        (openaps enact-oref0 || error_exit "LOOP FAIL") 2>&1 | logger -t do-loop-enact
        ((openaps get-basal-status && openaps monitor-pump-history && openaps report-nightscout) || error_exit "LOOP FAIL") 2>&1 | logger -t do-loop-status

fi
