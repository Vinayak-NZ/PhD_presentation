#load name of pdf files
files <- list.files(path = "data/", pattern = "pdf$")

#load pdf files into environment
knowledge <- lapply(paste0("data/",files), pdf_text)

#examine pdf files
lapply(knowledge, length)

#tidy pdf files
corp <- Corpus(URISource(files), 
               readerControl = list(reader = readPDF))

corp <- tm_map(corp, removePunctuation, ucp = TRUE)

knowledge.tdm <- TermDocumentMatrix(corp, 
                                   control = 
                                     list(stopwords = TRUE,
                                          tolower = TRUE,
                                          removeNumbers = TRUE,
                                          bounds = list(global = c(2, Inf))))

#convert to data frame with frequency of words
matrix <- as.matrix(knowledge.tdm) 
words <- sort(rowSums(matrix),decreasing=TRUE) 
df <- data.frame(word = names(words),freq=words)

#generate wordcloud
set.seed(1234)
hw <- wordcloud2(data=df, size=1.6, color='random-dark')
webshot::install_phantomjs()
saveWidget(hw,"output/1.html",selfcontained = F)
webshot::webshot("output/1.html","output/1.png",vwidth = 1992, vheight = 1744, delay =10)
