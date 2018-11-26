# Twenty Foot Pablo

Run a [PabloDraw](https://github.com/cwensley/pablodraw) server and [OBS Studio](https://github.com/obsproject/obs-studio) configured to stream it to twitch in a container.

## To use:

```bash

docker build -t 20ftpablo .

docker run \
	-v /some/path/to/save/ansi:/data \
	-e STREAM_KEY=your-twitch-stream-key \
	-e ADMIN_PASSWORD=the-vnc-and-pablo-op-password \
	-e EDITOR_PASSWORD=the-pablo-editor-password \
	-p 5801:5801 \
	-p 5802:5802 \
	-p 14400:14400 \
	20ftpablo
```

Ports:

- Port 5801 [noVNC](https://github.com/novnc/noVNC) connected to PabloDraw.
- Port 5802 noVNC connected to OBS Studio.
- Port 14400 PabloDraw server port.
