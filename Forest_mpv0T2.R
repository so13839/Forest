library(readr)
library(shiny)
library(leaflet)

tree_data <- read.csv("data_mpv0.csv")
# Sample data for demonstration purposes
#tree_data <- data.frame(
#  date =c("12/1/2022","11/08/2022","05/03/2023"),
# lat = c(-1.2921, -1.2923, -1.2932), 
#  long = c(36.8219, 36.8206, 36.8215), 
#  trees_planted = c(100, 150, 200),
# trees_died =c(20,150,56),
#  ward = c("Lembus", "Tenges", "Saimo/Soi"),
# sub_county = c("Baringo Central", "Mogotio", "Bomet East"),
#  county = c("Baringo", "Bungoma", "Busia")
#)

# Define UI
ui <- fluidPage(
  tags$div(
    style = "text-align: align;",
    tags$h3("Green Mapping Kenya: Empowering Kenya's Reforestation with Real-time GIS Monitoring"),
    tags$p("The National Tree Planting Campaign plan to increase the country's tree cover from 12.13% to 30% within the next decade by planting 15 billion trees across approximately 10.6 million hectares of land. This initiative underscores Kenya's commitment to environmental sustainability through afforestation and reforestation."),
    tags$p("ResilienceAg! proposes to develop a real-time interactive Geographical Information System (GIS) dashboard that will aid in tracking tree planting and survival rates, thus strengthening the effectiveness of Kenya's ambitious reforestation program through informed decision-making."),
    tags$p("We will start at a Ward level and proceed onward from there."),
    tags$h4("Advantages of the GIS Interactive dashboard"),
    tags$ol(
      tags$li("The GIS dashboard offers real-time data for closely monitoring tree planting progress and survival rates, aiding in evaluating the reforestation program's effectiveness."),
      tags$li("Data analysis from the dashboard enables informed decisions to address areas with low tree survival rates through targeted interventions."),
      tags$li("The GIS dashboard engages and educates local communities, fostering a sense of responsibility and ownership in reforestation efforts."),
      tags$li("It optimizes resource allocation by directing resources to areas where they are most needed, enhancing the overall efficiency of the reforestation program."),
      tags$li("The dashboard promotes transparency and accountability by providing open access to data, building trust among stakeholders and holding authorities accountable."),
      tags$li("Historical data from the GIS dashboard aids in long-term planning for sustainable forestry management, helping achieve and maintain tree cover goals beyond the campaign's immediate objectives.")
    )
  ),
  selectInput("ward_selector", "Select Ward", choices = unique(tree_data$ward)),
  leafletOutput("map")
)

# Define server logic
server <- function(input, output) {
  output$map <- renderLeaflet({
    selected_ward_data <- tree_data[tree_data$ward == input$ward_selector, ]
    
    leaflet() %>%
      addTiles() %>%
      setView(lng = selected_ward_data$long[1], lat = selected_ward_data$lat[1], zoom = 10) %>%
      addCircleMarkers(
        data = selected_ward_data, 
        lng = ~long, 
        lat = ~lat, 
        radius = ~trees_planted / 2000,
        label = ~as.character(trees_planted),
        color = "green",
        fill = TRUE,
        fillOpacity = 0.6
      ) %>%
      addPopups(
        selected_ward_data$long, selected_ward_data$lat,
        paste("Ward:", selected_ward_data$ward, "<br>",
              "Sub County:", selected_ward_data$sub_county, "<br>",
              "County:", selected_ward_data$county, "<br>",
              "Date Planted:", selected_ward_data$date, "<br>",
              "Trees Planted:", selected_ward_data$trees_planted, "<br>",
              "Trees Died:", selected_ward_data$trees_died)
      )
  })
}

# Run the application
shinyApp(ui = ui, server = server)
