#################################################################################
#A example to use a streaming API, by Yi-Ju Tseng (@yijutseng), 06.12.2015
#Based on:
#http://code.recollect.com/post/20476037331/visualizing-twitter-social-graph-pt1
#https://dev.twitter.com/overview/documentation
#place to test your url:
#https://dev.twitter.com/rest/tools/console
#################################################################################
library(plyr)
KeywordsSearch<-function(keywords,countPerPage,runs){
  #Parsing ',' and blank and other symbles
  keywordsURL<-URLencode(keywords)
  url=paste0("https://api.twitter.com/1.1/search/tweets.json?q=",keywordsURL,"&count=",countPerPage)
  nextID<-''
  if(exists('contentList')){
    remove(contentList)
  }
  for(i in 1:runs){
    if(i==1){
      target=GET(url,sig)
    }else{
      target=GET(paste0(url,'&max_id=',nextID),sig)
    }
    contentTarget<-content(target)
    if(exists('contentList')){
      contentList<-mapply(c, contentList, contentTarget, SIMPLIFY=FALSE)
    }else{
      contentList<-contentTarget
    }
    #check https://dev.twitter.com/rest/public/timelines
    nextID<-as.character(as.numeric(contentTarget$statuses$id_str[contentTarget$search_metadata$count])-1)
  }
  contentList
}
