# rclone GDSA uploader
A script to monitor a directory and its subdirectories for objects to be uploaded to your google gdrive using rclone. The script uses service accounts in a round robin approach.

## Installation
Clone the repository using
```
git clone https://github.com/inkarnation/rclone_gdsa_uploader
mkdir rclone_gdsa_uploader/service_accounts
chmod +x rclone_gdsa_uploader/uploader.sh
```

Place your service account configurations in `rclone_gdsa_uploader/service_accounts` or in the directory configured in `sa_dir`. The service accounts need to be structured in incrementing `.json` files (e.g. `1.json`, `2.json`, ...).

You might configure a cronjob with e.g. `crontab -e` like (Using flock to prevent parallel executions):

`*/15 * * * * /usr/bin/flock -n /tmp/rclone.lockfile /root/rclone_gdsa_uploader/uploader.sh`

Modify `/root/rclone_gdsa_uploader/uploader.sh` to match the path to your cloned repository.

Make sure to adjust the variables in the script according your needs:

| Variable          | Description                                           | Example                          |
|-------------------|-------------------------------------------------------|----------------------------------|
| sa_dir            | Directory containing the service accounts             | $(pwd)"/service_accounts"        |
| current_gdsa_file | File to keep track of the service account to use next | $(pwd)"/current_gdsa"            |
| local_dir         | Directory containing the objects to upload            | /mnt/gmedia-local                |
| rclone_config     | Path to your rclone config file                       | /root/.config/rclone/rclone.conf |
| log_file          | Log file path                                         | /opt/rclone/logs/upload.log      |
