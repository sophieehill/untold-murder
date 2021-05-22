# library("visNetwork")

load("people.RData")
load("connections.RData")


visNetwork(people, connections, width = "1200px", height = "500px", 
           background = "black", border = "white",
           main=list(text="Untold Murder",
                     style='font-family:Source Sans Pro, Helvetica, sans-serif;font-weight:bold;font-size:36px;text-align:middle;color:white;'),
           submain=list(text="The Daniel Morgan murder case \n",
                     style='font-family:Source Sans Pro, Helvetica, sans-serif;font-style:italic;font-size:28px;text-align:middle;color:white;')) %>%
  visEdges(smooth=TRUE) %>%
  visNodes(
           font = list(color="#000000", size=20, strokeWidth=20),
           borderWidth = 2, brokenImage = "https://raw.githubusercontent.com/sophieehill/untold-murder/main/photos/broken_image.png",
           shadow=list(enabled=TRUE, color="#858885"), 
           shapeProperties = list(borderRadius=10, useBorderWithImage=T),
           color=list(background="#FFFFFF", border="#FFFFFF", highlight="#FF0000")
           ) %>%
  visOptions(highlightNearest = list(enabled = T, degree = 2, 
                                     hover = T,
                                     labelOnly=FALSE),
             nodesIdSelection=FALSE) %>%
  visInteraction(hover=TRUE, zoomView = TRUE,
                 navigationButtons = FALSE,
                 tooltipStyle = 'position: fixed;visibility:hidden;padding: 5px;
                font-family: sans-serif;font-size:16px;
                font-color:#000000;background-color: #FFFFFF;
                -moz-border-radius: 3px;-webkit-border-radius: 3px;border-radius: 3px;
                 border: 0px solid #808074;box-shadow: 3px 3px 10px rgba(0, 0, 0, 0.2);
                 max-width:200px;overflow-wrap: normal') %>%
  visPhysics(solver = "forceAtlas2Based", 
             maxVelocity = 1000,
             minVelocity = 5,
             forceAtlas2Based = list(gravitationalConstant = -80),
             stabilization = TRUE) %>%
  addFontAwesome() %>%
  visLayout(randomSeed = 02143) %>%
  visSave(file = "untold-murder.html", selfcontained = TRUE)


