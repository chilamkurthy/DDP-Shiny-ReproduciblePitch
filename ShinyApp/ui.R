#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#
library(plotly)
library(shiny)

# Define UI for application that draws a histogram


shinyUI(fluidPage(
  
  # Application title
  titlePanel("Agriculture Scheme Open Data"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
      uiOutput("State"),
      uiOutput("rname"),
      
      radioButtons("period", "Choose a period:", 
                   c("Date range"="mon",
                     "Years" = "year",
                     "From the year begin" = "yearbegin",
                     "All the time" = "all"),
                   selected = "all"),
      uiOutput("slider1"),
      uiOutput("slider2"),
      uiOutput("dates"),
      checkboxGroupInput("chkGroup", label = h3("Geom smooth"), 
                         choices = list("Auto" = 1, "Linear model" = 2, "Poly Model" = 3),
                         selected = 1)
    ),
    
    
    # Show a plot of the generated distribution
    mainPanel(
      h3(textOutput("text1")),
      plotlyOutput("distPlot")
    )
  ),
  
  hr(),
  
  fluidRow(
    column(4, h3("Agriculture Schemes Open Data plotting tool"), h5("by Vijayakumar")),
    column(6, 
           h3("Statement"),
           p("Agriculture Schemes occupies 30% to 80% of the Financial and Economical services market, depending on the State and product in India. It analyze data on 40 million private and 2.5 million corporate customers."),
           h3("Instructions"),
           p("The app has several inputs to manipulate the data and plot. A user can select a measurement, State and period."),
           HTML("<ol>
                <li>Select a State of interest</li>
                <li>Select a variable (information about partial economic processes)</li>
                <li>Select a period of interest:</li>
                <ul>
                  <li>Date range - specifies the begining date and end dates of showing data</li>
                  <li>Years - a slider that specifies the years of showing data</li>
                  <li>From the year begin - a slider that specifies from the begin of which year to show the data</li>
                  <li>Finally, All the time - showing the data for all the time</li>
                </ul>
               </ol>"),
           
           p("The user also could select an approximation model for the showing data:"),
           HTML("<ul>
                  <li>Auto - the plot generates an approximation curve automatically</li>
                  <li>Linear model - the plot generates Linear approximation model curve</li>
                  <li>Poly model - the plot generates polynom model curve for the presented data</li>
                </ul>")
    )
    
  )
  
)
)
