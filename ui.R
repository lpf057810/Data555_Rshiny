library(shiny)
library(plotly)
library(leaflet)

shinyUI(fluidPage(
  titlePanel("Obesity Risk Analysis in Georgia"),
  
  tabsetPanel(
    tabPanel("Feature Distribution",
             sidebarLayout(
               sidebarPanel(
                 helpText("Distribution of predictor variables by county.")
               ),
               mainPanel(
                 plotlyOutput("box_jitter_plot"),
                 br(),
                 h4("Key Takeaways"),
                 uiOutput("takeaway1")
               )
             )
    ),
    
    tabPanel("Region Bias Map",
             leafletOutput("leaflet_map", height = 600),
             br(),
             h4("Key Takeaways"),
             uiOutput("takeaway2")
    ),
    
    tabPanel("Dataset Info",
             h4("Dataset Description"),
             p("This dataset explores geospatial and behavioral risk factors contributing to obesity across Georgia counties."),
             p("Data Source: project-Geo final_combined.csv"),
             p("Filtered to counties with model R² > 0.85; counties like Cherokee, Henry, and Paulding excluded."),
             p("Variables include: sleep, income, environment, demographics."),
             p("Purpose: explore regional obesity risk for public health interventions.")
    )
  )
))
