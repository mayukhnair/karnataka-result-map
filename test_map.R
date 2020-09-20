install.packages('rgdal')
install.packages('leaflet')
install.packages('RColorBrewer')
install.packages('data.table')


library(rgdal)
dsn = "/cloud/project/Karnataka-maps"
lyr = "Karnataka_Assembly_con"
shape <- readOGR(dsn=dsn,layer=lyr)

View(shape)
plot(shape)

library(data.table)
data <- fread("constituencywins.csv")
ge16_winners <- subset(data,Year==2018 & Position == 1)
shape_16_win <- merge(x=shape,y=ge16_winners,by.x=c("ASSEMBLY","ASSEMBLY_1"),by.y=c("Constituency_No","Constituency_Name"),all.x=T)

library(leaflet)
base <- leaflet(shape_16_win)
base <- addTiles(base)
base <- addPolygons(base,popup= ~ASSEMBLY_1)

library(RColorBrewer)
pal <- colorFactor(c('#e41a1c','#377eb8','#4daf4a','#984ea3','#ff7f00','#ffff33'), shape_16_win$Party)
pop_disp <- paste("<b>Constituency:",shape_16_win$ASSEMBLY_1,"</b><br>","Winner: ",shape_16_win$Party,"<br>","Candidate: ",shape_16_win$Candidate,"<br>","Vote share: ",shape_16_win$Vote_Share_Percentage,"%")
base <- addPolygons(base, fillColor = ~pal(Party),weight = 1,opacity = 1,color = "white",dashArray = "3",fillOpacity = 0.7, popup = pop_disp)
base <- addLegend(base,position = "topright",pal = pal,values = ~Party,title = "Winning Party")
base
