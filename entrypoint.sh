#!/bin/bash

set -ex

mkdir -p ~/.vnc
echo "${ADMIN_PASSWORD}" | tigervncpasswd -f > ~/.vnc/passwd
# this code is stupid
chmod 700 ~/.vnc/passwd

export FILENAME=${FILENAME:-/data/twitch.ansi}

echo "twenty-foot-pablo" > ${FILENAME}

# start the pablo draw process in the background under screen
# it needs stdin but if any key is pressed it dies
tmux new -d "mono PabloDraw.Console.exe \
    --server \
    --password=${EDITOR_PASSWORD} \
    --oppassword=${ADMIN_PASSWORD} \
    --userlevel=editor \
    --backup \
    --autosave=300 \
    --file ${FILENAME} | tee /tmp/pablo.log"

# wait for the server to come up
while ! nc -u -z -v localhost 14400; do
    sleep 1;
done

# start pablo draw on display :1
vncserver :1 -geometry ${WIDTH}x${HEIGHT} -xstartup ./pablo.sh
websockify --web /usr/share/novnc 5801 localhost:5901 -D

# use xdo to automate pablo UI
# TODO: PR pablo draw to take CLI arguments
DISPLAY=:1 xdotool search --name pablodraw \
    windowmove %2 0 0 \
    windowsize %2 ${WIDTH} ${HEIGHT} \
    key --window %2 "ctrl+alt+c" \
    type --window %2 "pablo"
DISPLAY=:1 xdotool search --name pablodraw \
    key --window %2 "Tab" \
    type --window %2 "localhost"
DISPLAY=:1 xdotool search --name pablodraw \
    key --window %2 "Tab" "Tab"\
    type --window %2 "${EDITOR_PASSWORD}"
DISPLAY=:1 xdotool search --name pablodraw \
    key --window %2 "Return"

# run OBS on display 2
vncserver :2 -geometry ${WIDTH}x${HEIGHT} -xstartup ./obs.sh
websockify --web /usr/share/novnc 5802 localhost:5902 -D
DISPLAY=:2 xdotool search --name obs \
    windowmove 0 0 \
    windowsize ${WIDTH} ${HEIGHT}

# bring the server back foreground, when it exits so do we
tmux set -g status off
tmux attach || tail -f /tmp/pablo.log
