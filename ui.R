#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(rsconnect)
library(NLP)
library(rJava)
library(tm)
library(RWeka)
library(data.table)
library(dplyr)
library(shinydashboard)
library(lubridate)
library(plotly)
library(shinyWidgets)
library(DT)
library(shinyjs)
library(graphics)
library(methods)
library(grid)
library(futile.logger)
ui <- fluidPage(
    
   titlePanel("Text Prediction"),
    
    sidebarLayout(
        
        sidebarPanel(
            h4("Steps for Entering Texts", style="color:Black"),
            p("1. Enter word in text box"),
            p("2. As per entry, algorithm will predict the next word and propmt it"),
            p("3. Add the predicted word to enterd text and submit again"),
            p("4. Repeat the steps and try more combinations")
        ),
        
        mainPanel(
            h3("Application - Text Prompter"),
            h5("In this application,n-gram algorithm is used to predict the next word"),
            
            textInput("Tcir",label=h3("Enter word in text box:")),
            submitButton('Submit'),
            h4('Entered Word by user : '),
            verbatimTextOutput("inputValue"),
            h4('Predicted Word :'),
            verbatimTextOutput("prediction")
            
        )
    ))