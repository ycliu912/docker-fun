#!/bin/bash

#---------------------------
url_ftp='**'
port_ftp=21
name_ftp='***'
passwd_ftp='***'
path_remote='***'
path_local=`pwd`
#---------------------------
 
if [ -n "$1" ];then
   echo "\$1 is $1"
else
   echo "\$1 can't empty."
   exit 1
fi




tag_time=`date +%F-%_H-%M-%S | tr -d " "`
path_file_untar_tmp=`echo ${1} | cut -d"." -f1 | tr -d " "`
path_file_untar="${path_file_untar_tmp}.${tag_time}"


:<<!!
ftp -n<<!
open ${url_ftp} 
user ${name_ftp} ${passwd_ftp}
binary
cd ${path_remote}
lcd ${path_local}
prompt
get ${1}
close
bye
!
!!

curl -# -O ftp://${name_ftp}:${passwd_ftp}@${url_ftp}:${port_ftp}/${path_remote}/${1}


echo "${1} has been transfered to local path ${path_local} from ${url_ftp}"
tar xzvf ${1} && mv ${path_file_untar_tmp} ${path_file_untar}


#----------------------------------------------------------------------
#check md5sum local file with remote file
cd ${path_file_untar}

function fun_md5sum_validation(){
name_war='*.war'
file_local_md5sum=`md5sum ${name_war} | cut -d" " -f1 | tr -d " "`
file_remote_md5sum="${path_file_untar_tmp}"

if [ "${file_remote_md5sum}"x = "${file_local_md5sum}"x ];then
   echo "The file has been validated successfully."
   :
else
   echo "The file does not validate successfully."
   exit 1;
fi
}

fun_md5sum_validation
#------------------------------------------------------------------------/


bash /var/tomcat/default/bin/shutdown.sh
sleep 3
rm -rf /douins_api/war/example* && echo "/douins_api/war/agencyapi\* has been removed."
  
cp example.war /douins_api/war/  && echo "agencyapi.war has been copied to /douins_api/war/"
nohup bash /var/tomcat/default/bin/startup.sh & 
ps -ef | grep tomcat
tail -f /war.log
