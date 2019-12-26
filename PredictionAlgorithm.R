
#Getting news,blogs and twitter data 
DataNews <- readLines("./final/en_US/en_US.news.txt", encoding="UTF-8", skipNul = TRUE, warn = TRUE)
DataTwitter <- readLines("./final/en_US/en_US.twitter.txt",encoding="UTF-8", skipNul = TRUE, warn = TRUE)
DataBlogs <- readLines("./final/en_US/en_US.blogs.txt",encoding="UTF-8", skipNul = TRUE, warn = TRUE)

#loading all the libraries
library(ggplot2)
library(NLP)
library(tm)
library(RWeka)
library(data.table)
library(dplyr)
library(ngram)
#Extracting sample data for analysis
set.seed(100)
SampleSize = 10000

SampleNews <- DataNews[sample(1:length(DataNews),SampleSize, replace = TRUE, prob = NULL)]
SampleTwitter <- DataTwitter[sample(1:length(DataTwitter),SampleSize, replace = TRUE, prob = NULL)]
SampleBlogs <- DataBlogs[sample(1:length(DataBlogs),SampleSize, replace = TRUE, prob = NULL)]

dataframeEnUS <-rbind(SampleNews,SampleTwitter,SampleBlogs)
rm(DataNews,DataTwitter,DataBlogs)


#creating the corpus
corpus <- VCorpus(VectorSource(dataframeEnUS))

corpus <- tm_map(corpus, tolower)
corpus <- tm_map(corpus, removePunctuation)
corpus <- tm_map(corpus, removeNumbers)
corpus <- tm_map(corpus, stripWhitespace)
corpus <- tm_map(corpus, PlainTextDocument)
changetospace <- content_transformer(function(x, pattern) gsub(pattern, " ", x))
corpus <- tm_map(corpus, changetospace, "/|@|\\|")

#using tokenizer to break  into components
TokenUniGram <- function(x) NGramTokenizer(x, Weka_control(min = 1, max = 1))
TokenBiGram <- function(x) NGramTokenizer(x, Weka_control(min = 2, max = 2))
TokenTriGram<- function(x) NGramTokenizer(x, Weka_control(min = 3, max = 3))
TokenQuadGram <- function(x) NGramTokenizer(x, Weka_control(min = 4, max = 4))
OneCorpus <- NGramTokenizer(corpus, Weka_control(min = 1, max = 1))
UnigramCorpus <- TermDocumentMatrix(corpus, control = list(tokenize = TokenUniGram))
BigramCorpus <- TermDocumentMatrix(corpus, control = list(tokenize = TokenBiGram))
TrigramCorpus <- TermDocumentMatrix(corpus, control = list(tokenize = TokenTriGram))
QuadgramCorpus <- TermDocumentMatrix(corpus, control = list(tokenize = TokenQuadGram))

#Finding the frequently used terms
UnigramFrequency <- findFreqTerms(UnigramCorpus, lowfreq = 5)
UnigramTermFrequency <- rowSums(as.matrix(UnigramCorpus[UnigramFrequency,]))
UnigramTermFrequency <- data.frame(unigram=names(UnigramTermFrequency), frequency=UnigramTermFrequency)
UnigramTermFrequency <- UnigramTermFrequency[order(-UnigramTermFrequency$frequency),]
ListUnigram <- setDT(UnigramTermFrequency)
save(ListUnigram,file="UnigramData.Rds")
BigramFrequency <- findFreqTerms(BigramCorpus, lowfreq = 3)
BigramTermFrequency <- rowSums(as.matrix(BigramCorpus[BigramFrequency,]))
BigramTermFrequency <- data.frame(bigram=names(BigramTermFrequency), frequency=BigramTermFrequency)
BigramTermFrequency <- BigramTermFrequency[order(-BigramTermFrequency$frequency),]
ListBigram <- setDT(BigramTermFrequency)
save(ListBigram,file="BigramData.Rds")
TrigramFrequency <- findFreqTerms(TrigramCorpus, lowfreq = 2)
TrigramTermFrequency <- rowSums(as.matrix(TrigramCorpus[TrigramFrequency,]))
TrigramTermFrequency <- data.frame(trigram=names(TrigramTermFrequency), frequency=TrigramTermFrequency)
ListTrigram <- setDT(TrigramTermFrequency)
save(ListTrigram,file="TrigramData.Rds")
QuadgramFrequency <- findFreqTerms(QuadgramCorpus, lowfreq = 1)
QuadgramTermFrequency <- rowSums(as.matrix(QuadgramCorpus[QuadgramFrequency,]))
QuadgramTermFrequency <- data.frame(quadgram=names(QuadgramTermFrequency), frequency=QuadgramTermFrequency)
ListQuadgram <- setDT(QuadgramTermFrequency)
save(ListQuadgram,file="DataQuadgram.Rds")
