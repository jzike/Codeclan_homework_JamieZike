library(tidyverse)
library(shiny)
library(plotly)
library(bslib)


# data --------------------------------------------------------------------

game_sales_clean <- read_csv("data/game_sales_clean.csv")

genre_choices <- game_sales_clean %>% 
  distinct(genre) %>% 
    pull()

year_choices <- c("Before 2000",
                  "2000",
                  "2001",
                  "2002",
                  "2003",
                  "2004",
                  "2005",
                  "2006",
                  "2007",
                  "2008",
                  "2009",
                  "2010",
                  "2011",
                  "2012",
                  "2013",
                  "2014",
                  "2015",
                  "2016")

# ui ----------------------------------------------------------------------

ui <- 
  fluidPage(
    theme = bs_theme(bootswatch = 'darkly'),
    titlePanel(tags$h1("Game Ratings by Year")),
    tabsetPanel(
      tabPanel("Scores and ratings",
               sidebarLayout(
                 sidebarPanel = sidebarPanel(
                   p("Select a year and genre"),
                   selectInput("year_input",
                               "Year of release",
                               choices = year_choices),
                   checkboxGroupInput("genre_input",
                                      "Select genre(s)",
                                      choices = genre_choices),
                   width = 2),
                 mainPanel = mainPanel(fluidRow(
                   column(5, plotlyOutput("score_graph")),
                   column(5, plotOutput("rating_graph"))
                 ), width = 10
                 )
               ) 
      ),
      tabPanel("Top 10 Table",
               fluidRow(HTML("<center><h2> Top 10 user-scored games (inc. ties) 
            </h2></center>")),
            fluidRow(DT::dataTableOutput("top_table"))
      )
    )
)



# server ------------------------------------------------------------------

server <- function(input, output){
  
  filtered_data <- reactive({
    game_sales_clean %>% 
      filter(year_choices == input$year_input,
             genre %in% input$genre_input)
    
    })
  
  output$score_graph <- renderPlotly({
      plot_ly(data = filtered_data(), 
              x = ~user_score,
              y = ~critic_score,
              color = ~stat_diff,
              colors = c("grey30", "red"),
              type = "scatter",
              mode = "markers",
              hoverinfo = "text",
              text = paste("Game: ", filtered_data()$name,
                           "<br>",
                           "User score: ", filtered_data()$user_score,
                           "<br>",
                           "Critic score: ", filtered_data()$critic_score)) %>% 
      layout(title = "<b>\nDifferences between critic and user game ratings \n <b>",
             xaxis = list(title = "User score"),
             yaxis = list(title = "Critic score"),
             legend = list(title = list(text = "Score disagreement?"),
                           x = 100, y = 0.5))
  })
  
  output$rating_graph <- renderPlot({
    filtered_data() %>% 
      ggplot(aes(x = factor(rating, levels = c("E",
                                               "E10+",
                                               "T",
                                               "M")))) +
      geom_bar(fill = "grey30") +
      labs(title = "Ratings by year",
           x = "Assigned rating",
           y = "Count") +
      theme_minimal()
  })
  
  output$top_table <- DT::renderDataTable({
    filtered_data() %>% 
      select(name,
             genre,
             publisher,
             user_score,
             critic_score,
             rating,
             platform
             ) %>% 
      slice_max(user_score, n = 10)
  })
  
}


shinyApp(ui = ui, server = server)