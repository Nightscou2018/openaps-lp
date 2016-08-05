SHELL=/bin/bash
PATH=/home/pi/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/local/games:/usr/games

logger -t git-reclone "GIT RECLONE START"

cd /home/pi
rm -rf openaps-lp_corrput/openaps-lp_recent | logger -t git-reclone
mkdir openaps-lp_corrput/openaps-lp_recent |logger -t git-reclone
mv openaps-lp openaps-lp_corrupt/openaps-lp_recent  | logger -t git-reclone
git clone https://github.com/bfaloona/openaps-lp.git | logger -t git-reclone
cp openaps-lp-assets/pump.ini openaps-lp/ | logger -t git-reclone
cd openaps-lp

git status > /dev/null
if [ $? -eq 0 ]
	logger -t git-reclone "GIT RECLONE END"
then
	logger -t git-reclone "GIT RECLONE FAILURE"
	exit 1
fi
