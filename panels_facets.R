require(ggplot2)
require(gridExtra)

# Facets from same data set -----------------------------------------------

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

# with different scales in each facet
f2 = facet_wrap (~ forest, ncol = 2, scales = "free")
gg1 + f2 + geom_bar(stat = "identity", aes(fill = forest), color = 1, width = 1)




# facets from different data sets -----------------------------------------

# use grid.arrange() from gridExtra
# https://cran.r-project.org/web/packages/egg/vignettes/Ecosystem.html

d1 = data.frame(x = rnorm(100), y = rnorm(100))
d2 = data.frame(x = 1:100, obs = factor(rpois(100, lambda = 5)))
d3 = data.frame(x = seq(0, 1, length.out = 100), y = rexp(n = 100, 1.5) + seq(0, 1, length.out = 100))

g1 = ggplot(d1, aes(x, y, color = y)) + geom_point(); g1
g2 = ggplot(d2, aes(x = obs)) + geom_bar(stat = "count"); g2
g3 = ggplot(d3, aes(x, y)) + geom_line(); g3

grid.arrange(g1, g2, g3, nrow = 1)

