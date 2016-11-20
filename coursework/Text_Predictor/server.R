library(shiny)
library(stringr)

digrams  <- read.csv('./digrams.csv', header = FALSE, sep = '\t')
trigrams <- read.csv('./trigrams.csv', header = FALSE, sep = '\t')

print("finished loading data")

shinyServer(function(input, output) {
 
  getPredictions <- reactive({
  
    top_five_words <- ""
    
    input_text = trimws(input$input_text, which=c("both"))
    
    if (nchar(input_text) > 0) {
      
      word_count <- str_count(input_text, "\\S+")
      if (word_count > 1) {
        last_two_words <- paste(word(input_text, -2:-1), collapse = " ")
        last_two_words <- tolower(last_two_words)
        found_trigrams <- trigrams[ trigrams$V1 == last_two_words, ]
        top_five_trigrams <- unique(found_trigrams[ order(found_trigrams$V3, decreasing = TRUE), ])[1:1, 2]
        top_five_trigrams <- as.character(top_five_trigrams)
        top_five_words <- paste(top_five_trigrams, collapse =" : ")
        
        print(top_five_trigrams)
        
        # fall back to digram lookup if trigram didn't work
        if (is.na(top_five_trigrams[1])) {
          last_word <- word(input_text,-1)
          last_word <- tolower(last_word)
          found_digrams <- digrams[ digrams$V1 == last_word, ]
          top_five_digrams <- unique(found_digrams[ order(found_digrams$V3, decreasing = TRUE), ])[1:1, 2]
          top_five_digrams <- as.character(top_five_digrams)
          top_five_words <- paste(top_five_digrams, collapse =" : ")          
        }
        
      } else {
        # word count = 1
        last_word <- word(input_text,-1)
        last_word <- tolower(last_word)
        found_digrams <- digrams[ digrams$V1 == last_word, ]
        top_five_digrams <- unique(found_digrams[ order(found_digrams$V3, decreasing = TRUE), ])[1:1, 2]
        top_five_digrams <- as.character(top_five_digrams)
        top_five_words <- paste(top_five_digrams, collapse =" : ")
      }
    }
    return (top_five_words)
  })
   
  output$output_text <- renderText({
    paste("<font color=\"#FF0000\"><b>", getPredictions(), "</b></font>")
  })
  
})
