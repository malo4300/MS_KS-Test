##### Genaue Verteilung
library(tidyverse)
B = 250000
diffs_small = rep(0,B)
diffs_big = rep(0, B)
n = m = 25
for (j in 1:B) {
  x = rnorm(n)
  y = rnorm(m)
  diffs_small[j] = ks.test(x,y)$statistic
}
frequencys_small = data.frame(values = round(diffs_small,4)) %>% group_by(values) %>% summarise(Anzahl = n())
frequencys_small = frequencys_small %>% mutate(share = frequencys_small$Anzahl/B, cum_sum = cumsum(share)) %>% view()
#kritscher Wert. Werte die mindestens so hoch sind werden Abgelehnt
crit_small = frequencys_small$values[frequencys_small$cum_sum>0.95][1]
ablehnung_small = function(d_beob){
  if(d_beob>=crit_small){
    return(T)
  }else{
    return(F)
  }
}

### Big Smaplesize ####
n = m = 100
for (j in 1:B) {
  x = sort(rnorm(n))
  y = sort(rnorm(m))
  diffs_big[j] = ks.test(x,y)$statistic
}

frequencys_big = data.frame(values = round(diffs_big,4)) %>% group_by(values) %>% summarise(Anzahl = n())
frequencys_big = frequencys_big %>% mutate(share = frequencys_big$Anzahl/B, cum_sum = cumsum(share)) %>% view()
#kritscher Wert
cirt_big = frequencys_big$values[frequencys_big$cum_sum>0.95][1]

ablehnung_big = function(d_beob){
  if(d_beob>=cirt_big){
    return(T)
  }else{
    return(F)
  }
}



