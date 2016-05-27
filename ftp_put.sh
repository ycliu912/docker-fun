#!/bin/bash

set -e

if [ -n "$1" ];then
   :
else
   echo "\$1 can't empty."
   exit 1
fi



cd ${2}
file_path=`pwd`
build_time=`stat ${1} | grep Modify | cut -d":" -f2- | sed -r 's/^ *//g'`

sysOS=`uname -s`
if [ "${sysOS}" == "Darwin" ];then
   name_path_md5sum=`md5 -r  ${1} | cut -d" " -f1`
else
   name_path_md5sum=`md5sum  ${1} | cut -d" " -f1`
fi

#---------------------------
url_ftp='moz.douins.com'
port_ftp=21
name_ftp='douins'
passwd_ftp='douins'
path_remote='agency-api'
path_local="${file_path}"
#---------------------------

cat <<!
`clear`
=======================================================================================
                 FILE INFO CONFIRMATION
---------------------------------------------------------------------------------------
FILE_NAME        ${1}                                                        
FIEL_PATH        ${file_path}
BUILD_TIME       ${build_time}   
MD5SUM           ${name_path_md5sum}
=======================================================================================
!

read -n1 -p "All of the above information is correct[y/n]?" answer

case ${answer} in
Y | y)
     :      ;;
N | n)
     exit 1 ;;
*)
     echo  "bad choice";;
esac


mkdir "${name_path_md5sum}"
cp ${1} "${name_path_md5sum}"
tar czvf "${name_path_md5sum}".tar.gz "${name_path_md5sum}" > /dev/null

file_tar_gz="${name_path_md5sum}.tar.gz"

:<<!! 
ftp -n<<!
open ${url_ftp} 
user ${name_ftp} ${passwd_ftp}
binary
cd ${path_remote}
lcd ${path_local}
prompt
put ${file_tar_gz}
close
bye
!
!!

curl -# -T ${file_tar_gz} ftp://${name_ftp}:${passwd_ftp}@${url_ftp}:${port_ftp}/${path_remote}/

echo "${1} has been transfered to moz.douins.com as ${file_tar_gz}"
rm  -rf  "${name_path_md5sum}" 
rm  -rf  "${file_tar_gz}" 
