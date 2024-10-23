#! /bin/env bash

# This script is responsible for incrementally backing up my computer to an external 
# hard drive. It uses rsync to handle these backups in a somewhat similar way to 
# Apple's "Time Machine" software - by creating hard links for unchanged folders on the 
# destination. So rsync can find previous backups, a 'latest' soft link is used to point
#  to the most recent backup.

# A drawback that I have found from this approach is that rsync uses the directory
# structure to find previous versions of a file - so if a file has been moved, rsync
# will copy the file again, instead of creating a hard link. 


BACKUP_NAME="$(date '+%Y%m%d-%H%M%S - %H:%M, %a %d %b, %Y')"

BACKUP_FOLDER=$1

if [ ! -d "$BACKUP_FOLDER" ]; then
    echo "ERROR: Backup directory does not exist!"
    exit -1
fi




SOURCES=('/home/moondog/Archive' '/home/moondog/Binaries' '/home/moondog/Documents' 
         '/home/moondog/Pictures' '/home/moondog/Projects' '/home/moondog/Scripts' 
         '/home/moondog/Sync' 
         
         '/home/moondog/.bones' 
         
         '/home/moondog/.local/share/PrismReal' '/home/moondog/.local/share/Terraria'
         
         '/home/moondog/.config/eww' '/home/moondog/.config/qtile' 
         '/home/moondog/.config/picom' 
)


OPTIONS="--archive --partial --progress --human-readable --delete"


DESTINATION="$BACKUP_FOLDER/$BACKUP_NAME"



underline=$(tput smul)
normalline=$(tput rmul)
red=$(tput setaf 1)
reset_colour=$(tput setaf 9)

mkdir "$DESTINATION"

for ((i = 0; i < ${#SOURCES[@]}; i++)); do
    source="${SOURCES[$i]}"
    echo "Backing up ${underline}$(basename $source)${normalline}"

    if ! rsync $OPTIONS --link-dest "$BACKUP_FOLDER/.latest" "$source" "$DESTINATION"; then
        echo "${red}ERROR: Something went wrong backing up ${underline}$(basename $source)${normalline}${reset_colour}"
        exit -1
    fi


done


rm "$BACKUP_FOLDER/.latest" 
ln -s "$DESTINATION" "$BACKUP_FOLDER/.latest"