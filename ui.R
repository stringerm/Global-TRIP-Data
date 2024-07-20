library(ggplot2)
library(dplyr)
library(plotly)
library(shiny)

# Define UI for application that draws a histogram
fluidPage(

    # Application title
    titlePanel("Global TRIP Scores: 2007-2021"),

    # Sidebar with a slider input for number of bins
    sidebarLayout(
        sidebarPanel(
            sliderInput("boxyear",
                        "Select year:",
                        min = 2007,
                        max = 2021,
                        step = 1,
                        value = 2007,
                        sep='',
                        ticks=FALSE,
                        animate=animationOptions(interval = 1000,
                                                 loop = TRUE)),
            selectInput(inputId = "boxregime", 
                        label="Government type:", 
                        choices = c("All",
                                    "Liberal Democracy",
                                    "Electoral Democracy",
                                    "Electoral Autocracy",
                                    "Closed Autocracy"
                        ), 
                        selected="All")
            
        ),

        # Show a plot of the generated distribution
        mainPanel(
            plotlyOutput("boxPlot"),
            br(),
            plotlyOutput("globalLine")
        )
    )
)

