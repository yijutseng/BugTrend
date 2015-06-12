library(httr)
AuthTwitter<-function (key,secret,token,token_secret){
  myapp=oauth_app("twitter",key=key,secret=secret)
  sig=sign_oauth1.0(myapp,token=token,token_secret=token_secret)
  sig
}


