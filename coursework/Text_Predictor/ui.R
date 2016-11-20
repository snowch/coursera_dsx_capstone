library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Text Prediction Application"),
  
  # Show a plot of the generated distribution
  mainPanel(
    textInput("input_text", "Enter text", ""),
    h5("Predicted text"),
    textOutput("output_text")
  )
))
