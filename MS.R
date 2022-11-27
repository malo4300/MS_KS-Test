#Libraries
library(tidyverse)
library(gridExtra)
#Wahre Parameter
p_value = 0.05
mean_true = 10
sd_true = 3
B = 5000
#Grid für unterschiedliche Verteilungsfunktionen
grid_mean = seq(5,15, length.out = 150)
grid_sd = seq(0.5,10, length.out = 150)
##### Exakte Verteilung #####
####Abweichung im Mean exakt####
#Kleine Stichprobe
n = m = 20
power_small_exact_mean = rep(0, length(grid_mean))
for (H_0_Version in 1:length(grid_mean)) {
  test_results = rep(TRUE, B)
  for (i in 1:B) {
    x = rnorm(n = m, mean = mean_true, sd = sd_true)
    y = rnorm(n = n, mean = grid_mean[H_0_Version], sd = sd_true)
    test_results[i] = ks.test(x,y,alternative = "two.sided", exact = T)$p.value < p_value
  }
  power_small_exact_mean[H_0_Version] = (sum(test_results)/B)
}

#Große Stichprobe
n = m = 100
power_big_exact_mean = rep(0, length(grid_mean))
for (H_0_Version in 1:length(grid_mean)) {
  test_results = rep(TRUE, B)
  for (i in 1:B) {
    x = rnorm(n = m, mean = mean_true, sd = sd_true)
    y = rnorm(n = n, mean = grid_mean[H_0_Version], sd = sd_true)
    test_results[i] = ks.test(x,y,alternative = "two.sided", exact = T)$p.value < p_value
  }
  power_big_exact_mean[H_0_Version] = (sum(test_results)/B)
}

####Abweichung sd exakt ####
#kleine Stichprobe
n = m = 20
power_small_exact_sd = rep(0, length(grid_sd))

for (H_0_Version in 1:length(grid_sd)) {
  test_results = rep(TRUE, B)
  for (i in 1:B) {
    x = rnorm(n = m, mean = mean_true, sd = sd_true)
    y = rnorm(n = n, mean = mean_true, sd = grid_sd[H_0_Version])
    test_results[i] = ks.test(x,y,alternative = "two.sided", exact = T)$p.value < p_value
  }
  power_small_exact_sd[H_0_Version] = (sum(test_results)/B)
}
#Große Stichprobe
n = m = 100
power_big_exact_sd = rep(0, length(grid_sd))
set.seed(100)
for (H_0_Version in 1:length(grid_sd)) {
  test_results = rep(TRUE, B)
  for (i in 1:B) {
    x = rnorm(n = m, mean = mean_true, sd = sd_true)
    y = rnorm(n = n, mean = mean_true, sd = grid_sd[H_0_Version])
    test_results[i] = ks.test(x,y,alternative = "two.sided", exact = T)$p.value < p_value
  }
  power_big_exact_sd[H_0_Version] = (sum(test_results)/B)
}
##### Asymptotische Verteilung #####
#Funktion die angibt, wie wahrscheinlich eine extremere Teststatistik asymptotisch ist
asy_dist = function(d_beob, n, m){
  lampda_beob = sqrt((n*m)/(n+m))*d_beob
  prob = 1
  ### Summe bis 100 trunkiert
  for (i in 1:100) {
    prob = prob - 2*((-1)^(i-1))*exp((-2)*(lampda_beob^2)*(i^2))
  }
  return(1-prob) #Wahrscheinlichkeit einen extremeren Wert zu sehen
}
####Abweichung im Median asymptotisch
#Kleine Stichprobe
n=m=20
power_small_asy_mean = rep(0, length(grid_mean))
for (H_0_Version in 1:length(grid_mean)) {
  test_results = rep(TRUE, B)
  for (j in 1:B) {
    d_beob = ks.test(x = rnorm(n = n, mean = mean_true, sd = sd_true), y = rnorm(n = m, mean = grid_mean[H_0_Version], sd = sd_true))$statistic
    p_value_asy = asy_dist(d_beob = d_beob, n = n, m = m)
    test_results[j] = p_value_asy < 0.05
  }
  power_small_asy_mean[H_0_Version] = (sum(test_results)/B)
}

