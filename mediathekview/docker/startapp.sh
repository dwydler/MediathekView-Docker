#!/bin/sh

# Setze sichere Shell-Optionen:
# -e: bricht das Script sofort ab, falls ein Fehler auftritt
# -u: Fehler bei unset Variablen vermeiden
# -x: jeden ausgeführten Befehl ausgeben (hilfreich für Debugging)
set -eux

# Setze HOME auf das persistente Konfigurationsverzeichnis im Container
export HOME=/config

# Starte MediathekView und nutze das HOME-Verzeichnis für Konfiguration
/opt/MediathekView/MediathekView -m $HOME