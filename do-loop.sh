SHELL=/bin/bash
PATH=/home/pi/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/local/games:/usr/games

(cd /home/pi/openaps-lp && openaps do-everything) 2>&1 | logger -t do-loop
