#!/bin/sh
DATE=$(date +%Y-%m-%d-%H-%M)
dump=$(mongodump -u $MONGODB_USER -p $MONGODB_PASSWORD --host $MONGODB_HOST --gzip --out $BACKUP_DATA_DIR/dump-${DATE})

if [ $? -ne 0 ]; then
    echo "mongodump not successful: ${DATE}"
    exit 1
fi

printf '%s' "$dump"

if [ $? -eq 0 ]; then
    echo "backup created: ${DATE}"
else
    echo "backup not successful: ${DATE}"
    exit 1
fi

# Delete old files
old_dumps=$(ls -1 $BACKUP_DATA_DIR/dump* | head -n -$BACKUP_KEEP)
if [ "$old_dumps" ]; then
    echo "Deleting: $old_dumps"
    rm -r $old_dumps
fi
