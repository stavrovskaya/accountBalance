#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)


# Define server logic required to draw a histogram
shinyServer(function(input, output, session) {
   
  output$warning <- renderText({ 
    ""
  })
  
  observeEvent(input$test, {
    updateTextAreaInput(session, "clients", value="ar-potolcki\nblue-sleep\nsportcloud2017\nbiolatic-project")
  })  
  
  observeEvent(input$do, {

    progress <- shiny::Progress$new()
    progress$set(message = "Computing data", value = 0)
    on.exit(progress$close())
    
    updateProgress <- function(value = NULL, detail = NULL) {
      if (is.null(value)) {
        value <- progress$getValue()
        value <- value + (progress$getMax() - value) / 5
      }
      progress$set(value = value, detail = detail)
    }
    
    
    clients<-unlist(strsplit(input$clients, "\n"))
    clients<-str_trim(clients)
    source("getBalance.R")
    tryCatch({
      report<-getBalance(clients, updateProgress)
      
      too_low<-report$Amount<5*report$mean_day_cost
      print(too_low)
      too_low=as.integer(too_low)
      report<-cbind(report, too_low)
      colnames(report)<-c("Логин", "Остаток", "Ср. дневной расход", "Мало")
      
      output$table = DT::renderDataTable({
        
        
        DT::datatable(report, selection = 'none'
        ) %>% formatStyle(
          c(4),
          target = 'row',
          backgroundColor = styleEqual(c(1), c('#ff6666'))
        )
      })
    
  }, error = function(err) {
    output$warning<-renderText({paste(err)})
  })   
  session$onSessionEnded(stopApp)
  })
  observeEvent(input$clients, {
    output$warning <- renderText({ 
      ""
    })
  })
})
