

#########################
#####  Server    #######
########################


library(shiny)
library(shinydashboard)
library(shinyjs)
library(rPython)
library(xlsx)


#--------------------------------------------------------------------------------------------------------------------------
##
##
##Main Function 
##
##
##
#------------------------------------------------------------------------------------------------------------------------

shinyServer(function(input, output,session) {
  
  Logged<-F;
  my_username<-'xujing'      
  my_password<-"xujing";
  
  USER<-reactiveValues(Logged=Logged)
  
  observe({
    if (USER$Logged==F)
    {
      if(!is.null(input$Login)) 
      {
        if(input$Login>0)
        {
          if(input$username==my_username & input$password==my_password)
          {
            
            
            output$page<-renderUI({ui2})  
            
          }
        }
      }
    }
    
    
  })
  
  output$page<-renderUI({
    if(USER$Logged==F)
    {
      do.call(bootstrapPage,c("",ui1))                 
      #do.call() 是告诉list一个函数，然后list里的所有元素来执行这个函数。
    }
    else
     HTML(ui2)
  })
  
  #--------------------------------------------------------------------------
  xian <- eventReactive(input$action1,{python.load('Model.py',get.exception = TRUE)})
  
  xiandata <- reactive({
    xiandat<-  read.xlsx(input$file1$datapath, 1,encoding="UTF-8")
    xiandat
  })
  
  output$actionOut1<-renderPrint({xian()})
  
  
  output$xadata<-renderDataTable({
    
    
    if(is.null(input$file1))
      return(NULL)
    
    else
    {
      DT::datatable(xiandata(),class = 'cell-border stripe',
                    options = list(
                      initComplete = JS(
                        "function(settings, json) {",
                        "$(this.api().table().header()).css({'background-color': '#000', 'color': '#fff'});",
                        "}"),
                      pageLength = 10))
    }
    
    
  })
  
  
  
  #---------------------------------------------------------------------------
  
  
  output$DTtable <- renderDataTable({
   
    datatable(
      ziduan, extensions = 'Buttons', options = list(pageLength = 11,
        dom = 'Bfrtip',
        buttons = c('csv', 'excel', 'pdf', 'print')
      )
    )
  })
 
  
  


  

  
  

  
  
  
  
  
})


