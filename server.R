library(ggplot2)
library(dplyr)
library(plotly)
library(shiny)
dat <- read.csv("replication.csv")
boxdat <- dat
bardat <- dat
pal <- c('#17becf', '#1f77b4', '#2ca02c', '#9467bd', '#d62728','#bcbd22')
pal <- setNames(pal, unique(dat$e_regionpol_6C))

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
                color = ~e_regionpol_6C,
                colors = pal
                ) %>%
        layout(title = paste0("TRIP Score by Region - ",
                              as.character(input$boxyear),
                              "<br>",
                              "Government Type: ",
                              input$boxregime),
               
               xaxis = list(title="Region"),
               yaxis = list(title="TRIP Score", 
                            range = c(0,13)),
               showlegend = FALSE,
               margin = list(
                 l = 50,
                 r = 50,
                 b = 100,
                 t = 25,
                 pad = 4
               )) 
      
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
                            range = c(0,7)),
               legend=list(
                 yanchor="top",
                 y=0.99,
                 xanchor="left",
                 x=0.01
               ),
               margin = list(
                 l = 0,
                 r = 50,
                 b = 25,
                 t = 50,
                 pad = 4
               ))
    })
    output$barPlot <- renderPlotly({
      if(input$region != "All") {
        bardat <- bardat[bardat$e_regionpol_6C == input$region,]
      }
      bardat %>%
        filter(year == input$boxyear) %>% 
        arrange(desc(trip_score)) %>%
        slice_head(n = 10) %>%
        mutate(country_name = factor(country_name, 
                                     levels = unique(country_name)[order(trip_score, 
                                                                         decreasing = FALSE)])) %>%
        plot_ly(x = ~trip_score, 
                y = ~country_name, type="bar",
                color = ~e_regionpol_6C,
                colors = pal
        ) %>%
        layout(title = paste0("Top 10 Countries by TRIP Score - ",
                              as.character(input$boxyear),
                              "<br>",
                              "Region: ",
                              input$region),
               
               xaxis = list(title="TRIP Score",range = c(0,13)),
               yaxis = list(title="Country"),
               showlegend = FALSE,
               margin=list(
                 l = 50,
                 r = 50,
                 b = 25,
                 t = 50,
                 pad = 4
               )) 
      
    })

}


