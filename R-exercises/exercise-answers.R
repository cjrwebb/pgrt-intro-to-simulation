# Exercise 1 - Collider - Answers

# We now want you to repeat this exercise, but with a different DGP. That is instead of an unmeasured confounder, 
# we now want to introduce a collider. A collider is a variable that is caused by two other variables. 
# In the below case, Z is caused by both X and Y.

# For instance, if X is education and Y is earnings, Z might be a measure of occupational prestige.

# The process for this is the same as before:
#   - Start with the variable that doesn’t have any arrows going into it, and create a simulated version of that
#   - Then generate those that are only produced by that variable, and so on until all the variables are generated
#   - You can then attempt to run the regression model of interest, to see how including Z in your model 
#     (or not) affect the estimation of X.

obs <- 1000 # Number of observations in data

# Because X is the only variable that has no arrows going to it,
# it needs to be simulated first. Then, Y can be simulated because
# it only requires X in order to be estimated. Finally, Z can be
# simulated We can also simulate our residuals for Y in E from the
# start.

#' In this case, we add the noise to z directly by just adding + rnorm
#' to the end of the formula (rather than creating it separately as
#' e). It doesn't matter too much which you choose. Our intercepts
#' here are effectively 0 because we are not specifying them.

sim <- tibble(
  e = rnorm(obs, 0, 4),
  x = rnorm(obs, 0, 2),
  y = 1 + 2*x + e,
  z = 1*x + 1*y + rnorm(obs, 0, 2)
)

# How does the model look with and without 
# Z included? The coefficient for X should be 2
mod <- lm(data = sim, y ~ x)
summary(mod)

# What happens when Z is included?
mod <- lm(data = sim, y ~ x + z)
summary(mod)


# Let's put this in a loop and see how different
# amounts of confounding (on the path y -> change the results)
set.seed(12345)
for (b2 in seq(0, 3, 1)) {
  sim <- tibble(
    e = rnorm(obs, 0, 4),
    x = rnorm(obs, 0, 2),
    y = 1 + 2*x + e,
    z = 1*x + b2*y + rnorm(obs, 0, 2)
  )
  message(paste("######## B2 =", b2))
  mod <- lm(data = sim, y ~ x)
  print(coefficients(mod))
  mod <- lm(data = sim, y ~ x + z)
  print(coefficients(mod))
}



# Exercise 2 - Collider - Answers

# Your task, now, is to develop a full simulation study for the collider bias example. 
# That is, what does controlling for Z do, with different levels of collider bias. 
# The process will be the same as that undertaken above for the confounding example.


# Let's break this up into two loops, because we want to run one where the regression
# results include Z in the regressions, and one where they don't. 

obs <- 1000
b1true <- 2
results_withz <- tibble(
  iteration = numeric(),
  sample_size = numeric(),
  collider = numeric(),
  b2 = numeric(),
  b1 = numeric(),
  b0 = numeric(),
  b2se = numeric(),
  b1se = numeric(),
  b0se = numeric()
)

set.seed(2345)
for (b2 in seq(0, 3, 1)) {
  for (iteration in 1:100) {
    # simulate the data
    sim <- tibble(
      e = rnorm(obs, 0, 4),
      x = rnorm(obs, 0, 2),
      y = 1 + 2*x + e,
      z = 1*x + b2*y + rnorm(obs, 0, 2)
    )
    # create a regression model
    mod <- lm(data = sim, y ~ x + z)
    # create a new vector that can be appended to our 
    # results dataframe
    res <- c(
      iteration = iteration,
      sample_size = obs,
      collider = b2, # Add the collider value b2 for the iterations
      b2 = coefficients(mod)["z"][[1]], # add the coefficient for y ~ z for this iteration
      b1 = coefficients(mod)["x"][[1]], # Add the coefficient for y ~ x for this iteration
      b0 = coefficients(mod)["(Intercept)"][[1]], # Add the intercept
      b2se = sqrt(diag(vcov(mod)))["z"][[1]], # Add the standard error for b2
      b1se = sqrt(diag(vcov(mod)))["x"][[1]], # Add the standard error for b1
      b0se = sqrt(diag(vcov(mod)))["(Intercept)"][[1]] # Add the standard error for the intercept
    )
    # append our results to our results dataframe
    results_withz <- results_withz %>% bind_rows(res)
  }
}

# Now let's calculate our quantities of interest:
bias_measures_withz <- results_withz %>%
  group_by(collider) %>%
  summarise(
    bias = mean(b1) / b1true,
    rmse = sqrt(mean((b1 - b1true)^2)),
    optimism = (sqrt(mean((b1-mean(b1))^2))) / (sqrt(mean(b1se^2)))
  )

bias_measures_withz

# Now let's do the same but where Z is not controlled for:


obs <- 1000
b1true <- 2
results_withoutz <- tibble(
  iteration = numeric(),
  sample_size = numeric(),
  collider = numeric(),
#  b2 = numeric(), # We don't need b2 now because Z isn't in the model
  b1 = numeric(),
  b0 = numeric(),
#  b2se = numeric(),
  b1se = numeric(),
  b0se = numeric()
)

set.seed(2345)
for (b2 in seq(0, 3, 1)) {
  for (iteration in 1:100) {
    # simulate the data
    sim <- tibble(
      e = rnorm(obs, 0, 4),
      x = rnorm(obs, 0, 2),
      y = 1 + 2*x + e,
      z = 1*x + b2*y + rnorm(obs, 0, 2)
    )
    # create a regression model
    mod <- lm(data = sim, y ~ x)
    # create a new vector that can be appended to our 
    # results dataframe
    res <- c(
      iteration = iteration,
      sample_size = obs,
      collider = b2, # Add the collider value b2 for the iterations
      b1 = coefficients(mod)["x"][[1]], # Add the coefficient for y ~ x for this iteration
      b0 = coefficients(mod)["(Intercept)"][[1]], # Add the intercept
      b1se = sqrt(diag(vcov(mod)))["x"][[1]], # Add the standard error for b1
      b0se = sqrt(diag(vcov(mod)))["(Intercept)"][[1]] # Add the standard error for the intercept
    )
    # append our results to our results dataframe
    results_withoutz <- results_withoutz %>% bind_rows(res)
  }
}

# Now let's calculate our quantities of interest:
bias_measures_withoutz <- results_withoutz %>%
  group_by(collider) %>%
  summarise(
    bias = mean(b1) / b1true,
    rmse = sqrt(mean((b1 - b1true)^2)),
    optimism = (sqrt(mean((b1-mean(b1))^2))) / (sqrt(mean(b1se^2)))
  )

bias_measures_withoutz


# Now we can wrap everything up with a nice visualisation of the
# differences.

# First I can combine our two bias/rmse/optimism tables together
# I add an id column here called model
bias_measures <- bind_rows(bias_measures_withz, bias_measures_withoutz, .id = "model")
bias_measures

# Now let's change that model column to be a bit more meaningful:
bias_measures <- bias_measures %>%
  mutate(
    model = ifelse(model == 1, "Regression with Collider", "Regression without Collider")
  )
bias_measures

# Now I can create a little visualisation
bias_measures %>%
  pivot_longer(c(-model, -collider)) %>%
  ggplot() +
  geom_line(aes(x = collider, y = value, colour = model)) +
  facet_grid(rows = ~name) +
  theme_minimal()





