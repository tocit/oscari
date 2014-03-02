require(XML)

#get data

filmy <- readHTMLTable("http://www.boxofficemojo.com/oscar/bestpichist.htm?view=bymovie&p=.htm", header=T, which=5)

write.csv(filmy, "filmy.csv")

filmy  <- read.csv("filmy-clean.csv", na.strings="NA", stringsAsFactors=F)

# draw char

require(RColorBrewer)

filmy$po_nominaci[is.na(filmy$po_nominaci)]  <- 0
filmy$po_vyhlaseni[is.na(filmy$po_vyhlaseni)]  <- 0

filmy$pred_nominaci_pc  <- filmy$pred_nominaci/(filmy$pred_nominaci+filmy$po_nominaci+filmy$po_vyhlaseni)*100
filmy$po_nominaci_pc  <- filmy$po_nominaci/(filmy$pred_nominaci+filmy$po_nominaci+filmy$po_vyhlaseni)*100
filmy$po_vyhlaseni_pc  <- filmy$po_vyhlaseni/(filmy$pred_nominaci+filmy$po_nominaci+filmy$po_vyhlaseni)*100


export  <- filmy[,c(2,1,7,8,9)]
export$popiska  <- paste(export$rok, ": ", export$nazev, sep="")
write.csv(export[,c(6,3,4,5)],"export.csv")



trzby <- as.matrix(t(filmy)[3:5,])
colnames(trzby)  <- filmy$nazev

trzby.procenta  <- as.matrix(t(filmy)[7:9,])
colnames(trzby.procenta)  <- paste(filmy$rok, ": ", filmy$nazev, sep="")  

trzby.procenta.rev  <- trzby.procenta[,182:1]


barplot(trzby,
        legend.text=c("Před nominací", "Po nominaci", "Po vyhlášení"),
        args.legend=list(bty="n"),
        xlab="Tržby v milionech dolarů",
        col=brewer.pal(3,"Dark2"),
        border="white",
        horiz=T)

pdf("trzby-procenta.pdf", 675, 2800)

par(mai=c(2,3.5,0.5,0.5))

barplot(trzby.procenta.rev,
        legend.text=c("Před nominací", "Po nominaci", "Po vyhlášení"),
        #args.legend=list(bty="n", horiz=T),
        xlab="Procento tržeb",
        col=brewer.pal(3,"Dark2"),
        border="white",
        horiz=T,
        main="Kterým filmům Oscar nejvíc pomohl? Podíly z celkových tržeb",
        cex.names=0.75,
        las=1)

dev.off()


warnings()
