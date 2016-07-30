SHELL=/bin/bash
PATH=/home/pi/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/local/games:/usr/games

(cd /home/pi && rm -rf openaps-lp_corrupt && mv openaps-lp openaps-lp_corrupt && git clone https://github.com/bfaloona/openaps-lp.git && cp openaps-lp_corrupt/pump.ini openaps-lp/) 2>&1 | logger -t git-reclone
