#!/bin/bash

# Send errors to log file
exec 1> /dev/null
exec 2> ./backup.log

BACKDIR=$1
COMPRESSION=$2
OUTFILE=$3
PASSWORD=$4

if [ $COMPRESSION == "none" ]; then
	tar -cf temp $BACKDIR
else
	tar --use-compress-program=$COMPRESSION -cf temp $BACKDIR
fi

if [ -z "$PASSWORD" ]; then
    # Use dummy password if non provided
    openssl aes-256-cbc -salt -in temp -out $OUTFILE -k admin123
else
    # Encrypt file
    openssl aes-256-cbc -salt -in temp -out $OUTFILE -k $PASSWORD
fi

# Remove temporary file
rm temp
