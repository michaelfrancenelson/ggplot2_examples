# These types of plots are widely criticized...

require(ggplot2)


# web example adapted from here: -------------------------
# https://rpubs.com/MarkusLoew/226759

n = 100
dat = data.frame(x = 1:n, y1 = rnorm(n, mean = 3))
dat$y2 = rpois(n, 10) * 1 + sin((1:100) / 7) * 5


c1 = scale_colour_manual(values = c("blue", "red"))
l1 = labs(y = "Air temperature [°C]",
          x = "Day",
          colour = "Parameter")

# Both data on plot with same axes:
g1 = ggplot(dat, aes(x)) + geom_line(aes(y = y2, color = "Humidity")) + geom_line(aes(y = y1, color = "Temperature")) + ylim(c(0, max(dat[, 2:3])))
g1 + c1 + l1

# Must rescale y2:
range(dat$y1)


g2 = ggplot(dat, aes(x)) + geom_line(aes(y = y1, color = "Temperature"))

# Scale by multiple
g3a = g2 + geom_line(aes(y = y2 / 3, color = "Humidity"))
g4a = g3a + scale_y_continuous(sec.axis = ~.*3, name = "Relative humidity [%]")

# Scale by multiple and addition of constant
g3b = g2 + geom_line(aes(y = y2 / 3 - 3, color = "Humidity"))
g4b = g3b + scale_y_continuous(sec.axis = ~.*3 + 3, name = "Relative humidity [%]")

g1  + c1 + l1

g3a  + c1 + l1
g4a  + c1 + l1

g3b  + c1 + l1
g4b  + c1 + l1
