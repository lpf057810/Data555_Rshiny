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
             p("The dataset can be accessed from the public source at ",
               tags$a(href = "https://github.com/lpf057810/APE", "GitHub", target = "_blank"), "."),
             p("Sample size includes 978 Census Tracts across Atlanta, Georgia, with 85 measured variables."),
             p("The study population comprises citizens from 28 counties in the Atlanta metropolitan area who are classified as obese."),
             p("Data were collected by merging public datasets at the Census Tract level using SQL and Python, including the CDC 500 Cities Project (2022), USDA Food Access Research Atlas (2022), NASA Black Marble Suite (2017–2022), and the National Neighborhood Data Archive (2017–2022)."),
             p("The overall time period covered by the datasets is from 2017 to 2022.")
    )
  ),
  
  hr(),
  
  div(
    style = "text-align:center; padding:10px;",
    p("View the source code on ",
      tags$a(href = "https://github.com/lpf057810/Data555_Rshiny", 
             "GitHub", target = "_blank"),
      " | This dashboard helps identify key factors contributing to obesity in Georgia counties. The findings support targeted public health planning and resource allocation.")
  )
))
