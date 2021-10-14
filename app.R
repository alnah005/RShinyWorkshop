print("I am app")
iam <- "app variable"

# to download ZEST data, use this query https://irsa.ipac.caltech.edu/SCS?table=cosmos_morph_zurich_1&RA=150.497513&DEC=2.319841&SR=2&format=csv

# for a list of all available catalogs: https://irsa.ipac.caltech.edu/cgi-bin/Gator/nph-scan?mode=xml

zest_data <- read.csv("SCS.csv", stringsAsFactors=FALSE, header = TRUE)
zest_data <- zest_data %>% select("dec","ra","acs_elongation","gg","m20","cc","aa","pc_1","pc_2","pc_3")
zest_data[zest_data == "null"] <- NA
zest_data[zest_data == ""] <- NA
zest_data <- zest_data[complete.cases(zest_data),]
zest_data <- sapply(zest_data,as.numeric)
zest_data <- data.frame(zest_data)
zest_data <-  zest_data %>% select_if(is.numeric)


rf <- colorRampPalette(rev(brewer.pal(11,'Spectral')))
r <- rf(32)