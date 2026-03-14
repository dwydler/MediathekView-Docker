# ----------------------------------------
# Basis-Image
# ----------------------------------------
FROM jlesage/baseimage-gui:debian-12-v4.11.2


# ----------------------------------------
# Metadata / Labels
# ----------------------------------------
# Standardisierte Metadaten für Docker-Images (OCI-Labels)
LABEL maintainer="Daniel Wydler"
LABEL org.opencontainers.image.authors="Daniel Wydler"
LABEL org.opencontainers.image.description="MediathekView ist ein Programm, das die Online-Mediatheken verschiedener öffentlich-rechtlicher TV-Sender durchsuchen und die vorhandenen Sendungen auflisten kann."
LABEL org.opencontainers.image.documentation="https://github.com/dwydler/MediathekView-Docker/blob/master/README.md"
LABEL org.opencontainers.image.source="https://github.com/dwydler/MediathekView-Docker"
LABEL org.opencontainers.image.title="wydler/mediathekview"
LABEL org.opencontainers.image.url="https://hub.docker.com/r/wydler/mediathekview"


# ----------------------------------------
# Arbeitsverzeichnis
# ----------------------------------------
# Setzt das aktuelle Arbeitsverzeichnis für alle folgenden Befehle
WORKDIR /


# ----------------------------------------
# Umgebungsvariablen
# ----------------------------------------
# Konfiguration für die App, Locale, Terminal, S6 und JavaFX-Cache
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
# Installation von Paketen
# ----------------------------------------
# Installiert die benötigten Pakete für MediathekView und GUI
# --no-install-recommends reduziert die Image-Größe, rm löscht den apt-Cache
RUN apt-get update \
 && apt-get install -y --no-install-recommends \
    apt-utils \
    locales \
    wget \
    ca-certificates \
    procps \
    vlc \
    flvstreamer \
    ffmpeg \
 && rm -rf /var/lib/apt/lists/*

# ----------------------------------------
# Locale einrichten
# ----------------------------------------
# Notwendig, um Dateien mit Umlauten korrekt zu speichern
RUN echo en_US.UTF-8 UTF-8 > /etc/locale.gen \
    && locale-gen

# ----------------------------------------
# Kopiere die Version-/Requirements-Datei
# ----------------------------------------
# Enthält die gewünschte MediathekView-Version
COPY /mediathekview/docker/requirements.txt ./

# ----------------------------------------
# Download und Entpacken von MediathekView
# ----------------------------------------
# Lädt das stabile Linux-Archiv herunter und entpackt es in /opt
# Danach wird das temporäre Archiv gelöscht
RUN mkdir -p /opt/MediathekView \
 && wget -q "https://download.mediathekview.de/stabil/MediathekView-$(cat requirements.txt)-linux.tar.gz" -O /tmp/MediathekView.tar.gz \
 && tar xf /tmp/MediathekView.tar.gz -C /opt \
 && rm /tmp/MediathekView.tar.gz


# ----------------------------------------
# Konfiguration der GUI
# ----------------------------------------
# Maximiert nur das Hauptfenster der Anwendung
COPY mediathekview/docker/main-window-selection.xml /etc/openbox/main-window-selection.xml


# ----------------------------------------
# Init- und Startskripte
# ----------------------------------------
# S6 Init-Skript für MediathekView
COPY mediathekview/docker/90-mediathekview.sh /etc/cont-init.d/90-mediathekview.sh

# Startscript für die Anwendung
COPY mediathekview/docker/startapp.sh /startapp.sh

# Setzt die ausführbaren Rechte für die Skripte
RUN chmod 755 /etc/cont-init.d/90-mediathekview.sh /startapp.sh


# ----------------------------------------
# Definierte Mountpoints
# ----------------------------------------
# /config: Persistente Konfiguration
# /output: Speicherort für heruntergeladene Dateien
VOLUME ["/config", "/output"]