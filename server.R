library(shiny)
library(ggplot2)
library(plotly)
library(dplyr)
library(sf)
library(leaflet)
library(htmltools)

shinyServer(function(input, output, session) {
  
  # Load and preprocess data
  dat <- read.csv("final_combined.csv")
  
  dat <- dat %>%
    filter(R.2 > 0.85, !County %in% c("Cherokee", "Henry", "Paulding")) %>%
    mutate(
      County = as.factor(County),
      Category = as.factor(Category),
      Variable = as.factor(Variable),
      Variable_jitter = as.numeric(factor(Variable)) + 0.35
    )
  
  # Render interactive boxplot + jitter plot with tooltips
  output$box_jitter_plot <- renderPlotly({
    
    p <- ggplot(dat, aes(x = County, y = Obesity.Risk, fill = Category)) +
      geom_boxplot(
        outlier.shape = NA,
        alpha = 0.5,
        width = 0.4,
        position = position_nudge(x = -0.7)
      ) +
      suppressWarnings(
        geom_jitter(
          aes(
            x = Variable_jitter,
            text = paste(
              "Variable(%):", Variable,
              "<br>Prevalence(%):", round(Value, 2),
              "<br>Obesity Risk(%):", round(Obesity.Risk, 2),
              "<br>Category:", Category
            )
          ),
          width = 0.1,
          size = 2,
          alpha = 0.9
        )
      ) +
      labs(
        title = "Exploratory Data Analysis: Feature Distribution",
        x = "County",
        y = "Obesity Risk (%)",
        fill = "Category"
      ) +
      theme_minimal()+
      theme(
        axis.text.x=element_text(angle=45,vjust=1)
      )
    
    ggplotly(p, tooltip = "text") %>%
      layout(
        hoverlabel = list(bgcolor = "white", font = list(size = 12)),
        title = list(text = "Exploratory Data Analysis: Feature Distribution", font = list(size = 16))
      )
  })
  
  output$takeaway1 <- renderUI({
    tags$ul(
      tags$li("Identifies the distribution of key predictor variables related to obesity risk across counties."),
      tags$li("Highlights how different factors (e.g., sleep, income) contribute to variations in obesity prevalence."),
      tags$li("Compares environmental, behavioral, and sociodemographic categories to detect key trends and patterns.")
    )
  })
  
  # Load shapefile for Georgia counties from local directory
  counties_us <- st_read("cb_2022_us_county_20m.shp", quiet = TRUE)
  ga_counties <- counties_us %>%
    filter(STATEFP == "13") %>%
    rename(County = NAME)
  
  # Render interactive leaflet map
  output$leaflet_map <- renderLeaflet({
    selected_counties <- ga_counties %>%
      filter(County %in% dat$County) %>%
      left_join(dat, by = "County") %>%
      filter(Variable == "Insufficient Sleep Prevalence")
    
    pal <- colorNumeric(palette = "YlOrRd", domain = selected_counties$R.2, na.color = "transparent")
    
    selected_counties$hover_text <- paste0(
      "<strong>County:</strong> ", selected_counties$County, "<br>",
      "<strong>Obesity Risk(%):</strong> ", round(selected_counties$Obesity.Risk, 3), "<br>",
      "<strong>Insufficient Sleep Prevalence(%):</strong> ", selected_counties$Value, "<br>"
    )
    
    title <- tags$div(
      tags$h3("Region Bias", style = "text-align:center; font-weight:bold; background:white; padding:3px;")
    )
    
    leaflet(selected_counties) %>%
      addTiles() %>%
      addPolygons(
        fillColor = ~pal(R.2),
        fillOpacity = 0.7,
        color = ~pal(R.2),
        weight = 2,
        label = lapply(selected_counties$hover_text, HTML),
        highlight = highlightOptions(weight = 3, color = "blue", bringToFront = TRUE)
      ) %>%
      addLegend(pal = pal, values = selected_counties$R.2, title = "R² Value", position = "bottomright") %>%
      addControl(title, position = "topright") %>%
      addLabelOnlyMarkers(
        data = selected_counties,
        lng = st_coordinates(st_centroid(selected_counties))[, 1],
        lat = st_coordinates(st_centroid(selected_counties))[, 2],
        label = ~County,
        labelOptions = labelOptions(noHide = TRUE, textOnly = TRUE,
                                    style = list("color" = "black", "font-weight" = "bold"))
      )
  })
  
  output$takeaway2 <- renderUI({
    tags$ul(
      tags$li("Identifies counties where the model performs best and worst based on R² values, with darker shades indicating better model fit."),
      tags$li("Highlights regional variations in obesity risk, revealing spatial patterns across different counties."),
      tags$li("Illustrates the relationship between insufficient sleep prevalence and obesity risk, helping to understand how sleep behavior influences health outcomes.")
    )
  })
  
})
