#!/bin/sh

# Setze sichere Shell-Optionen:
# -e: bricht das Script sofort ab, falls ein Fehler auftritt
# -u: Fehler bei unset Variablen vermeiden
# -x: jeden ausgeführten Befehl ausgeben (hilfreich für Debugging)
set -eux

#
export HOME=/config

#
/opt/MediathekView/MediathekView -m $HOME