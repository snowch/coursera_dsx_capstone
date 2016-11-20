Text Predictor Application
========================================================
author: Chris Snow
date: 19th November 2016
autosize: true


Overview
========================================================

 - The purpose of this slide deck is to introduce a novel word prediction application
 - An algorithm has been developed to predict the next word in a sequence of words
 - Example application is for predictive text typing on mobile phones
 - This prototype is a minimal viable product (MVP)
 - Future funding will support more accurate prediction algorithms

Algorithm
========================================================

 - The algorithm uses a 2-gram and 3-gram model
 - A large corpus of over 4 million documents used to calculate the next word probabilities
 - Using the user entered text, the 2 or 3-ngram with highest probability is looked up
 - Apache Spark running on a 3 node hadoop cluster was used to build the n-gram models
 - n-gram models were exported from spark to csv files for use in shiny app
 - Hosted shiny apps have a file size limit, so only the higest probability n-grams were kept

Instructions
========================================================

- Open the URL: https://snowch.shinyapps.io/Text_Predictor/
- Enter some text in the box labeled 'Enter text'
- You will be provided a prediction for the next word

Conclusion
========================================================

- The strength of this approach is using Big Data tools to use large corpus to build model
- Next step is to refine the algorithm to improve its accuracy
- Model building source code available here: https://github.com/snowch/coursera_dsx_capstone/tree/master/coursework/spark_ngram_builder
 
