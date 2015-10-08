# <-- number sign is a comment

# press control+enter to run a line in a script

# math operators
1 + 1
2 * 3
3^2
(1 + 1)^3

# variables
v1 <- 3
v2 = 4 # same thing
v1 + v2

# vectors
1:100 # creates a vector or 100 integers, 1 - 100

# vectorized functions
(1:25)^2
1:25 + 2
mean(1:25)
sd(1:25)

# common statistical distributions
dnorm(0) # normal distribution (density)
curve(dnorm, -3, 3) # plot the function
dnorm(-3:3) # it's vectorized!

pnorm(1.96) # normal distribution (cumulative)
# same as the table in the back of your stats textbook
curve(pnorm, -3, 3)

rnorm(1) # random sample from a normal distribution
hist(rnorm(10000))

# how you would normally read in data
csv = read.csv("some_file.csv")

# get CCES data
# If needed, download data from
# https://dataverse.harvard.edu/dataset.xhtml?persistentId=hdl:1902.1/21447
# Make sure to change the working directory to the folder with the data
# (Session -> Set Working Directory)
load("commoncontent2012.RData")
ls() # list the variables
cces = x

class(cces) # new type of object -- a data frame
dim(cces) # how many rows and columns?

class(cces$gender) # a factor
table(cces$gender)
barplot(table(cces$gender))


# subsetting
# Another vectorized function, checking every inputstate in cces
# returns a vector of 54,535 TRUE/FALSE values
sum(cces$inputstate == "New York")
which(cces$inputstate == "New York")

# cces[row, column]
# only the rows where the inputstate is New York, all columns
ny = cces[cces$inputstate == "New York", ]
# same thing

barplot(table(cces$CC334A), main = "US Political Views")
barplot(table(ny$CC334A), main = "New York Political Views")


# install the basicspace package (if needed)
install.packages(basicspace)
# load the basicspace package
library(basicspace)


# get information about the aldmck [Aldrich-McKelvey scaling] function
?aldmck



# CC334A = self, CC334C = Obama, CC334D = Romney,
# CC334E = Democratic Party, CC334F = Republican Party,
# CC334G = Tea Party, CC334P = Supreme Court
scales = paste("CC334", LETTERS[c(1, 3:7, 16)], sep = "")
am_scales = cces[, scales]

# 'apply' functions: 'for' loops without the loop
m = matrix(nrow = nrow(am_scales), ncol = ncol(am_scales))
for (n in 1:ncol(m)) {
  m[, n] = as.numeric(am_scales[, n])
}
# ^^^ same as above
m = sapply(am_scales, as.numeric)

unique(as.vector(m))
m[m == 8] = NA
unique(as.vector(m))
colnames(m) = c("Self", "Obama", "Romney", "Democratic Party",
             "Republican Party", "Tea Party", "Supreme Court")
results = aldmck(m, respondent = 1, polarity = 2)
plot(results)
plot.AM(results)

class(results)
str(results) # what is in this object?

plot(density(results$respondents$idealpt,
             from = -2, to = 2, na.rm = T), add = T)
plot(density(results$respondents$idealpt[cces$inputstate == "New York"],
             from = -2, to = 2, na.rm = T),
     main = "Political Ideology (New York Only)")



# make a rainbow density graph
ny_ideals = density(results$respondents$idealpt[cces$inputstate == "New York"],
                    from = -2, to = 2, na.rm = T)
plot(ny_ideals, ylab = "", xlab = "Liberal to Conservative",
     xlim = c(-2, 2), main = "Political Ideology (New York Only)")

str(ny_ideals)
xs = ny_ideals$x
ys = ny_ideals$y

# colors from blue to red
cols = rainbow(length(xs), start=4/6, end=0, v=.8, s=.5)

x = 1
for (n in 1:length(xs)) {
  polygon(c(xs[n], xs[n], xs[n + 1], xs[n + 1]),
          c(0, ys[n], ys[n + 1], 0),
          col = cols[x], border = NA)
  x = x + 1
}



