# library("visNetwork")

load("people.RData")
load("connections.RData")


visNetwork(people, connections, width = "1000px", height = "600px", 
           main=list(text="Untold Murder",
                     style='font-family:Source Sans Pro, Helvetica, sans-serif;font-weight:bold;font-size:22px;text-align:left;'),
           submain=list(text="The Daniel Morgan murder case \n",
                     style='font-family:Source Sans Pro, Helvetica, sans-serif;font-style:italic;font-size:14px;text-align:left;')) %>%
  visEdges(smooth=TRUE) %>%
  visNodes(shapeProperties = list(useBorderWithImage = F)) %>%
  visOptions(highlightNearest = list(enabled = T, degree = 2, 
                                     hover = T, hideColor = 'rgba(200,200,200,0.5)',
                                     labelOnly=FALSE),
             nodesIdSelection=TRUE) %>%
  visInteraction(hover=TRUE, zoomView = TRUE,
                 navigationButtons = TRUE,
                 tooltipStyle = 'position: fixed;visibility:hidden;padding: 5px;
                font-family: sans-serif;font-size:16px;
                font-color:#000000;background-color: #e3fafa;
                -moz-border-radius: 3px;-webkit-border-radius: 3px;border-radius: 3px;
                 border: 0px solid #808074;box-shadow: 3px 3px 10px rgba(0, 0, 0, 0.2);
                 max-width:200px;overflow-wrap: normal') %>%
  visPhysics(solver = "forceAtlas2Based", 
             maxVelocity = 1000,
             minVelocity = 5,
             forceAtlas2Based = list(gravitationalConstant = -50),
             stabilization = TRUE) %>%
  addFontAwesome() %>%
  visLayout(randomSeed = 02143) %>%
  visSave(file = "untold-murder.html", selfcontained = TRUE)


