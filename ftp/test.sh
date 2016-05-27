#!/bin/bash

function pro_info(){
if [ -n "$1" ];then
   echo "\$1 is $1"
else
   echo "\$1 can't empty."
   exit 1
fi
}

pro_info;
