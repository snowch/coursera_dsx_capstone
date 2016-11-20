#!/bin/bash

rm -f trigrams.csv
sshpass -p $SSH_PASS scp build_digrams.scala $SSH_USER@$SSH_HOST:~/
sshpass -p $SSH_PASS ssh -q $SSH_USER@$SSH_HOST << ENDSSH
    rm -f digrams.csv
    hdfs dfs -rm -r -f digrams.csv && \
	spark-shell --master yarn-client -i build_digrams.scala && \
	hdfs dfs -cat digrams.csv/* > digrams.csv 
ENDSSH
sshpass -p $SSH_PASS scp $SSH_USER@$SSH_HOST:~/digrams.csv .

##########

rm -f trigrams.csv
sshpass -p $SSH_PASS scp build_trigrams.scala $SSH_USER@$SSH_HOST:~/
sshpass -p $SSH_PASS ssh -q $SSH_USER@$SSH_HOST << ENDSSH
    rm -f trigrams.csv
    hdfs dfs -rm -r -f trigrams.csv && \
	spark-shell --master yarn-client -i build_trigrams.scala && \
	hdfs dfs -cat trigrams.csv/* > trigrams.csv
ENDSSH
sshpass -p $SSH_PASS scp $SSH_USER@$SSH_HOST:~/trigrams.csv .

