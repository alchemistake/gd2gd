# Docker Google Drive to Google Drive Restic Backup
Fiyu~~ that was mouthful.

If you are paranoid like me, and want to backup your GD to another GD using Restic.
You are in the right place.
I lost some precious data due to some shady GD tools. So I created this tool to make it never happen again.

# Credits
I stole some parts from [@maltokyo](https://github.com/maltokyo) and [his repository](https://github.com/maltokyo/docker-google-drive-ocamlfuse)
and I stole some parts from [Jakob Kofad's blog post](https://jakobkofod.com/automated-restic-backups-google-drive/) and I wrote some stuff.

# How To
1. [Follow this and generate 2 verification codes for from GD and to GD](https://github.com/astrada/google-drive-ocamlfuse/wiki/Headless-Usage-&-Authorization)
2. `docker build -t gd2gd .`
3. Run following command
    ```shell script
    docker run \
      -v /$LOCATION_TO_HOLD_AUTH_TOKENS:/root/.gdfuse \
      --env CLIENT_ID=$CLIENT_ID \
      --env CLIENT_SECRET=$CLIENT_SECRET \
      -t -i --cap-add mknod --cap-add sys_admin --device /dev/fuse --security-opt apparmor:unconfined \
      gd2gd
    ```
4. This will ask you to authenticate, then backup
5. Put the command on a cron job, will not ask for authentication on second time.