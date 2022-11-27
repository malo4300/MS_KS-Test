#test ob der test klappt

#### große Stichprobe
n = m = 100
B = 10000000
test_results = rep(TRUE, B)
pb = txtProgressBar(min = 1, max = B, style = 3)
for (i in 1:B) {
  setTxtProgressBar(pb, i)
  x = rnorm(n = m, mean = mean_true, sd = sd_true)
  y = rnorm(n = n, mean = mean_true, sd = sd_true)
  test_results[i] = ks.test(x,y,alternative = "two.sided", exact = T)$p.value <= p_value
}
print((sum(test_results)/B))

test
