require(relenium)

rokAll  <- integer()
nazevAll  <- character()
rozpocetAll  <- character()

# stáhni seznam vítězných filmů z IMDB


links  <- getHTMLLinks("http://www.imdb.com/search/title?count=100&groups=oscar_best_picture_winners&sort=year,desc&ref_=nv_ch_osc_3")
links  <- unique(links[str_detect(links, "/title/tt\\d\\d\\d\\d\\d\\d\\d/$")])
links  <- paste("http://www.imdb.com", links, sep="")

# zjisti názvy a rozpočty

for (i in links) {
firefox <- firefoxClass$new()
firefox$get(i)

nazev  <- firefox$findElementByXPath('//*[@id="overview-top"]/h1/span[1]')
nazev  <- nazev$getText()
print(nazev)
nazevAll  <- append(nazevAll, nazev)

rok <- firefox$findElementByXPath('/html/head/title')
rok  <- as.character(rok$getHtml())
rok  <- str_sub(rok, str_locate(rok, "\\(")[1]+1, str_locate(rok, "\\)")[1]-1)
print(rok)
rokAll  <- append(rokAll, as.numeric(rok))

rozpocet <- firefox$findElementByXPath('//*[@id="titleDetails"]/div[7]')
if (str_detect(rozpocet$getText(), "Budget:")) {
  rozpocet  <- rozpocet$getText()
} else {
  rozpocet <- firefox$findElementByXPath('//*[@id="titleDetails"]/div[6]')
  rozpocet  <- rozpocet$getText()
}
print(rozpocet)
rozpocetAll  <- append(rozpocetAll, rozpocet)

firefox$close()
}

vitezove  <- as.data.frame(cbind(rokAll, nazevAll, rozpocetAll))

write.csv(vitezove, "vitezove.csv")
