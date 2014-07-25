Docker s3archive
================

Simple Docker image that archives (tar + gzip) a mounted volume and sends it to the specified S3 bucket.

# Usage

```
docker run \
	--rm \
	-v /folder/to/backup:/s3 \
	-e "AWS_BUCKET=my-bucket" \
	-e "S3_BACKUP_FILENAME=today" \
	-e "AWS_ACCESS_KEY=XXXXXXXXXXXXXXXXX" \
	-e "AWS_SECRET_KEY=XXXXXXXXXXXXXXXXX" \
	bradleyboy/s3archive
```

The above command will create a tar.gz of the `/folder/to/backup` directory on your host machine. It will then upload it to the `my-bucket` S3 bucket with the filename of `today.tar.gz`. You can also add a prefix to the filename if you want to store it it inside a folder on the bucket:

```
DATE=`date +%Y-%m-%d`
docker run \
	--rm \
	-v /folder/to/backup:/s3 \
	-e "AWS_BUCKET=my-bucket" \
	-e "S3_BACKUP_FILENAME=/database-backups/$DATE" \
	-e "AWS_ACCESS_KEY=XXXXXXXXXXXXXXXXX" \
	-e "AWS_SECRET_KEY=XXXXXXXXXXXXXXXXX" \
	bradleyboy/s3archive
```
