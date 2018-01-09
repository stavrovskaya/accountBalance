library(ryandexdirect)
library(tidyverse)
library(plyr)

my_token <-NA
yandex.account="stbinario"
yalogin<-"biolatic-project"

auth<-function(yandex_account="stbinario" ){
  #authentification
  #yandex.direct
  ya_fname<-paste(yandex_account, ".ya.token.txt", sep="")
  my_token <<- readChar(ya_fname, file.info(ya_fname)$size)#yadirGetToken()
}

getBalance<-function(clients, updateProgress = NULL){
  auth()
  
  n = 5
  
  if (is.function(updateProgress)) {
    updateProgress(1/n, "authentification")
  }
  
  all_clients<-yadirGetClientList(my_token)
  not_found<-clients[!(clients %in% all_clients$Login)]
  
  if (is.function(updateProgress)) {
    updateProgress(2/n, "load clients list")
  }
  
  if (length(not_found)>0){
    stop(paste("clients not found:", paste(not_found, collapse = ", ")))
  }
  
  if (is.function(updateProgress)) {
    updateProgress(3/n, "load balance report")
  }
  balance_report<-yadirGetBalance(clients, my_token)
  
  if (is.function(updateProgress)) {
    updateProgress(4/n, "load campaign report")
  }
  cost_report<-yadirGetReport(ReportType = "CAMPAIGN_PERFORMANCE_REPORT", DateRangeType = "LAST_WEEK", FieldNames = c("CampaignName","Impressions","Clicks","Cost"), Login = clients, Token = my_token)
  mean_cost<-dplyr::summarise(group_by(cost_report, login), mean_day_cost=round(sum(Cost)/7, 2))
  mean_cost<-data.frame(mean_cost)

  if (is.function(updateProgress)) {
    updateProgress(5/n, "form final report")
  }  
  report<-dplyr::left_join(balance_report[, c("Login","Amount")], mean_cost, by=c("Login"="login"))
  report$Amount<-as.numeric(report$Amount)
  return(report)
}



