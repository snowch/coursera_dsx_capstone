import org.apache.spark.ml.feature.{RegexTokenizer, Tokenizer}
import org.apache.spark.ml.feature.NGram
import org.apache.spark.sql.functions.countDistinct

val docDataFrame = sc.textFile("en_US.all.txt").toDF("document")//.limit(10000)

val regexTokenizer = new RegexTokenizer().
                            setInputCol("document").
                            setOutputCol("words").
                            setPattern("\\W") 

val tokenizer = new Tokenizer().setInputCol("document").setOutputCol("words")

val tokenizedDoc = tokenizer.transform(docDataFrame)

val ngram = new NGram().setInputCol("words").setOutputCol("ngrams")
val ngramDataFrame = ngram.transform(tokenizedDoc)
val ngramsOnlyDF = ngramDataFrame.
        flatMap(_.getAs[Stream[String]]("ngrams").toList).
        map( ngram => (ngram, 1)).reduceByKey(_ + _).
        map(item => item.swap).
        sortByKey(false, 1).
        map(item => item.swap).
        filter(ngram => ngram._2 > 10)

val ngramsCount = ngramDataFrame.
        flatMap(_.getAs[Stream[String]]("ngrams").toList).
        map( ngram => (ngram, 1)).reduceByKey(_ + _).
        count()

object MyFunctions {
  def func1(t: Tuple2[String, Int]): String = { 
    val parts = t._1.split(" ")
    // remove leading and trailing punctuation from word
    val part_0 = parts(0).replaceFirst("^[^a-zA-Z]+", "").replaceAll("[^a-zA-Z]+$", "");
    val part_1 = parts(1).replaceFirst("^[^a-zA-Z]+", "").replaceAll("[^a-zA-Z]+$", "");
    return s"${part_0}\t${part_1}\t${t._2.toDouble/ngramsCount.toDouble}"
  }
}

ngramsOnlyDF.
    map(MyFunctions.func1).
    coalesce(1).
    saveAsTextFile("digrams.csv")

System.exit(0)
