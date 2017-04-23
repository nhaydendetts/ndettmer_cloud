#!/bin/bash 
#user and shell checker script, name it checker.sh

if [ -z $1 ]
  echo "User Not Provided"
  exit
fi
if [ -z $2 ]
  echo "Shell Not Provided"
  exit
fi
user=$1
shell=$2
for x in $(cat /etc/passwd)
do
  un=$(echo $x | grep $user)
  if [ $? -ne 0 ]; then
     echo “$user not yet found”
  else
     echo “$user found”
     sh=$(echo $x| cut -d':' -f7 | cut -d'/' -f3)
	if [ “$sh” = “$shell” ]; then
        echo “shell is correct”
	else “shell is incorrect”
	fi
  fi
done 