#Große Stichprobe
n=m=100
power_big_asy_mean = rep(0, length(grid_mean))
for (H_0_Version in 1:length(grid_mean)) {
  test_results = rep(TRUE, B)
  for (j in 1:B) {
    d_beob = ks.test(x = rnorm(n = n, mean = mean_true, sd = sd_true), y = rnorm(n = m, mean = grid_mean[H_0_Version], sd = sd_true))$statistic
    p_value_asy = asy_dist(d_beob = d_beob, n = n, m = m)
    test_results[j] = p_value_asy < 0.05
  }
  power_big_asy_mean[H_0_Version] = (sum(test_results)/B)
}
####Abweichung Sd asymptotisch###
#Kleine Stichprobe
n=m=20
power_small_asy_sd = rep(0, length(grid_sd))
for (H_0_Version in 1:length(grid_sd)) {
  test_results = rep(TRUE, B)
  for (j in 1:B) {
    d_beob = ks.test(x = rnorm(n = n, mean = mean_true, sd = sd_true), y = rnorm(n = m, mean = mean_true, sd = grid_sd[H_0_Version]))$statistic
    p_value_asy = asy_dist(d_beob = d_beob, n = n, m = m)
    test_results[j] = p_value_asy < 0.05
  }
  power_small_asy_sd[H_0_Version] = (sum(test_results)/B)
}
#Große Stichprobe
n=m=100
power_big_asy_sd = rep(0, length(grid_sd))
for (H_0_Version in 1:length(grid_sd)) {
  test_results = rep(TRUE, B)
  for (j in 1:B) {
    d_beob = ks.test(x = rnorm(n = n, mean = mean_true, sd = sd_true), y = rnorm(n = m, mean = mean_true, sd = grid_sd[H_0_Version]))$statistic
    p_value_asy = asy_dist(d_beob = d_beob, n = n, m = m)
    test_results[j] = p_value_asy < 0.05
  }
  power_big_asy_sd[H_0_Version] = (sum(test_results)/B)
}

#### Plotten ####
#Exact
plot_mean_small = ggplot(data = data.frame(grid_mean ,power_small_exact_mean, power_small_asy_mean), mapping = aes(x = grid_mean))+
  geom_line(mapping = aes(y = power_small_exact_mean,  colour = "Exakt"))+
  geom_line(mapping = aes(y = power_small_asy_mean, colour = "Asymptotisch"))+
  scale_colour_manual(" ", breaks = c("Exakt","Asymptotisch" ), values = c("Blue", "Green")) + 
  theme_bw()+
  geom_hline(yintercept = 0.05 ,col = "Red") + 
  xlab("Unterschiedliche Mittelwerte") +
  ylab("Wert der Gütefunktion") +
  ggtitle("Kleine Stichprobe") +
  ylim(0,1)


plot_mean_big = ggplot(data = data.frame(grid_mean ,power_big_exact_mean, power_big_asy_mean), mapping = aes(x = grid_mean))+
  geom_line(mapping = aes(y = power_big_exact_mean,  colour = "Exakt"))+
  geom_line(mapping = aes(y = power_big_asy_mean, colour = "Asymptotisch"))+
  scale_colour_manual(" ", breaks = c("Exakt","Asymptotisch" ), values = c("Blue", "Green")) + 
  theme_bw()+
  geom_hline(yintercept = 0.05 ,col = "Red") + 
  xlab("Unterschiedliche Mittelwerte") +
  ylab("Wert der Gütefunktion") +
  ggtitle("Große Stichprobe") +
  ylim(0,1)

plot_sd_small = ggplot(data = data.frame(grid_sd, power_small_exact_sd,power_small_asy_sd), mapping = aes(x = grid_sd))+
  geom_line(mapping = aes(y = power_small_exact_sd,  colour = "Exakt"))+
  geom_line(mapping = aes(y = power_small_asy_sd, colour = "Asymptotisch"))+
  scale_colour_manual(" ", breaks = c("Exakt","Asymptotisch" ), values = c("Blue", "Green")) + 
  theme_bw()+
  geom_hline(yintercept = 0.05, col = "Red") + 
  xlab("Unterschiedliche Standardabweichungen") +
  ylab("Wert der Gütefunktion")+
  ggtitle("Kleine Stichprobe")


plot_sd_big = ggplot(data = data.frame(grid_sd, power_big_exact_sd,power_big_asy_sd), mapping = aes(x = grid_sd))+
  geom_line(mapping = aes(y = power_big_exact_sd,  colour = "Exakt", linetype = "dashed"))+
  geom_line(mapping = aes(y = power_big_asy_sd, colour = "Asymptotisch", linetype = "dotted"))+
  scale_colour_manual(" ", breaks = c("Exakt","Asymptotisch" ), values = c("Blue", "Green")) + 
  scale_linetype_discrete(guide = "none")+
  theme_bw()+
  geom_hline(yintercept = 0.05, col = "Red") + 
  xlab("Unterschiedliche Standardabweichungen") +
  ylab("Wert der Gütefunktion")+
  ggtitle("Große Stichprobe")



grid.arrange(plot_mean_small, plot_mean_big, ncol = 2, top = "Vergleich Mittwelwert Exakt und Asymptotisch für unterschiedliche Stichprobengrößen")
grid.arrange(plot_sd_small, plot_sd_big, ncol = 2, top = "Vergleich Standardabweichung Exact und Asymptotisch für unterschiedliche Stichprobengrößen")
