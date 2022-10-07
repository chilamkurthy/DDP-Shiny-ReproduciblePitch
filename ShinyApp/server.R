#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(plotly)
library(lubridate)

# Define server logic required to draw a histogram


shinyServer(
  
  function(input, output) {
    
    data <- read.csv("MyDatas.csv", sep = ',', quote = '"', dec = '.', stringsAsFactors = FALSE)
    data$Date <- as.Date(data$Date, "%Y-%m-%d")
    
    output$State <- renderUI({
      selectInput("State", "Choose a State:", as.list(unique(data$State)), selected = levels(data$State)[60] ) 
    })
    
    output$rname <- renderUI({
      selectInput("rname", "Choose a variable:", as.list(unique(data$SchemeName)), selected = levels(data$SchemeName)[1]) 
    })  
    
    output$text1 <- renderText({
      paste("You have selected: ", input$rname, " in ", input$State)
    })
    
    # output$Total <- renderPrint({ input$slider })
    
    output$slider1 <- renderUI({
      if (input$period == "yearbegin"){
        sliderInput("slider1", label = "From year", min = 2019, max = 2022, Total = 2021, sep = "")
      }
    })
    
    output$slider2 <- renderUI({
      if (input$period == "year"){
        sliderInput("slider2", label = "Years range", min = 2019, max = 2022, Total = c(2020,2021), sep = "")
      }
    })
    
    output$dates <- renderUI({
      if (input$period == "mon"){
        dateRangeInput("dates", label = "Date range", start = "2019-01-01", end = "2022-04-04", 
                       min = "2019-01-01", max = "2022-04-04")
      }
    })
    
    output$distPlot <- renderPlotly({
      if (input$period == "all")
      {
        dt <- data[data$State == input$State & data$SchemeName == input$rname, ]
      }
      if (input$period == "yearbegin")
      {
        sl <- input$slider1
        year <- as.character(sl)
        d <- as.Date(paste(year,"-01-01", sep=""))
        
        dt <- data[data$State == input$State & data$SchemeName == input$rname & data$Date >= d, ]
      }
      if (input$period == "year")
      {
        # d <- as.Date('2022-04-04')
        # d <- d %m+% years(-1)
        sl <- input$slider2
        year1 <- as.character(sl[1])
        year2 <- as.character(sl[2])
        d1 <- as.Date(paste(year1,"-01-01",sep=""))
        d2 <- as.Date(paste(year2,"-01-01",sep=""))
        
        dt <- data[data$State == input$State & data$SchemeName == input$rname & data$Date >= d1 & data$Date <= d2, ]
      }
      if (input$period == "mon")
      {
        # d <- as.Date('2022-04-04')
        # d <- d %m+% months(-1)
        d1 <- as.Date(input$dates[1])
        d2 <- as.Date(input$dates[2])
        dt <- data[data$State == input$State & data$SchemeName == input$rname & data$Date >= d1, ]
      }
      
      #plot_ly(x=~Date, y=~Total, data=dt, type = 'scatter', mode = 'lines')
      p <- ggplot(data = dt, aes(x=Date, y=Total)) + geom_line()
      
      if ("1" %in% input$chkGroup)
        p <- p + geom_smooth(method = "loess", aes(color="Auto Model"))
      if ("2" %in% input$chkGroup)
        p <- p + geom_smooth(method = "glm", aes(color="Linear Model"), formula = y~x)
      if ("3" %in% input$chkGroup)
        p <- p + geom_smooth(method = "glm", aes(color="Poly Model"), formula= (y ~ poly(x,2)), linetype = 1)
      
      p <- ggplotly(p)
    })
    
  })
