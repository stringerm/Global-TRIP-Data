library(ggplot2)
library(dplyr)
library(plotly)
library(shiny)

# Define UI for application that draws a histogram
fluidPage(

    # Application title
    titlePanel("Global TRIP Scores"),

    # Sidebar with a slider input for number of bins
    sidebarLayout(
        sidebarPanel(
            sliderInput("boxyear",
                        "Select year:",
                        min = 2002,
                        max = 2021,
                        step = 1,
                        value = 2002,
                        sep='',
                        ticks=FALSE,
                        animate=animationOptions(interval = 1000,
                                                 loop = TRUE))
        ),

        # Show a plot of the generated distribution
        mainPanel(
            plotlyOutput("boxPlot")
        )
    )
)

