library(ggplot2)
library(dplyr)
library(plotly)
library(shiny)
dat <- read.csv("replication.csv")
boxdat <- dat

# Define server logic required to draw a histogram
function(input, output) {

    output$boxPlot <- renderPlotly({
      if(input$boxregime != "All") {
        boxdat <- boxdat[boxdat$v2x_regime == input$boxregime,]
      }
      boxdat %>%
        filter(year == input$boxyear) %>%
        plot_ly(x = ~e_regionpol_6C, 
                y = ~trip_score, type="box", 
                color = ~e_regionpol_6C
                ) %>%
        layout(title = "TRIP Score by Region",
               xaxis = list(title="Region"),
               yaxis = list(title="TRIP Score", 
                            range = c(0,13)),
               showlegend = FALSE) 
      
    })
    output$globalLine <- renderPlotly({
      linedat <- dat %>%
        filter(year > 2006) %>%
        group_by(year,v2x_regime) %>%
        summarise(avg_trip = mean(trip_score, na.rm = TRUE))
      
      trace1 <- linedat %>% filter(v2x_regime == "Liberal Democracy") %>%
        select(avg_trip)
      trace2 <- linedat %>% filter(v2x_regime == "Electoral Democracy") %>%
        select(avg_trip)
      trace3 <- linedat %>% filter(v2x_regime == "Electoral Autocracy") %>%
        select(avg_trip)
      trace4 <- linedat %>% filter(v2x_regime == "Closed Autocracy") %>%
        select(avg_trip)
      years <- 2007:2021
      
      chartdf <- data.frame(years,trace1,trace2,trace3,trace4)
      chartdf %>%
        plot_ly(x = ~years,
                      y = ~trace1$avg_trip,
                      name = 'Liberal Democracy',
                      type="scatter",
                      mode="lines") %>%
        add_trace(y = ~trace2$avg_trip, name = 'Electoral Democracy', mode = 'lines') %>%
        add_trace(y = ~trace3$avg_trip, name = 'Electoral Autocracy', mode = 'lines') %>%
        add_trace(y = ~trace4$avg_trip, name = 'Closed Autocracy', mode = 'lines') %>%
        layout(title = "Average Global TRIP Score",
               xaxis = list(title="Year",
                            range = c(2007,2021)),
               yaxis = list(title="Average TRIP Score", 
                            range = c(0,7)))
    })

}


