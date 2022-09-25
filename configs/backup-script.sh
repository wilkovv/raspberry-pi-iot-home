#!/bin/bash

export TZ="Europe/Warsaw"
DIR_BAK="/home/$LOGNAME/backups"

echo '-------------------- Starting backup at ----------------------'
echo $(date)

if [[ ! -d $DIR_BAK ]]; then
    echo '---------------- Creating backups directory ------------------'
    echo "Backup directory: $DIR_BAK"
    mkdir -p $DIR_BAK
fi

if [[ -d $DIR_BAK/'System Volume Information' ]]; then
    echo '-------------- Deleting useless Windows folder ----------------'
    echo "Delete directory: $DIR_BAK/System Volume Information"
    rm -r "$DIR_BAK/System Volume Information"
fi

echo '-------------- Reading list of existing backups --------------'
backup_files=( $(ls $DIR_BAK | sort -rn) )
for bak_file in "${backup_files[@]}"; do
    echo "> $bak_file"
done

echo '-------------------- Shutdown containers ---------------------'
/usr/local/bin/docker-compose -f "/home/$LOGNAME/compose.yml" down

echo '---------------------- Creating backup -----------------------'
NAME_BAK="$(date +'%y_%m_%d_%H-%M-%S'-backup)"
cd "/home/$LOGNAME"
echo "$NAME_BAK"
zip -r "$DIR_BAK/$NAME_BAK.zip" docker-volumes > /dev/null

echo '--------------------- Start containers -----------------------'
/usr/local/bin/docker-compose -f "/home/$LOGNAME/compose.yml" up -d

if [[ ${#backup_files[@]} -ge 5 ]]; then
    echo '---------------------- Rotating backup -----------------------'
    echo "Deleting file ${backup_files[4]}"
    rm "$DIR_BAK/${backup_files[4]}"
fi
