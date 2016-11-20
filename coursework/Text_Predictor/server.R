library(shiny)
library(stringr)

digrams <- read.csv('./digrams.csv', header = FALSE, sep = '\t')

shinyServer(function(input, output) {
 
  getPredictions <- reactive({
    if (nchar(input$input_text) > 0) {
      last_word <- word(input$input_text,-1)
      last_word <- tolower(last_word)
      found_diagrams <- digrams[ digrams$V1 == last_word, ]
      top_five_digrams <- found_diagrams[ order(found_diagrams$V3, decreasing = TRUE), ][1:5, 2]
      top_five_digrams <- as.character(top_five_digrams)
      top_five_digrams <- paste(top_five_digrams, collapse =" : ")
      return (top_five_digrams)
    } else {
      return ("")
    }
  })
   
  output$output_text <- renderText({
    paste("<font color=\"#FF0000\"><b>", getPredictions(), "</b></font>")
  })
  
})
