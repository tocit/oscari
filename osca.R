require(XML)
require(stringr)


#stáhni data
filmy  <- readHTMLTable("http://en.wikipedia.org/wiki/List_of_Academy_Award_winners_and_nominees_for_Best_Foreign_Language_Film", which=1)

#vyčisti data
names(filmy)  <-  c("rok", "nazev_en", "nazev_original", "nazev_zeme", "rezie", "jazyky")

filmy$rok  <- as.numeric(str_extract(filmy$rok, "\\d\\d\\d\\d"))

filmy$nazev_original

# exportuj původní názvy
write.csv(as.character(lapply(str_split(filmy$nazev_original, "\n"), "[", 1)), "puvodni_nazvy.csv")

# exportuj názvy zemí
write.csv(filmy$nazev_zeme, "nazev_zeme.csv")
