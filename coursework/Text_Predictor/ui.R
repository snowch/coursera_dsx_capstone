library(shiny)

shinyUI(fluidPage(
  
  titlePanel("Text Prediction Application"),
  hr(),
  
  mainPanel(
    h3("Enter text"),
    p("Enter some text in the box below."),
    textInput("input_text", ""),
    tags$ul(
      tags$li("This application predicts the next word."),
      #tags$li("The top five words are predicted and are displayed below."),
      #tags$li("The predictions are in order with the strongest prediction being first."),
      tags$li("If there isn't a prediction available, NA is displayed.")
    ),
    h3("Predicted text"),
    htmlOutput("output_text")
  )
))
