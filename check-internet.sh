#!/bin/bash

FileName=${0##*/}
FileNameWithoutExtension=${FileName%.*}
LogFile="$FileNameWithoutExtension.log"

if ! [[ -f "$LogFile" ]]; then
  touch $LogFile
fi

log() {
  echo "$1" >> $LogFile 
}

if nc -zw1 google.com 443; then
  log "internet ON"
else
  log "internet OFF :("

  shouldTurnOff=true

  for i in $(seq 1 10); do
    sleep 1
    log "Checking again $i"

    if nc -zw1 google.com 443; then
      log "internet ON"
      shouldTurnOff=false
      break
    else
      shouldTurnOff=true
    fi
  done
    
  if [[ $shouldTurnOff == true ]]; then
    log "Turning off Umbrel"
    /home/umbrel/umbrel/scripts/stop | log
    log "Turning off Rasp"
  fi
fi
