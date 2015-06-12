#################################################################################
#A example to use a streaming API, by Yi-Ju Tseng (@yijutseng), 06.12.2015
#Based on:
#http://code.recollect.com/post/20476037331/visualizing-twitter-social-graph-pt1
#https://dev.twitter.com/overview/documentation
#place to test your url:
#https://dev.twitter.com/rest/tools/console
#################################################################################
library(jsonlite)
library(plyr)
#################################################################################
#Step 1. Authentication (OAuth)
#################################################################################
sig<-AuthTwitter()
#filling the parameter with your application key and token: AuthTwitter(key,secret,token,token_secret)
#################################################################################
#Step 2. Connections 
#################################################################################
homeTL=GET("https://api.twitter.com/1.1/statuses/home_timeline.json",sig)
jsonHome=content(homeTL)
json2=jsonlite::fromJSON(toJSON(jsonHome))
friends=GET("https://api.twitter.com/1.1/friends/ids.json?screen_name=a&user_id=yijutseng",sig)
jsonFriend=content(friends)
followers=GET("https://api.twitter.com/1.1/followers/ids.json?screen_name=a&user_id=yijutseng",sig)
jsonFollower=content(followers)

#MERS,MERS-CoV,Middle East respiratory syndrome coronavirus
searchG='MERS%2CMERS-CoV%2CMiddle%20East%20respiratory%20syndrome%20coronavirus'
count=100
runs<-100
url=paste0("https://api.twitter.com/1.1/search/tweets.json?q=",searchG,"&count=",count)
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
jsonTarget=jsonlite::fromJSON(toJSON(contentList))
length(jsonTarget$statuses$text)
#text analysis
table(unlist(jsonTarget$statuses$text))
#country analysis
table(unlist(jsonTarget$statuses$place$country_code))
#full names of place
table(unlist(jsonTarget$statuses$place$full_name))
#retwett count
table(unlist(jsonTarget$statuses$retweet_count))
#<3 count
table(unlist(jsonTarget$statuses$favorite_count))
#withheld_in_countries?
table(unlist(jsonTarget$statuses$withheld_in_countries))
#hashtags
hashL<-c()
for(i in 1:length(jsonTarget$statuses$text)){
  hashTemp<-unlist(jsonTarget$statuses$entities$hashtags[[i]]$text)
  if(!is.null(hashTemp)){
    hashL<-c(hashL,hashTemp)
  }
}
table(hashL)


#################################################################################
#Step N. Disconnections 
#################################################################################