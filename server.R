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


source("WordPrediction.R")

  
shinyServer(
    function(input, output) {
        output$inputValue <- renderText({input$Tcir})
        output$prediction <- renderText({proc(input$Tcir)})
        
        
        
    }
)


