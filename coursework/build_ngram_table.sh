#!/bin/bash

hdfs dfs -rm -r -f digrams.csv && \
	spark-shell --master yarn-client -i extract_ngrams.scala && \
	hdfs dfs -cat digrams.csv/* > digrams.csv
