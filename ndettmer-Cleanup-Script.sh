#!/bin/bash


HOUR=12
CSVFILE="instances.csv"
CSVDBFILE="dbinstances.csv"



#Shut Down EC2 Instances
aws ec2 describe-instances | jq -r '.Reservations[].Instances[] |  .InstanceId + "," + .LaunchTime' > $CSVFILE

for x in $(cat $CSVFILE)
do
  lt=$(echo $x | cut -f2 -d',')
  id=$(echo $x | cut -f1 -d',')

  ltu=$(date -d $lt "+%s") #current unix time in seconds
  runtime=$(( $(date "+%s")-$ltu )) #the time the instance run
  if [ $(($runtime/3600)) -gt $HOUR ]; then 
    echo "$id was running since $lt ...needs to be terminated"
    aws ec2 terminate-instances --instance-ids $id
  else
    echo "$id is safe"
  fi


#Shut Down RDS Instances
aws rds describe-db-instances | jq -r '.Instances[] |  .DBInstanceIdentifier + "," + .InstanceCreateTime' > $CSVDBFILE

for x in $(cat $CSVDBFILE)
do
  lt=$(echo $x | cut -f2 -d',')
  id=$(echo $x | cut -f1 -d',')

  ltu=$(date -d $lt "+%s") #current unix time in seconds
  runtime=$(( $(date "+%s")-$ltu )) #the time the instance run
  if [ $(($runtime/3600)) -gt $HOUR ]; then 
    echo "$id was running since $lt ...needs to be terminated"
    aws rds delete-db-instance --db-instance-identifier $id
  else
    echo "$id is safe"
  fi

done




 






