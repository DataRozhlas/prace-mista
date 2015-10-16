library(dplyr)

d <- read.csv2("data/mista_2015_10_14_multi.tsv")

PRACOVISTE_obce
MZDA_min
MZDA_max


#celkem volných míst
sum(d$celkemVm)

#rozdělení tabulky z nabídek na volná místa


#časová řada

library(dygraphs)
library(xts)


casovarada <- read.csv("data/volna-mista-casova-rada.csv", dec = ",")
casovarada$datum <- as.Date(casovarada$datum)

casovarada <- as.xts(casovarada$volnamista, casovarada$datum)

dygraph(casovarada, main="Volná pracovní místa v evidenci úřadů práce") %>%
  dySeries("V1", label = "volná místa", strokeWidth=2, color="#003366") %>%
  dyHighlight(highlightCircleSize = 4, hideOnMouseOut = FALSE) %>%
  dyAxis("x", valueFormatter="function (d) {return new Date(d).toLocaleDateString('cs-CZ', {year: 'numeric', month: 'short'});}") %>%
  dyAxis("y", label="volná místa v tisících", valueFormatter="function (d) {return d + ' tisíc';}") %>%
  dyOptions(axisLineWidth = 1.5, fillGraph = TRUE, drawGrid = FALSE)


lungDeaths <- cbind(mdeaths, fdeaths)
dygraph(lungDeaths)
lungDeaths$
