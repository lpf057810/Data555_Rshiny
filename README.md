# Obesity Risk Analysis in Georgia (RShiny Dashboard)

This interactive dashboard investigates the geospatial and behavioral risk factors contributing to obesity across Georgia counties. By visualizing regional obesity risk, category-specific predictors, and model performance, this dashboard supports the development of targeted public health strategies.

## Features

- **Feature Distribution**  
  Visualizes the distribution of predictor variables (e.g., insufficient sleep, low income, walkability) and their association with obesity risk across counties. Users can filter by variable category.

- **Region Bias Map**  
  Displays model performance (R²) and obesity risk geographically using an interactive choropleth. Counties with poor model fit are excluded to focus analysis.

- **Dataset Info Tab**  
  Provides metadata including data source, study design, filtering, and variable descriptions.

---

##  Dataset Summary

- **Source**: `final_combined.csv` – merged behavioral, demographic, and environmental indicators.
- **Sample**: Georgia counties with model R² > 0.85.
- **Exclusions**: Cherokee, Henry, and Paulding counties.
- **Key Variables**: Obesity risk, sleep prevalence, income levels, walkability, access to exercise, demographics.
- **Collection**: Compiled from publicly available datasets for spatial risk modeling.

This dashboard provides insight into which behavioral and environmental factors most strongly influence obesity risk in different regions of Georgia. The findings can guide resource allocation and inform region-specific intervention strategies to improve population health.
