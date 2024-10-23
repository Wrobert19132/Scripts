#! /bin/env bash


# Provides an *incredibly* simple UI for my incremental backup script.


BACKUP_LOCATION="/run/media/moondog/496b652c-cd74-4b49-90ff-30b78dbe7f08"
SCRIPT_LOCATION="Scripts/.script-repo/backup/backup.sh"


red='\033[0;31m' 
green='\033[0;32m'
colour_reset='\033[0m'


figlet -f /usr/share/figlet/fonts/big.flf "Manual  Backup"


echo -n "Backup Location: "
if [ ! -d "$BACKUP_LOCATION" ]; then
    echo -en "${red}OFFLINE"
else
    echo -en "${green}ONLINE"
fi

echo -e ${colour_reset}


# If an encrypted mount is mounted, warn the user - we don't want to back up
# decrypted files that are supposed to be encrypted!

DECRYPTED_MOUNTS=$(findmnt -l | grep ecryptfs | awk '{print $1}')


echo -n "Mounted Encrypted Volumes: "
if [ -n "$DECRYPTED_MOUNTS" ]; then 
    echo -en "${red}YES"
else
    echo -en "${green}No"
fi
echo -e ${colour_reset}

echo ""

if [ -n "$DECRYPTED_MOUNTS" ]; then 
    echo -e "${red}WARNING: The following encrypted filesystems are currently mounted:"
    echo -e "${DECRYPTED_MOUNTS}${colour_reset}"
    echo ""
fi


LAST_BACKUP=$(ls $BACKUP_LOCATION | tail -n 1 | awk '{print $3 " " $4 " " $5 " " $6 " " $7;}')

if [ -z "$LAST_BACKUP" ]; then 
    echo -e "${red}WARNING: No known previous backups${colour_reset}"
else
    echo The last backup was on $LAST_BACKUP.
fi

echo ""
echo -en "Press return to start the backup procedure."
read -p ""

echo "Starting backup..."
echo ""

if $SCRIPT_LOCATION $BACKUP_LOCATION; then
    echo ""
    read -p "Done! Execution took $SECONDS seconds. Press return to quit."
else 
    echo ""
    echo -en "${red}Something went wrong. Press return to quit.${colour_reset}"
    read -p ""
fi
    
