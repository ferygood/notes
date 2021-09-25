library(shiny)
# The second basic app for display a plot
# load airquality data
data("airquality")

ui <- fluidPage(titlePanel("Airquality Display"),
                sidebarLayout(sidebarPanel(
                    sliderInput(
                        inputId = "bins",
                        label = "Number of Bins:",
                        min = 1,
                        max = 50,
                        value = 30
                    )

                ),
                mainPanel(plotOutput(outputId = "distPlot"))))


server <- function(input, output) {
    output$distPlot <- renderPlot({
        x <- airquality$Ozone
        x <- na.omit(x)
        bins <- seq(min(x), max(x), length.out = input$bins + 1)
        hist(
            x,
            breaks = bins,
            col = "#75AADB",
            border = "black",
            xlab = "Ozone level",
            main = "Histogram of Ozone Level"
        )
    })
}

shinyApp(ui = ui, server = server)
