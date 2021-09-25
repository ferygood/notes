library(shiny)
library(shinythemes)
library(data.table)
library(RCurl)
library(randomForest)

# read data
weather <- read.csv("https://raw.githubusercontent.com/dataprofessor/data/master/weather-weka.csv")
str(weather)

# convert chr to factor for building model
weather$outlook <- factor(weather$outlook, levels = c("sunny", "overcast", "rainy"))
weather$play <- factor(weather$play, levels = c("no", "yes"))

# build model
model <- randomForest(
    play ~ .,
    data = weather,
    ntree = 500,
    mtry = 4,
    importance = TRUE)

# save model to RDS file
# saveRDS(model, "model.rds")

# read in RF model
# model <- readRDS("model.rds")

ui <- fluidPage(
    theme = shinytheme("spacelab"),

    # page header
    headerPanel("Play Golf Model"),

    # input values
    sidebarPanel(
        HTML("<h3>Input parameters</h3>"),

        selectInput(
            "outlook",
            label = "Outlook:",
            choices = list(
                "Sunny" = "sunny",
                "Overcast" = "overcast",
                "Rainy" = "rainy"
            ),
            selected = "Rainy"
        ),

        sliderInput(
            "temperature",
            label = "Temperature:",
            min = 64,
            max = 86,
            value = 70
        ),

        sliderInput(
            "humidity",
            label = "Humidity:",
            min = 65,
            max = 96,
            value = 90
        ),
        selectInput(
            "windy",
            label = "Windy:",
            choices = list("Yes" = "TRUE",
                           "NO" = "FALSE"),
            selected = "TRUE"
        ),

        actionButton("submitbutton",
                     label = "Submit",
                     class = "btn btn-primary")
    ),

    mainPanel(
        tags$label(h3("Status/Output")),
        verbatimTextOutput("contents"),
        tableOutput("tabledata")
    )
)

server <- function(output, input, session){

    datasetInput <- reactive({
        df <- data.frame(
            row.names = c("outlook", "temperature", "humidity", "windy"),
            Value = c(
                input$outlook,
                input$temperature,
                input$humidity,
                input$windy
            ),
            stringsAsFactors = FALSE
        )
        df <- data.frame(t(df))
        df$outlook <- factor(df$outlook, levels = c("sunny", "overcast", "rainy"))
        Output <- data.frame(
            Prediction = predict(model, df),
            round(predict(model, df, type="prob"), 3)
        )
        return(Output)
    })

    # Status/Output Text Box
    output$contents <- renderPrint({
        if (input$submitbutton > 0) {
            isolate("Calculation complete.")
        } else {
            return("Server is ready for calculation.")
        }
    })

    # Prediction results table
    output$tabledata <- renderTable({
        if (input$submitbutton > 0){
            isolate(datasetInput())
        }
    })
}

shinyApp(ui = ui, server = server)
