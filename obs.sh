!#/bin/bash

cat ~/service_template.json | envsubst > ~/.config/obs-studio/basic/profiles/Twitch/service.json

exec obs \
	--startstreaming \
	--profile Twitch \
	--scene Default
