# ----------------------------------------
# Stage 1: Build / Download MediathekView
# ----------------------------------------
FROM debian:12-slim AS builder

# Setze Arbeitsverzeichnis für temporäre Dateien
WORKDIR /tmp

# ----------------------------------------
# Kopiere nur die requirements.txt
# Diese enthält die gewünschte MediathekView-Version
# ----------------------------------------
COPY /mediathekview/docker/requirements.txt ./

# ----------------------------------------
# Installiere wget und ca-certificates für HTTPS-Download
# --no-install-recommends hält das Image klein
# ----------------------------------------
RUN apt-get update \
 && apt-get install -y --no-install-recommends \
    wget \
    ca-certificates \
 && rm -rf /var/lib/apt/lists/*

# ----------------------------------------
# Download und Entpacken von MediathekView
# Die Version wird direkt aus requirements.txt gelesen
# ----------------------------------------
RUN mkdir -p /opt/MediathekView \
 && wget -q "https://download.mediathekview.de/stabil/MediathekView-$(cat requirements.txt)-linux.tar.gz" -O /tmp/MediathekView.tar.gz \
 && tar xf /tmp/MediathekView.tar.gz -C /opt \
 && rm /tmp/MediathekView.tar.gz


# ----------------------------------------
# Stage 2: Runtime
# ----------------------------------------
FROM jlesage/baseimage-gui:debian-12-v4.11.2

# ----------------------------------------
# Metadata / Labels
# ----------------------------------------
LABEL maintainer="Daniel Wydler"
LABEL org.opencontainers.image.authors="Daniel Wydler"
LABEL org.opencontainers.image.description="MediathekView ist ein Programm, das die Online-Mediatheken verschiedener öffentlich-rechtlicher TV-Sender durchsuchen und die vorhandenen Sendungen auflisten kann."
LABEL org.opencontainers.image.documentation="https://github.com/dwydler/MediathekView-Docker/blob/master/README.md"
LABEL org.opencontainers.image.source="https://github.com/dwydler/MediathekView-Docker"
LABEL org.opencontainers.image.title="wydler/mediathekview"
LABEL org.opencontainers.image.url="https://hub.docker.com/r/wydler/mediathekview"

# ----------------------------------------
# Setze Umgebungsvariablen
# LC_ALL/Language für UTF-8 Support
# JAVAFX_TMP_DIR für JavaFX Cache
# TERM und S6_KILL_GRACETIME für Baseimage-GUI
# ----------------------------------------
ENV APP_NAME="Mediathekview" \
    DOCKER_IMAGE_VERSION="1.0" \
    USER_ID=0 \
    GROUP_ID=0 \
    TERM=xterm \
    S6_KILL_GRACETIME=8000 \
    JAVAFX_TMP_DIR=/tmp/openjfx/cache \
    LC_ALL=en_US.UTF-8 \
    LANGUAGE=en_US.UTF-8 \
    LANG=en_US.UTF-8

# ----------------------------------------
# Kopiere die entpackten MediathekView-Dateien aus der Build-Stage
# ----------------------------------------
COPY --from=builder /opt/MediathekView /opt/MediathekView

# ----------------------------------------
# Installiere nur die Runtime-Pakete
# VLC, FFmpeg, flvstreamer und procps werden für die App benötigt
# ----------------------------------------
RUN apt-get update \
 && apt-get install -y --no-install-recommends \
    vlc \
    ffmpeg \
    flvstreamer \
    procps \
    libxtst6 \
 && rm -rf /var/lib/apt/lists/*

# ----------------------------------------
# GUI-Konfiguration und Startskripte
# ----------------------------------------
COPY mediathekview/docker/main-window-selection.xml /etc/openbox/main-window-selection.xml
COPY mediathekview/docker/90-mediathekview.sh /etc/cont-init.d/90-mediathekview.sh
COPY mediathekview/docker/startapp.sh /startapp.sh
RUN chmod 755 /etc/cont-init.d/90-mediathekview.sh /startapp.sh

# ----------------------------------------
# Definierte Mountpoints für persistente Daten
# /config: Konfiguration
# /output: heruntergeladene Medien
# ----------------------------------------
VOLUME ["/config", "/output"]