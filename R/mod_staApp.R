#' staApp UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_staApp_ui <- function(id){
  ns <- NS(id)
  tagList(
    sidebarPanel(


      tags$style(".well {background-color:grey; color: #FFFFFF;}"),
      HTML("<img src='www/cgiar3.png' width='42' vspace='10' hspace='10' height='46' align='top'>
                  <font size='5'>Single Trial Analysis</font>"),
      # div(tags$p( h4(strong("Single Trial Analysis")))),#, style = "color: #817e7e"
      hr(style = "border-top: 1px solid #4c4c4c;"),
      # input <- list(version2Sta=)
      selectInput(ns("version2Sta"), "Data QA version(s) to consider", choices = NULL, multiple = TRUE),
      selectInput(ns("genoUnitSta"), "Genetic evaluation unit(s)", choices = NULL, multiple = TRUE),
      tags$span(id = ns('geno_unit_holder'), style="color:orange",
                p("**If you have hybrid-crop data and plan to use 'mother' and 'father' information for GCA models please make sure you uploaded your Pedigree data (you can use the same Phenotype file if those columns are there)."),
      ),
      selectInput(ns("trait2Sta"), "Trait(s) to analyze", choices = NULL, multiple = TRUE),
      selectInput(ns("fixedTermSta2"), "Covariable(s)", choices = NULL, multiple = TRUE),
      hr(style = "border-top: 1px solid #4c4c4c;"),
      shinydashboard::box(width = 12, status = "success", background="green",solidHeader=TRUE,collapsible = TRUE, collapsed = TRUE, title = "Settings...",
                          selectInput(ns("genoAsFixedSta"),"Predictions",choices=list("BLUEs"=TRUE,"BLUPs"=FALSE),selected=TRUE),
                          numericInput(ns("maxitSta"),"Number of iterations",value=35),
                          selectInput(ns("verboseSta"),"Print logs",choices=list("Yes"=TRUE,"No"=FALSE),selected=FALSE)
      ),
      shinydashboard::box(width = 12, status = "success", background="green",solidHeader=TRUE,collapsible = TRUE, collapsed = TRUE, title = "Trait distributions (optional)...",
                          column(width = 12,DT::DTOutput(ns("traitDistSta")), style = "height:400px; overflow-y: scroll;overflow-x: scroll;")
      ),
      hr(style = "border-top: 1px solid #4c4c4c;"),
      actionButton(ns("runSta"), "Run", icon = icon("play-circle")),
      hr(style = "border-top: 1px solid #4c4c4c;"),
      uiOutput(ns("qaQcStaInfo")),
      textOutput(ns("outSta"))
    ), # end sidebarpanel
    mainPanel(tabsetPanel(
      type = "tabs",

      tabPanel(p("Information", class="info-p"), icon = icon("book"),
               br(),
               shinydashboard::box(status="success",width = 12,
                                   solidHeader = TRUE,
                                   column(width=12,   style = "height:800px; overflow-y: scroll;overflow-x: scroll;",
                                          h2(strong("Status:")),
                                          uiOutput(ns("warningMessage")),
                                          h2(strong("Details")),
                                          p("The genetic evaluation approach we use known as 'two-step' first analyze trait by trait and trial by trial
                                          to remove the spatial noise from experiments using experimental factors like blocking and spatial coordinates.
                                          Each trial is one level of the environment
                              column (defined when the user matches the expected columns to columns present in the initial phenotypic input file).
                              Genotype is fitted as both, fixed and random. The user defines which should be returned in the predictions table.
                              By default genotype (designation column) predictions and their standard errors are returned.
                                The way the options are used is the following:"),
                                          img(src = "www/sta.png", height = 200, width = 300), # add an image
                                          p(strong("Fixed effects.-"),"Columns to be fitted as fixed effects in each trial."),
                                          p(strong("Traits to analyze.-")," Traits to be analyzed. If no design factors can be fitted simple means are taken."),
                                          p(strong("Number of iterations.-")," Maximum number of restricted maximum likelihood iterations to be run for each trial-trait combination."),
                                          p(strong("Note.-")," A design-agnostic spatial design is carried. That means, all the spatial-related factors will be fitted if pertinent.
                                For example, if a trial has rowcoord information it will be fitted, if not it will be ignored. A two-dimensional spline kernel is only
                                fitted when the trial size exceeds 5 rows and 5 columns. In addition the following rules are followed: 1) Rows or columns are fitted if
                                you have equal or more than 3 levels, 2) Reps are fitted if you have equal or more than 2 levels, 3) Block (Sub-block) are fitted if you
                                have equal or more than 4 levels. "),
                                          h2(strong("References:")),
                                          p("Velazco, J. G., Rodriguez-Alvarez, M. X., Boer, M. P., Jordan, D. R., Eilers, P. H., Malosetti, M., & Van Eeuwijk, F. A. (2017).
                                Modelling spatial trends in sorghum breeding field trials using a two-dimensional P-spline mixed model. Theoretical and Applied
                                Genetics, 130, 1375-1392."),
                                          p("Rodriguez-Alvarez, M. X., Boer, M. P., van Eeuwijk, F. A., & Eilers, P. H. (2018). Correcting for spatial heterogeneity in plant
                                breeding experiments with P-splines. Spatial Statistics, 23, 52-71."),
                                          h2(strong("Software used:")),
                                          p("R Core Team (2021). R: A language and environment for statistical computing. R Foundation for Statistical Computing,
                                Vienna, Austria. URL https://www.R-project.org/."),
                                          p("Boer M, van Rossum B (2022). _LMMsolver: Linear Mixed Model Solver_. R package version 1.0.4.9000.")


                                   )
               )
      ),
      tabPanel(p("Input",class = "input-p"), icon = icon("arrow-right-to-bracket"),
               tabsetPanel(
                 tabPanel("QA-modeling", icon = icon("table"),
                          br(),
                          shinydashboard::box(status="success",width = 12,
                                              solidHeader = TRUE,
                                              column(width=12,DT::DTOutput(ns("statusSta")),style = "height:800px; overflow-y: scroll;overflow-x: scroll;")
                          )
                 ),
                 tabPanel("Effects", icon = icon("table"),
                          br(),
                          shinydashboard::box(status="success",width = 12,
                                              solidHeader = TRUE,
                                              selectInput(ns("feature"), "Check units by:", choices = NULL, multiple = FALSE),
                                              column(width=12,DT::DTOutput(ns("summariesSta")),style = "height:800px; overflow-y: scroll;overflow-x: scroll;")
                          )
                 ),
                 tabPanel("Design", icon = icon("table"),
                          br(),
                          shinydashboard::box(status="success",width = 12,
                                              solidHeader = TRUE,
                                              column(width = 12,DT::dataTableOutput(ns("dtFieldTraC")), style = "height:500px; overflow-y: scroll;overflow-x: scroll;"),
                          )
                 ),
                 tabPanel("Trait distribution", icon = icon("magnifying-glass-chart"),
                          br(),
                          shinydashboard::box(status="success",width = 12,
                                              solidHeader = TRUE,
                                              selectInput(ns("trait3Sta"), "Trait to visualize", choices = NULL, multiple = FALSE),
                                              plotly::plotlyOutput(ns("plotPredictionsCleanOut"))
                          )
                 ),
                 tabPanel("Data", icon = icon("table"),
                          br(),
                          shinydashboard::box(status="success",width = 12,
                                              solidHeader = TRUE,
                                              column(width=12,DT::DTOutput(ns("phenoSta")),style = "height:800px; overflow-y: scroll;overflow-x: scroll;")
                          )
                 )
               )# of of tabsetPanel
      ),
      tabPanel(p("Output",class = "output-p"), icon = icon("arrow-right-from-bracket"),
               tabsetPanel(
                 tabPanel("Predictions", icon = icon("table"),
                          br(),
                          shinydashboard::box(status="success",width = 12,
                                              solidHeader = TRUE,
                                              column(width=12,DT::DTOutput(ns("predictionsSta")),style = "height:800px; overflow-y: scroll;overflow-x: scroll;")
                          )
                 ),
                 tabPanel("Metrics", icon = icon("table"),
                          br(),
                          shinydashboard::box(status="success",width = 12,
                                              solidHeader = TRUE,
                                              column(width=12,br(),DT::DTOutput(ns("metricsSta")),style = "height:800px; overflow-y: scroll;overflow-x: scroll;")
                          )
                 ),
                 tabPanel("Modeling", icon = icon("table"),
                          br(),
                          shinydashboard::box(status="success",width = 12,
                                              solidHeader = TRUE,
                                              column(width=12,br(),DT::DTOutput(ns("modelingSta")),style = "height:800px; overflow-y: scroll;overflow-x: scroll;")
                          )
                 ),
                 tabPanel("Report", icon = icon("file-image"),
                          br(),
                          div(tags$p("Please download the report below:") ),
                          downloadButton(ns("downloadReportSta"), "Download report"),
                          br(),
                          uiOutput(ns('reportSta')),
                 )
               ) # of of tabsetPanel
      )# end of output panel


    )) # end mainpanel

  )
}

#' staApp Server Functions
#'
#' @noRd
mod_staApp_server <- function(id,data){
  moduleServer( id, function(input, output, session){
    ns <- session$ns

    ############################################################################ clear the console
    hideAll <- reactiveValues(clearAll = TRUE)
    observeEvent(data(), {
      hideAll$clearAll <- TRUE
    })
    # data = reactive({
    #   load("~/Documents/bioflow/dataStr0.RData")
    #   data <- res
    #   return(data)
    # })
    ############################################################################
    observeEvent(
      c(data(),input$version2Sta,input$genoUnitSta),
      if(length(input$genoUnitSta) > 0){ # added
        if ('mother' %in% input$genoUnitSta | 'father' %in% input$genoUnitSta | is.null(input$genoUnitSta) ){
          golem::invoke_js('showid', ns('geno_unit_holder'))
        }else { #
          golem::invoke_js('hideid', ns('geno_unit_holder'))
        }
      }else{golem::invoke_js('hideid', ns('geno_unit_holder'))}
    )
    # warning message
    output$warningMessage <- renderUI(
      if(is.null(data())){
        HTML( as.character(div(style="color: red; font-size: 20px;", "Please retrieve or load your phenotypic data using the 'Data Retrieval' tab.")) )
      }else{ # data is there
        mappedColumns <- length(which(c("environment","designation","trait") %in% data()$metadata$pheno$parameter))
        if(mappedColumns == 3){
          if("qaRaw" %in% data()$status$module){
            HTML( as.character(div(style="color: green; font-size: 20px;", "Data is complete, please proceed to perform the STA inspecting the other tabs.")) )
          }else{HTML( as.character(div(style="color: red; font-size: 20px;", "Please identify outliers in the raw data before performing an STA.")) ) }
        }else{HTML( as.character(div(style="color: red; font-size: 20px;", "Please make sure that the columns: 'environment', 'designation' and \n at least one trait have been mapped using the 'Data Retrieval' tab.")) )}
      }
    )
    # QA versions to use
    observeEvent(c(data()), {
      req(data())
      dtMta <- data()
      dtMta <- dtMta$status
      dtMta <- dtMta[which(dtMta$module %in% c("qaRaw","qaFilter")),]
      traitsMta <- unique(dtMta$analysisId)
      if(length(traitsMta) > 0){names(traitsMta) <- as.POSIXct(traitsMta, origin="1970-01-01", tz="GMT")}
      updateSelectInput(session, "version2Sta", choices = traitsMta)
    })
    # genetic evaluation unit
    observe({
      req(data())
      genetic.evaluation <- c("designation", "mother","father")
      updateSelectInput(session, "genoUnitSta",choices = genetic.evaluation)
    })
    # traits
    observeEvent(c(data(),input$version2Sta,input$genoUnitSta), {
      req(data())
      req(input$version2Sta)
      req(input$genoUnitSta)
      dtSta <- data()
      dtSta <- dtSta$modifications$pheno
      dtSta <- dtSta[which(dtSta$analysisId %in% input$version2Sta),] # only traits that have been QA
      traitsSta <- unique(dtSta$trait)
      updateSelectInput(session, "trait2Sta", choices = traitsSta)
    })
    # fixed effect covariates
    observeEvent(c(data(),input$version2Sta,input$genoUnitSta, input$trait2Sta), {
      req(data())
      req(input$version2Sta)
      req(input$genoUnitSta)
      req(input$trait2Sta)
      dtSta <- data()
      dtSta <- dtSta$modifications$pheno # only traits that have been QA
      dtSta <- dtSta[which(dtSta$analysisId %in% input$version2Sta),]
      traitsSta <- unique(dtSta$trait)
      '%!in%' <- function(x,y)!('%in%'(x,y))
      updateSelectInput(session, "fixedTermSta2", choices = traitsSta[traitsSta%!in%input$trait2Sta])
    })
    # reactive table for trait family distributions
    dtDistTrait = reactive({
      req(data())
      req(input$trait2Sta)
      dtSta <- data()
      dtSta <- dtSta$data$pheno
      traitNames = input$trait2Sta
      mm = matrix(0,nrow = 8, ncol = length(traitNames));
      rownames(mm) <- c(
        "gaussian(link = 'identity')",
        "quasi(link = 'identity', variance = 'constant')",
        "binomial(link = 'logit')",
        "Gamma(link = 'inverse')",
        "inverse.gaussian(link = '1/mu^2')",
        "poisson(link = 'log')",
        "quasibinomial(link = 'logit')",
        "quasipoisson(link = 'log')"
      );
      colnames(mm) <- traitNames
      dtProvTable = as.data.frame(mm);  colnames(dtProvTable) <- traitNames
      return(dtProvTable)
    })
    xx = reactiveValues(df = NULL)
    observe({
      df <- dtDistTrait()
      xx$df <- df
    })
    output$traitDistSta = DT::renderDT(xx$df,
                                       selection = 'none',
                                       editable = TRUE,
                                       options = list(paging=FALSE,
                                                      searching=FALSE,
                                                      initComplete = I("function(settings, json) {alert('Done.');}")
                                       )
    )

    ##

    ##

    proxy = DT::dataTableProxy('traitDistSta')

    observeEvent(input$traitDistSta_cell_edit, {
      info = input$traitDistSta_cell_edit
      utils::str(info)
      i = info$row
      j = info$col
      v = info$value
      xx$df[i, j] <- isolate(DT::coerceValue(v, xx$df[i, j]))
    })
    ## render the data to be analyzed
    observeEvent(data(),{
      if(sum(data()$status$module %in% "qaRaw") != 0) {
        ## render status
        output$statusSta <-  DT::renderDT({
          req(data())
          req(input$version2Sta)
          dtSta <- data() # dtSta<- result
          ### change column names for mapping
          paramsPheno <- data()$modeling
          paramsPheno <- paramsPheno[which(paramsPheno$analysisId %in% input$version2Sta),, drop=FALSE]
          paramsPheno$analysisId <- as.POSIXct(paramsPheno$analysisId, origin="1970-01-01", tz="GMT")
          DT::datatable(paramsPheno, extensions = 'Buttons',
                        options = list(dom = 'Blfrtip',scrollX = TRUE,buttons = c('copy', 'csv', 'excel', 'pdf', 'print'),
                                       lengthMenu = list(c(10,20,50,-1), c(10,20,50,'All')))
          )
        })
        ## render summaries
        output$summariesSta <-  DT::renderDT({
          req(data())
          req(input$version2Sta)
          req(input$feature)
          dtSta <- data() # dtSta<- result
          ### change column names for mapping
          paramsPheno <- data()$metadata$pheno
          paramsPheno <- paramsPheno[which(paramsPheno$parameter != "trait"),]
          colnames(dtSta$data$pheno) <- cgiarBase::replaceValues(colnames(dtSta$data$pheno), Search = paramsPheno$value, Replace = paramsPheno$parameter )
          paramsPed <- data()$metadata$pedigree
          colnames(dtSta$data$pedigree) <- cgiarBase::replaceValues(colnames(dtSta$data$pedigree), Search = paramsPed$value, Replace = paramsPed$parameter )
          ###
          dtSta <- merge(dtSta$data$pheno, dtSta$data$pedigree, by="designation") # merge mother and father info in the pheno data frame
          dtStaList <- split(dtSta, dtSta[,input$feature]) # split info by environment
          dtStaListRes <- list()
          for(i in 1:length(dtStaList)){
            dtStaListRes[[i]] <- as.data.frame(as.table(apply(dtStaList[[i]][,c("designation","mother","father")],2, function(x){length(na.omit(unique(x)))})))
            dtStaListRes[[i]][,input$feature] <- names(dtStaList)[i]
          }
          dtSta <- do.call(rbind, dtStaListRes)
          colnames(dtSta)[1:2] <- c("geneticUnit", "numberOfUnits")
          dtSta <- dtSta[with(dtSta, order(geneticUnit)), ]; rownames(dtSta) <- NULL
          DT::datatable(dtSta, extensions = 'Buttons',
                        options = list(dom = 'Blfrtip',scrollX = TRUE,buttons = c('copy', 'csv', 'excel', 'pdf', 'print'),
                                       lengthMenu = list(c(10,20,50,-1), c(10,20,50,'All')))
          )
        })
        ## render designs
        output$dtFieldTraC <-  DT::renderDT({
          req(data())
          req(input$version2Sta)
          object <- data()
          dtProv = object$data$pheno
          paramsPheno <- object$metadata$pheno
          if(!is.null(paramsPheno)){
            paramsPheno <- paramsPheno[which(paramsPheno$parameter != "trait"),]
            colnames(dtProv) <- cgiarBase::replaceValues(colnames(dtProv), Search = paramsPheno$value, Replace = paramsPheno$parameter )
            dtProvNames <- c("row","col","rep","iBlock")
            envCol <- paramsPheno[which(paramsPheno$parameter == "environment"),"value"]
            if(length(envCol) > 0){
              fieldNames <- as.character(unique(dtProv[,"environment"]))
              spD <- split(dtProv,dtProv[,"environment"])
              presentFactors <- paramsPheno$parameter[which(paramsPheno$parameter %in% dtProvNames)]
              presentFactorsPerField <- lapply(spD, function(x){
                apply(x[,presentFactors, drop=FALSE], 2, function(y){length(unique(y))})
              })
              presentFactorsPerField <- do.call(rbind, presentFactorsPerField)
              dtProvTable = as.data.frame(presentFactorsPerField);  rownames(dtProvTable) <- fieldNames
              DT::datatable(dtProvTable, extensions = 'Buttons',
                            options = list(dom = 'Blfrtip',scrollX = TRUE,buttons = c('copy', 'csv', 'excel', 'pdf', 'print'),
                                           lengthMenu = list(c(10,20,50,-1), c(10,20,50,'All')))
              )
            }
          }
        })
        ## render plot of trait distribution
        observeEvent(c(data(),input$version2Sta), { # update trait
          req(data())
          req(input$version2Sta)
          dtSta <- data()$metadata$pheno$parameter
          traitsSta <- setdiff(dtSta, c("trait","designation"))
          updateSelectInput(session, "feature", choices = traitsSta)
        })
        observeEvent(c(data(),input$version2Sta), { # update trait
          req(data())
          req(input$version2Sta)
          dtSta <- data()
          dtSta <- dtSta$modifications$pheno
          dtSta <- dtSta[which(dtSta$analysisId %in% input$version2Sta),] # only traits that have been QA
          traitsSta <- unique(dtSta$trait)
          updateSelectInput(session, "trait3Sta", choices = traitsSta)
        })
        output$plotPredictionsCleanOut <- plotly::renderPlotly({ # update plot
          req(data())
          req(input$version2Sta)
          req(input$trait3Sta)
          mydata <- data()$data$pheno
          ### change column names for mapping
          paramsPheno <- data()$metadata$pheno
          paramsPheno <- paramsPheno[which(paramsPheno$parameter != "trait"),]
          colnames(mydata) <- cgiarBase::replaceValues(colnames(mydata), Search = paramsPheno$value, Replace = paramsPheno$parameter )
          ###
          mappedColumns <- length(which(c("environment","designation","trait") %in% data()$metadata$pheno$parameter))
          if(mappedColumns == 3){ # all required columns are present
            mydata$rowindex <- 1:nrow(mydata)
            mydata[, "environment"] <- as.factor(mydata[, "environment"]);mydata[, "designation"] <- as.factor(mydata[, "designation"])
            mo <- data()$modifications$pheno
            mo <- mo[which(mo[,"trait"] %in% input$trait3Sta),]
            mydata$color <- 1
            if(nrow(mo) > 0){mydata$color[which(mydata$rowindex %in% unique(mo$row))]=2}
            mydata$color <- as.factor(mydata$color)
            res <- plotly::plot_ly(y = mydata[,input$trait3Sta], type = "box", boxpoints = "all", jitter = 0.3,color=mydata[,"color"],
                                   x = mydata[,"environment"], text=mydata[,"designation"], pointpos = -1.8)
            res = res %>% plotly::layout(showlegend = FALSE); res
          }else{}
        })
        ## render raw data
        output$phenoSta <-  DT::renderDT({
          req(data())
          dtSta <- data()
          req(input$version2Sta)
          dtSta <- dtSta$data$pheno
          ### change column names for mapping
          paramsPheno <- data()$metadata$pheno
          paramsPheno <- paramsPheno[which(paramsPheno$parameter != "trait"),]
          colnames(dtSta) <- cgiarBase::replaceValues(colnames(dtSta), Search = paramsPheno$value, Replace = paramsPheno$parameter )
          ###
          traitTypes <- unlist(lapply(dtSta,class))
          numeric.output <- names(traitTypes)[which(traitTypes %in% "numeric")]
          DT::formatRound(DT::datatable(dtSta, extensions = 'Buttons',
                                        options = list(dom = 'Blfrtip',scrollX = TRUE,buttons = c('copy', 'csv', 'excel', 'pdf', 'print'),
                                                       lengthMenu = list(c(10,20,50,-1), c(10,20,50,'All')))
          ), numeric.output)
        })
      } else {
        output$summariesSta <- DT::renderDT({DT::datatable(NULL)})
        output$phenoSta <- DT::renderDT({DT::datatable(NULL)})
        output$plotPredictionsCleanOut <- plotly::renderPlotly({NULL})
      }
    })
    ## render result of "run" button click
    outSta <- eventReactive(input$runSta, {
      req(data())
      req(input$version2Sta)
      req(input$trait2Sta)
      req(input$genoUnitSta)
      req(input$genoAsFixedSta)
      req(input$verboseSta)
      req(input$maxitSta)
      shinybusy::show_modal_spinner('fading-circle', text = 'Processing...')
      dtSta <- data()
      myFamily = apply(xx$df,2,function(y){rownames(xx$df)[which(y > 0)[1]]})
      dontHaveDist <- which(is.na(myFamily))
      if(length(dontHaveDist) > 0){myFamily[dontHaveDist] <- "gaussian(link = 'identity')"}

      # run the modeling, but before test if qa/qc done
      if(sum(dtSta$status$module %in% "qaRaw") == 0) {
        output$qaQcStaInfo <- renderUI({
          if (hideAll$clearAll)
            return()
          else
            req(dtSta)
          HTML(as.character(div(style="color: brown;",
                                "Please perform QA/QC before conducting a Single-Trial Analysis."))
          )
        })
      } else {
        output$qaQcStaInfo <- renderUI({return(NULL)})
        # save(dtSta, file = "./R/outputs/resultSta.RData")
        result <- try(cgiarPipeline::staLMM(phenoDTfile = dtSta, analysisId=input$version2Sta,
                                            trait=input$trait2Sta, traitFamily = myFamily,
                                            fixedTerm = input$fixedTermSta2,
                                            returnFixedGeno=input$genoAsFixedSta, genoUnit = input$genoUnitSta,
                                            verbose = input$verboseSta, maxit = input$maxitSta),
                      silent=TRUE
        )
        if(!inherits(result,"try-error")) {
          data(result) # update data with results
          # save(result, file = "./R/outputs/resultSta.RData")
          cat(paste("Single-trial analysis step with id:",as.POSIXct(result$status$analysisId[length(result$status$analysisId)], origin="1970-01-01", tz="GMT"),"saved."))
        }else{
          cat(paste("Analysis failed with the following error message: \n\n",result[[1]]))
        }
      }
      shinybusy::remove_modal_spinner()

      if(sum(dtSta$status$module %in% "qaRaw") != 0) {

        output$predictionsSta <-  DT::renderDT({
          if(!inherits(result,"try-error") ){
            # if ( hideAll$clearAll){
            #   return()
            # }else{
            predictions <- result$predictions
            predictions <- predictions[predictions$module=="sta",]
            predictions$analysisId <- as.numeric(predictions$analysisId)
            predictions <- predictions[!is.na(predictions$analysisId),]
            current.predictions <- predictions[predictions$analysisId==max(predictions$analysisId),]
            current.predictions <- subset(current.predictions, select = -c(module,analysisId))
            numeric.output <- c("predictedValue", "stdError", "reliability")
            DT::formatRound(DT::datatable(current.predictions, extensions = 'Buttons',
                                          options = list(dom = 'Blfrtip',scrollX = TRUE,buttons = c('copy', 'csv', 'excel', 'pdf', 'print'),
                                                         lengthMenu = list(c(10,20,50,-1), c(10,20,50,'All')))
            ), numeric.output)
            # }
          }
        })

        output$metricsSta <-  DT::renderDT({
          if(!inherits(result,"try-error") ){
            # if ( hideAll$clearAll){
            #   return()
            # }else{
            metrics <- result$metrics
            metrics <- metrics[metrics$module=="sta",]
            metrics$analysisId <- as.numeric(metrics$analysisId)
            metrics <- metrics[!is.na(metrics$analysisId),]
            current.metrics <- metrics[metrics$analysisId==max(metrics$analysisId),]
            current.metrics <- subset(current.metrics, select = -c(module,analysisId))
            numeric.output <- c("value", "stdError")
            DT::formatRound(DT::datatable(current.metrics, extensions = 'Buttons',
                                          options = list(dom = 'Blfrtip',scrollX = TRUE,buttons = c('copy', 'csv', 'excel', 'pdf', 'print'),
                                                         lengthMenu = list(c(10,20,50,-1), c(10,20,50,'All')))
            ), numeric.output)
            # }
          }
        })

        output$modelingSta <-  DT::renderDT({
          if(!inherits(result,"try-error") ){
            # if ( hideAll$clearAll){
            #   return()
            # }else{
            modeling <- result$modeling
            modeling <- modeling[modeling$module=="sta",]
            modeling$analysisId <- as.numeric(modeling$analysisId)
            modeling <- modeling[!is.na(modeling$analysisId),]
            current.modeling <- modeling[modeling$analysisId==max(modeling$analysisId),]
            current.modeling <- subset(current.modeling, select = -c(module,analysisId))
            # current.modeling$analysisId <- as.POSIXct(current.modeling$analysisId, origin="1970-01-01", tz="GMT")
            DT::datatable(current.modeling, extensions = 'Buttons',
                          options = list(dom = 'Blfrtip',scrollX = TRUE,buttons = c('copy', 'csv', 'excel', 'pdf', 'print'),
                                         lengthMenu = list(c(10,20,50,-1), c(10,20,50,'All')))
            )
            # }
          }
        })
        ## report
        output$reportSta <- renderUI({
          HTML(markdown::markdownToHTML(knitr::knit(system.file("rmd","reportSta.Rmd",package="bioflow"), quiet = TRUE), fragment.only=TRUE))
        })

        output$downloadReportSta <- downloadHandler(
          filename = function() {
            paste('my-report', sep = '.', switch(
              "HTML", PDF = 'pdf', HTML = 'html', Word = 'docx'
            ))
          },
          content = function(file) {
            src <- normalizePath(system.file("rmd","reportSta.Rmd",package="bioflow"))
            src2 <- normalizePath('data/resultSta.RData')

            # temporarily switch to the temp dir, in case you do not have write
            # permission to the current working directory
            owd <- setwd(tempdir())
            on.exit(setwd(owd))
            file.copy(src, 'report.Rmd', overwrite = TRUE)
            file.copy(src2, 'resultSta.RData', overwrite = TRUE)
            out <- rmarkdown::render('report.Rmd', params = list(toDownload=TRUE),switch(
              "HTML",
              HTML = rmarkdown::html_document()
            ))
            file.rename(out, file)
          }
        )

      } else {
        output$predictionsSta <- DT::renderDT({DT::datatable(NULL)})
        output$metricsSta <- DT::renderDT({DT::datatable(NULL)})
        output$modelingSta <- DT::renderDT({DT::datatable(NULL)})
      }

      hideAll$clearAll <- FALSE

    }) ## end eventReactive

    output$outSta <- renderPrint({
      outSta()
    })



  }) ## end moduleserver
}

## To be copied in the UI
# mod_staApp_ui("staApp_1")

## To be copied in the server
# mod_staApp_server("staApp_1")
