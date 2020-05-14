
library(shiny)
library(dplyr)
library(ggplot2)

shinyServer(function(input, output) {
    # input must contain
        # sliderconc: the ambient CO2 concentration
        # slidertype: the type of plant: "Quebec" or "Mississippi"
        # slidertreat: the treatment used: "chilled" or unchilled
        # show/hide linear reg model
        # show/hide quadratic reg model
        # show/hide polynomial model
    
    # output contains
        # myplot: with data points and at most 3 reg model curves
        # linpred: the prediction of lin reg model for sliderconc
        # quadpred: prediction of quadratic reg model for sliderconc
        # polpred: prediction of the polynomial model for sliderconc
        # explained: an explanation/documentation of how the app works
    
    # CO2 dataset
    data("CO2")
    
    # subset according to input
    dat <- reactive({
        CO2 %>% filter(Type == input$slidertype,
                       Treatment == input$slidertreat)
    })
    
    # linear reg model
    fit1 <- reactive({
        lm(uptake ~ conc, data=dat())
    })
    # and its prediction
    linpred <- reactive({
        predict(fit1(), data.frame(conc=input$sliderconc))
    })
    
    # quadratic reg model
    fit2 <- reactive({
        lm(uptake ~ I(conc) + I(conc^2), data=dat())
    })
    # and its prediction
    quadpred <- reactive({
        predict(fit2(), data.frame(conc=input$sliderconc))
    })
    
    # polynomial reg model
    fit3 <- reactive({
        loess(uptake ~ conc, data=dat())
    })
    # and its prediction
    polpred <- reactive({
        predict(fit3(), data.frame(conc=input$sliderconc))
    })
    
    output$myplot <- renderPlot({
        
        g <- ggplot(dat(), aes(x=conc, y=uptake)) + geom_point() + 
            xlab("ambient CO2 concentration (mL/L)") +
            ylab("CO2 uptake (umol/m^2 sec)")
        
        if(input$Showlinreg){
            g <- g + geom_smooth(method = "lm", formula = y ~ x, color = "black") +
                geom_point(data=data.frame(conc=input$sliderconc, uptake=linpred()),
                           color="black", size=4)
        }
        
        if(input$Showquadreg){
            g <- g + geom_smooth(method = "lm", formula = y ~ I(x) + I(x^2), color = "blue") +
                geom_point(data=data.frame(conc=input$sliderconc, uptake=quadpred()),
                           color="blue", size=4)
        }
        
        if(input$Showpolreg){
            g <- g + geom_smooth(method = "loess", formula = y ~ x, color="red") +
                geom_point(data=data.frame(conc=input$sliderconc, uptake=polpred()),
                           color="red", size=4)
        }
        
        g
    })
    
    # output predictions
    output$linpred <- renderText({
        ifelse(input$Showlinreg,
               linpred(),
               "No prediction")
    })

    output$quadpred <- renderText({
        ifelse(input$Showquadreg,
               quadpred(),
               "No prediction")
    })
    
    output$polpred <- renderText({
        ifelse(input$Showpolreg,
               polpred(),
               "No prediction")
    })
    
    
    # documentation
    output$explained <- renderText({
        "This app uses the CO2 dataset from R's \"datasets\" package, which
        consists of many measurements of carbon dioxide's uptake by several
        plants of one of two types (Quebec or Mississippi) and subject to one
        of two treatments (chilled or nonchilled) in different ambient carbon
        dioxide concentrations."
    })
    
    output$explained2 <- renderText({
        "The sliders on the side panel allow the user to choose 
        1. the ambient carbon dioxide concentration,
        2. the type of plant you want to consider,
        3. the treatment the plant was subject to."
    })
    
    output$explained3 <- renderText({
        "This app predicts the plant's uptake of carbon dioxide for the ambient
        CO2 concentration, by three different methods:
        A. linear regression,
        B. quadratic regression,
        C. polynomial regression.
        The user can choose which of these models to use by ticking/unticking 
        the checkboxes on the side panel."
    })
    
    output$explained4 <- renderText({
        "The data and the prediction models are all plotted in a graph, and the
        predicted CO2 uptake for the ambient CO2 concentration the user chose
        can be viewed under the graph. So, go and test it on the \"Use the app\"
        tab and enjoy the app :)"
    })
    
})
