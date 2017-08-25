
#############################
###### UI        ###########
############################


library(shiny)
library(shinydashboard)
library(shinyjs)
library(rPython)
library(xlsx)

ui2<-shinyUI(
 
  dashboardPage(skin= "black",
  dashboardHeader(title=img(src="logo.png",width=150,hight=150),
                  
                  dropdownMenu(type = "messages",
                               messageItem(
                                 from = "我的消息",
                                 message = "我的最新消息"
                               )),
                  dropdownMenu(type = "notifications",
                               notificationItem(
                                 text = "注意最新消息",
                                 icon("users")
                               )),

                  dropdownMenu(type = "tasks", badgeStatus = "success",
                               taskItem(value = 90, color = "green",
                                        "Documentation"
                               ),
                               taskItem(value = 17, color = "aqua",
                                        "Project "
                               ),
                               taskItem(value = 75, color = "yellow",
                                        "Server deployment"
                               ),
                               taskItem(value = 80, color = "red",
                                        "Overall project"
                               ))
                  ),
  
  
  dashboardSidebar(
    sidebarSearchForm(textId = "searchText", buttonId = "searchButton",
                      label = "Search..."),
    sidebarMenu(
     
      br(),
      
      
      menuItem("一键洗案",tabName="xian",icon=icon("picture-o"),
               menuSubItem("全局洗案",tabName="quan",icon=icon("area-chart")),

               menuSubItem("组内洗案",tabName="zu",icon=icon("pie-chart"))
              ),

      menuItem("字段说明", tabName = "table1", icon = icon("table"),badgeLabel="字段",badgeColor = "yellow"),

      menuItem("推荐系统介绍",tabName="plot1",icon=icon("file-text-o"),badgeLabel="介绍",badgeColor = "yellow"),

      menuItem("策略思想",tabName="dashboard2", icon = icon("dashboard"),badgeLabel="思想",badgeColor = "purple"),
      
      
      br(),
      br(),
      br(),
      br(),
      br(),
      br(),
      br(),
      br(),
      br(),
      br(),
      br(),
      br(),
      
      a(img(src="logo.png",height=50,width=150),href="http://www.inter-credit.net/",target="black"),
      
      br(),
      br()

    ),
    
    p("版权所有：青岛联信"),
    
    format(Sys.time(), "%Y年%b%d日[%a%X]"),
    
    p("欢迎使用,祝工作愉快")
    
    
    ),


  dashboardBody(
    
    
     tabItems(
       
       tabItem(tabName="quan",
               div(br(),
                
                 "长帐龄要求仅组内洗案",
                   style="font-family:Georgia;font-family:Arial;text-align: center;font-size: 50px;" 
                   )),
    
      
       # tabItem(tabName="quan",
       #         
       #         fluidRow(
       #           column(width=4, fileInput("file1", label = h4(tagList(icon=icon("sign-in"), "导入待洗案的数据"))),
       #                  p("这些数据是做好特征工程的待分数据",style="font-family:'幼圆';font-size:10px;color:orange;"),
       #                  p("我们假设这些案件的上一阶段都有法务操做",style="font-family:'幼圆';font-size:10px;color:orange;"),
       #                  p("智能推荐基于上一阶段或历史操作案件数据进行案件推荐",style="font-family:'幼圆';font-size:10px;color:orange;"),
       #                  p("新案是无法在本系统中推荐的，因为推荐考虑的因素包含了案件处理阶段的因素",style="font-family:'幼圆';font-size:10px;color:orange;"),
       #                  p("初定回收率大于等于10%的案件不参与洗案",style="font-family:'幼圆';font-size:10px;color:orange;"),
       #                  p("让我们愉快的一键洗案吧",style="font-family:'幼圆';font-size:10px;color:orange;")),
       #           box(width=8 ,title=tagList(icon=icon("wrench"),"智能推荐模块"),
       #               actionButton("action1",label = (tagList(icon=icon("play-circle"), "点我智能推荐洗案"))),
       #               hr(),
       #               p("代码运行:(数据保存到了D盘)", style = "color:#888888;"))
       #           
       #        ) ),
       tabItem(tabName="zu",
               fluidRow(
                 column(width=4, fileInput("file1", label = h4(tagList(icon=icon("sign-in"), "导入待洗案的数据")),accept=c("application/xlsx")),
                        p("这些数据是做好特征工程的待分数据",style="font-family:'幼圆';font-size:10px;color:orange;"),
                        p("我们假设这些案件的上一阶段都有法务操做",style="font-family:'幼圆';font-size:10px;color:orange;"),
                        p("智能推荐基于上一阶段或历史操作案件数据进行案件推荐",style="font-family:'幼圆';font-size:10px;color:orange;"),
                        p("新案是无法在本系统中推荐的，因为推荐考虑的因素包含了案件处理阶段的因素",style="font-family:'幼圆';font-size:10px;color:orange;"),
                        p("初定回收率大于等于10%的案件不参与洗案",style="font-family:'幼圆';font-size:10px;color:orange;"),
                        p("让我们愉快的一键洗案吧",style="font-family:'幼圆';font-size:10px;color:orange;")),
                 box(width=6 ,title=tagList(icon=icon("wrench"),"智能推荐模块"),
                     actionButton("action1",label = (tagList(icon=icon("play-circle"), "点我智能推荐洗案"))),
                     hr(),
                     p("代码运行:(数据保存到了D盘)", style = "color:#888888;"),
                     verbatimTextOutput("actionOut1"))

               ),
               fluidRow(box(title = tagList(icon=icon("clone"),"洗案数据展示"),width = 10,status = "primary",solidHeader = TRUE,collapsible = TRUE,
                            DT::dataTableOutput("xadata"))
               
               )),
       
       tabItem(tabName="table1",dataTableOutput('DTtable')),
       
       
       tabItem(tabName = "plot1",div(img(src="systerm.png",width=900)),style="text-align: center;"),
        
       tabItem(tabName="dashboard2",div(img(src="idea.png",width=900)),style="text-align: center;border:2px solid;border-radius:25px; -moz-border-radius:25px; /* Old Firefox */",
               h3("用法务历史操作案件的特征来衡量一个法务的特征,并在相应的特征中抽取比例的案件作为推荐"))

     )
    )#dashboardBody 
))
    
   
  
  
  

