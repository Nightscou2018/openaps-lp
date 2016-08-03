SHELL=/bin/bash
PATH=/home/pi/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/local/games:/usr/games

echo do-loop-new.sh Started

cd /home/pi/openaps-lp

logger -t do-loop-start "OPENAPS-LP LOOP START"

echo do-loop-new.sh Testing git corruption ...

if oref0 fix-git-corruption; then

        until mm-stick warmup
        do
                sleep 5
        done

        (openaps preflight || exit 99) 2>&1 | logger -t do-loop-preflight
        openaps gather-clean-data 2>&1 | logger -t do-loop-gather
        openaps do-oref0 2>&1 | logger -t do-loop-predict
        openaps enact-oref0 2>&1 | logger -t do-loop-enact
        (openaps get-basal-status && openaps monitor-pump-history && openaps report-nightscout) 2>&1 | logger -t do-loop-status

fi
