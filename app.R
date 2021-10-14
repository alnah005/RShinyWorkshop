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

getCutoutsFromDECandRA <- function(ra, dec,myOpts) {
  urlBase <- "https://irsa.ipac.caltech.edu/cgi-bin/Atlas/nph-atlas?mission=COSMOS&locstr="
  urlTail <- "+eq&regSize=0.005&searchregion=on&covers=on&mode=PI"
  urlXML <- getURL(paste(urlBase,ra,"+",dec,urlTail,sep=""), .opts = myOpts)
  
  result <- xmlParse(urlXML)
  
  xml_data <- xmlToList(result)
  
  tile_url <- gsub("[\r\n\ ]", "", xml_data[['images']][['metadataVOtable']])
  
  urlXML <- getURL(tile_url, .opts = myOpts)
  
  result <- xmlParse(urlXML)
  
  result <- xmlChildren(result)
  
  df <- xmlToDataFrame(result[[1]][[2]][[2]][[45]][[1]])
  
  # column names
  attempt <- xmlToList(result[[1]][[2]][[2]])
  
  columnsWithoutData <- attempt[0:44]
  
  columnNames <- lapply(columnsWithoutData,'[[',1)
  
  columnTypes <- lapply(columnsWithoutData,'[[',3)
  
  colnames(df) <- columnNames
  
  index <- 1
  for (col in df) {
    if (columnTypes[[index]] == 'POS_EQ_RA_MAIN' || columnTypes[[index]] == 'POS_EQ_DEC_MAIN'){
      df[,index] <- sapply(df[,index],as.numeric)
    }
    if (columnTypes[[index]] == 'int' || columnTypes[[index]] == 'double'){
      df[,index] <- sapply(df[,index],as.numeric)
    }
    index <- index + 1
  } 
  return(df)
}

downloadCutoutGivenDECandRA <- function(ra,dec,myOpts) {
  df <- getCutoutsFromDECandRA(ra,dec,myOpts)
  
  df_HST <- df[df[["facility_name"]] == 'HST',]
  
  df_HST_SCIENCE <- df_HST[df_HST[["file_type"]] == 'science',]
  
  df_HST_SCIENCE_ACS <- df_HST_SCIENCE[df_HST_SCIENCE[["instrument_name"]] == 'ACS',]
  
  download.file(as.character(df_HST_SCIENCE_ACS$sia_url[[1]]),'./file.fits',method="curl")
}