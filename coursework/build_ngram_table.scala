import org.apache.spark.ml.feature.{RegexTokenizer, Tokenizer}
import org.apache.spark.ml.feature.NGram
import org.apache.spark.sql.functions.countDistinct

val docDataFrame = sc.textFile("en_US.all.txt").toDF("document")

val regexTokenizer = new RegexTokenizer().
                            setInputCol("document").
                            setOutputCol("words").
                            setPattern("\\W") 

val tokenizedDoc = regexTokenizer.transform(docDataFrame)

val ngram = new NGram().setInputCol("words").setOutputCol("ngrams")
val ngramDataFrame = ngram.transform(tokenizedDoc)
val ngramsOnlyDF = ngramDataFrame.
        flatMap(_.getAs[Stream[String]]("ngrams").toList).
        map( ngram => (ngram, 1)).reduceByKey(_ + _).
        map(item => item.swap).
        sortByKey(false, 1).
        map(item => item.swap).
        filter(ngram => ngram._2 > 10)

ngramsOnlyDF.
    map(x => s"${x._1},${x._2}").
    coalesce(1).
    saveAsTextFile("digrams.csv")
