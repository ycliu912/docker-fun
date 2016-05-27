#!/bin/bash

if [ -n "$1" ];then
   echo "\$1 is $1"
else
   echo "\$1 can't empty."
   exit 1
fi


#----------------------------------------------------------------
url_ftp='moz.*.com'
name_ftp='***'
passwd_ftp='***'
path_remote='/*-api'
path_local="/root/ftp/file_ftp"
#-----------------------------------------------------------------/
 
path_source_pro='/root/ftp/._source_pro'
tag_time=`date +%F-%_H-%M-%S | tr -d " "`
path_file_untar_tmp=`echo ${1} | cut -d"." -f1 | tr -d " "`
path_file_untar="${path_file_untar_tmp}.${tag_time}"
tag_file="${tag_time}.zip"
tag_file_path="/root/ftp/file_ftp/tag_file"

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

echo "${1} has been transfered to local path ${path_local} from ${url_ftp}"
cd ${path_local}
tar xzvf ${1}

mv ${path_file_untar_tmp} ${path_file_untar}

#----------------------------------------------------------------------
#check md5sum local file with remote file
cd ${path_file_untar}

function fun_md5sum_validation(){
name_war='api.war'
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


cp -r ${path_source_pro}/.[^.]*  ./  && cp -r ${path_source_pro}/*  ./

zip -r ${tag_file} * .[^.]*
cp ${tag_file} ${tag_file_path} && echo "${tag_file} has been archived to ${tag_file_path} completely."

#-----------------------------------------------------------------------
appName=<appName>
version_label="${tag_time}"
s3bucket=elasticbeanstalk-cn-north-1-124344232452
s3key="${tag_file}"
env_name='*'
#-----------------------------------------------------------------------/

aws s3 cp ${tag_file_path}/${tag_file} s3://${s3bucket}/${tag_file}

aws elasticbeanstalk create-application-version --application-name ${appName} --version-label ${version_label} --source-bundle \
S3Bucket=${s3bucket},S3Key=${s3key}

aws elasticbeanstalk update-environment --environment-name ${env_name} --version-label ${version_label}

bash /root/ftp/aws_eb_events.sh
