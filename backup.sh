#!/bin/bash

USAGE='docker run \\\n\t--rm\\\n\t-v /folder/to/backup:/s3 \\\n\t-e "AWS_BUCKET=my-bucket" \\\n\t-e "S3_BACKUP_FILENAME=today" \\\n\t-e "AWS_ACCESS_KEY=XXXXXXXXXXXXXXXXX" \\\n\t-e "AWS_SECRET_KEY=XXXXXXXXXXXXXXXXX" \\\n\tbradleyboy/s3archive'

function err {
	echo -e "$1.\n\nUsage:\t$USAGE\n\nResult: The host's /folder/to/backup will be stored in the my-bucket S3 bucket as today.tar.gz\n"
	exit
}

echo ""

if [[ ! -d /s3 ]]; then
	err "No directory mounted for backup"
	exit
fi

if [[ $S3_BACKUP_FILENAME = "" ]]; then
	err "Backup filename not provided"
	exit
fi

if [[ $AWS_ACCESS_KEY = "" ]]; then
	err "AWS Access Key not provided"
	exit
fi

if [[ $AWS_SECRET_KEY = "" ]]; then
	err "AWS Secret Key not provided"
	exit
fi

if [[ $AWS_BUCKET = "" ]]; then
	err "AWS bucket not provided"
	exit
fi

S3_BACKUP_FILENAME=${S3_BACKUP_FILENAME/.tar.gz/}
BACKUP_FILE=$(basename $S3_BACKUP_FILENAME)

BACKUP_FILE=${BACKUP_FILE/.tar.gz/}

echo ">> Archiving to $BACKUP_FILE.tar.gz..."
tar -zcf /$BACKUP_FILE.tar.gz -C / s3

DIRNAME=$(dirname $S3_BACKUP_FILENAME)

S3_PATH=$AWS_BUCKET

if [[ $DIRNAME != "." ]]; then
	S3_PATH="$S3_PATH$S3_BACKUP_FILENAME.tar.gz"
fi;

echo -n ">> Sending to s3://$S3_PATH..."

s3cmd \
	--access_key $AWS_ACCESS_KEY \
	--secret_key $AWS_SECRET_KEY \
	put /$BACKUP_FILE.tar.gz s3://$S3_PATH

echo ""
