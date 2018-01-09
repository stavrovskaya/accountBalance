#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(DT)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Остаток на счетах клиентов"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
       
       textAreaInput("clients", "Введите список логинов клиентов", height = "400"),
       
       fluidRow(
         
         column(6, align="left",
                
                actionButton("do", "загрузить отчет")
                
         ),
         
         
         
         column(6, align="right",
                
                actionButton("test", "тестовый пример")
         )
       )
       
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
      h4(textOutput("warning"), style="color:red"),
      dataTableOutput('table')
    )
  )
))
