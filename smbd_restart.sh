#!/bin/sh
touch /tmp/000init-start

# Wait for all services to load
i=0
while [ $i -le 20 ]; do
   success_start_service=`nvram get success_start_service`
   if [ "$success_start_service" == "1" ]; then
       break
   fi
   i=$(($i+1))
   echo "autorun APP: wait $i seconds...";
   sleep 1
done

# Kill Samba service, replace conf file with custom, and restart
for pid in `ps -w | grep smbd | grep -v grep | awk '{print $1}'`
do
   echo "killing $pid"
   logger -t "smbd_restart.sh" "killing $pid"
   kill $pid
done

sleep 15s

#cp /jffs/smb.conf /etc/
#chmod 444 /etc/smb.conf
smbd -D -s /etc/smb.conf && logger -t "smbd_restart.sh" "service restarted"
