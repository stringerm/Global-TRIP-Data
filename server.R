library(ggplot2)
library(dplyr)
library(plotly)
library(shiny)
dat <- read.csv("replication.csv")

# Define server logic required to draw a histogram
function(input, output) {

    output$boxPlot <- renderPlotly({
      dat %>%
        filter(year == input$boxyear) %>%
        plot_ly(x = ~e_regionpol_6C, 
                y = ~trip_score, type="box", 
                color = ~e_regionpol_6C,
                boxpoints = 'all',
                jitter = 0.6,
                pointpos = -2
                ) %>%
        layout(title = "TRIP Score by Region",
               xaxis = list(title="Region"),
               yaxis = list(title="TRIP Score", 
                            range = c(0,13)),
               showlegend = FALSE,
               boxgap = 0.5) 
      
    })

}


