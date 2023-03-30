#!/bin/bash

# Default configuration
# This way a configured cron-job
SCRIPT_NAME="backupNG.sh"
BACKUP_FILE="$(date "+%F_%H-%M-%S")-localBackup.tar.gz"
BACKUP_RETENTION="7"
LOGFILE="./localBackup.log"

# -------------------- #

function log() {
    echo $(date "+%F-%H:%M:%S") [$(basename $0)] $* >> $LOGFILE
    echo $(date "+%F-%H:%M:%S") [$(basename $0)] $*
}

function printHelp() {
  echo -e "
    Usage: localBackup [options] <parameter>
    Create, control and restore to backup.
    
    This is a command line utility for backup-script, a
    service that manages data on linux systems.
    
    Options:
      -h, --help        Displays help on commandline options
      -b, --backup      Start a backup
      -l, --list        List available backups
      -r, --restore     Restore a backup
      -n; --name        Backup name
      -s, --source      Set source
      -d, --destination Set destination
    "
}

if pgrep $SCRIPT_NAME | grep -qv $$
then
    log "ERROR: $SCRIPT_NAME is already running, exiting!"
    exit 1
fi

function runBackup() {
  log "INFO: Start to backup $BACKUP_SRC_DIR"
  tar -czf $DEST_DIR/$BACKUP_FILE $SRC_DIR > /dev/null
  if [ "$?" -eq "0" ]
  then
      log "INFO: runBackup successful"
  else 
      log "ERROR: runBackup failed"
  fi
}

function restoreBackup() {
  log "INFO: Start restoreBackup"
  if [ -d "$DEST_DIR" ]; then
    log "INFO: restore backup into $DEST_DIR"
    tar --same-owner -xzf $RESTORE_NAME --directory $DEST_DIR
  else
    log "INFO: restore backup into original location"
    tar --same-owner -xzf $RESTORE_NAME -C /
  fi
  if [ "$?" -eq "0" ]
  then
      log "INFO: restoreBackup successful"
  else 
      log "ERROR: restoreBackup failed"
  fi
  
}

function listBackup() {
  log "INFO: Start listBackup"
  find ${SRC_DIR}/????-??-??_*localBackup*.tar.gz 2> /dev/null
}

function cleanBackup() {
  log "INFO: searching for backups older than $BACKUP_RETENTION days"
  find ${DEST_DIR}/????-??-??_*localBackup*.tar.gz -mtime +$BACKUP_RETENTION 2> /dev/null >> $LOGFILE
  log "INFO: starting remove old backups"
  find ${DEST_DIR}/????-??-??_*localBackup*.tar.gz -mtime +$BACKUP_RETENTION -exec rm -f {} \; 2> /dev/null
  if [ "$?" -eq "0" ]
  then
      log "INFO: cleanBackup successful"
  else 
      log "ERROR: cleanBackup failed"
  fi
}

# -------------------- #

while [[ $# -gt 0 ]]
do
  case "$1" in
    -h|--help)
      printHelp
      ;;
    -b|--backup)
      while true
      do
        if [ -d "$SRC_DIR" ]; then
          log "INFO: create backup of $SRC_DIR"
          break
        else
          log "WARN: invalid source folder" 
          read -p "Enter the source folder:" SRC_DIR
        fi
        if [ -d "$DEST_DIR" ]; then
          log "INFO: store backup to $DEST_DIR"
          break
        else
          log "WARN: invalid destination folder"
          read -p "Enter the destination folder:" DEST_DIR
        fi
      done
      runBackup
      ;;
    -l|--list)
      while true
      do
        if [ -d "$SRC_DIR" ]; then
          log "INFO: searching for backups at $SRC_DIR"
          break
        else
          log "WARN: invalid source folder"
          read -p "Enter the source folder:" SRC_DIR
        fi
      done
      listBackup
      ;;
    -r|--restore)
      log "INFO: starting restoring"
      while true
      do
        if [ -f "$RESTORE_NAME" ]; then
          log "INFO: restore backup with name $RESTORE_NAME"
          break
        else
          log "WARN: invalid file name"
          read -p "Enter the backup name which you want to restore:" RESTORE_NAME
        fi
      done
      restoreBackup
      ;;
    -n|--name)
      shift
      RESTORE_NAME="$1"
      log "INFO: parameter name set to $RESTORE_NAME"
      ;;
    -s|--source)
      shift
      SRC_DIR="$1"
      log "INFO: parameter source set to $SRC_DIR"
      ;;
    -d|--destination)
      shift
      DEST_DIR="$1"
      log "INFO: parameter destination set to $DEST_DIR"
      ;;
    *)
        echo "Unknown option: $1"
        exit 1
        ;;
  esac
  shift
done