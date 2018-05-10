require(ggplot2)
# (temporal) Autocorrelation in mean red-stage pines in the study forests

i = 1:4
dat1 = data.frame(
  forest = rep(c("for1", "for2", "for3", "for4"), each = 20),
  x = rep(1:20, 4),
  y = c(
    rpois(n = 20, lambda = 20),
    rpois(n = 20, lambda = 30),
    rpois(n = 20, lambda = 40),
    rpois(n = 20, lambda = 50)))


gg1 = ggplot(data = dat1, aes(x = x, y = y, color = forest))
f1 = facet_wrap(~forest, ncol = 2)
gg1 + f1 + geom_bar(stat = "identity", aes(fill = forest), color = 1, width = 1)

