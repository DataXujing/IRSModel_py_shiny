
library(shiny)
#library(rPython)
library(shinydashboard)
library(shinyjs)

shinyUI(fluidPage(shinyjs::useShinyjs(),
                  uiOutput("page")))