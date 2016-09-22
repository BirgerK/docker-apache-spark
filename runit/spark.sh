#!/bin/bash

if [ "$SPARK_ROLE" = "master" ]; then
  $SPARK_HOME/bin/spark-class org.apache.spark.deploy.master.Master
fi
if [ "$SPARK_ROLE" = "slave" ]; then
  export SPARK_MASTER_IP=$(cat /etc/hosts | grep $SPARK_MASTER | awk 'NR==1 {print $1}')
  $SPARK_HOME/bin/spark-class org.apache.spark.deploy.worker.Worker spark://$SPARK_MASTER_IP:$SPARK_MASTER_PORT
fi
