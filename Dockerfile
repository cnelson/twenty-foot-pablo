FROM ubuntu:bionic

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
    && apt-get install -yq \
        ca-certificates \
        gnupg \
        software-properties-common \
    && apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF \
    && apt-add-repository "deb https://download.mono-project.com/repo/ubuntu stable-bionic main" \
    && add-apt-repository ppa:obsproject/obs-studio \
	&& apt-get update \
	&& apt-get install -yq \
		mono-devel \
        x11-utils \
        gtk-sharp2 \
        tigervnc-standalone-server \
        tigervnc-xorg-extension \
        novnc \
        unzip \
        curl \
        ffmpeg \
        obs-studio \
        xdotool \
        tmux \
        netcat \
        gettext \
    && rm -rf /var/lib/apt/lists/*

RUN useradd -ms /bin/bash pablo
WORKDIR /home/pablo

RUN curl -L -o /tmp/pablodraw.zip http://download.picoe.ca/pablodraw/3.2/PabloDraw-3.2.1.zip \
    && unzip -j /tmp/pablodraw.zip \
    && curl -L -o /tmp/pablodrawconsole.zip http://download.picoe.ca/pablodraw/3.2/PabloDraw.Console-3.2.1.zip \
    && unzip -j /tmp/pablodrawconsole.zip \
    && rm /tmp/*.zip

ADD pablo.sh .
ADD obs.sh .
ADD entrypoint.sh .
RUN chmod 755 *.sh

ADD obs/global.ini .config/obs-studio/global.ini
ADD obs/scene.json .config/obs-studio/basic/scenes/Untitled.json
ADD obs/twitch.ini .config/obs-studio/basic/profiles/Twitch/basic.ini
ADD obs/twitch.json service_template.json

VOLUME /data
EXPOSE 5801
EXPOSE 5802
EXPOSE 14400

RUN chown -R pablo:pablo /home/pablo
USER pablo

ENV WIDTH=1280
ENV HEIGHT=720
ENTRYPOINT ["/home/pablo/entrypoint.sh"]

