# Example 1

# end goal - see the bias in the estimate of B1 in a bivariate regression models
# in the presence of a confounder (that might be unmeasured in real life)
library(tidyverse)


# DGP
# with no confounding
obs <- 1000 # Number of observations in data

sim <- tibble(
  e = rnorm(obs, 0, 4),
  z = rnorm(obs, 0, 2),
  x = rnorm(obs, 0, 2),
  y = 1 + 2*x + 2*z + e
)

# Run a model to test coefficient matches
mod <- lm(data = sim, y ~ x)
summary(mod)

# Now simulate the same with confounding
sim <- tibble(
  e = rnorm(obs, 0, 4),
  z = rnorm(obs, 0, 2),
  x = 0.5*z + rnorm(obs, 0, 2),
  y = 1 + 2*x + 2*z + e
)

# What happens to the coefficient now?
mod <- lm(data = sim, y ~ x)
summary(mod)

# Let's bring this together in a simple loop
# that works through a few different values of 
# the effect Z has on Y:
set.seed(12345)
for (b2 in seq(0, 3, 1)) {
  sim <- tibble(
    e = rnorm(obs, 0, 4),
    z = rnorm(obs, 0, 2),
    x = 0.5*z + rnorm(obs, 0, 2),
    y = 1 + 2*x + b2*z + e
  )
  mod <- lm(data = sim, y ~ x)
  print(coefficients(mod))
}


# Example 2
#' Now we're going to be building up a much more
#' realistic simulation where we perform 100 iterations
#' of the same simulation and save the results of 
#' each iteration to a dataframe as we go.

# Create a results dataframe for our results to 
# be stored
obs <- 1000
b1true <- 2
results <- tibble(
  iteration = numeric(),
  sample_size = numeric(),
  b2true = numeric(),
  b1 = numeric(),
  b0 = numeric(),
  b1se = numeric(),
  b0se = numeric()
)

set.seed(2345)
for (b2 in seq(0, 3, 1)) {
  for (iteration in 1:300) {
    # simulate the data
    sim <- tibble(
      e = rnorm(obs, 0, 4), # residual unexplained variance
      z = rnorm(obs, 0, 2), # simulate the confounder
      x = 0.5*z + rnorm(obs, 0, 2), # simulate x (impacted by confounder)
      y = 1 + b1true*x + b2*z + e # simulate y, with varying covariance with z
    )
    # create a regression model
    mod <- lm(data = sim, y ~ x)
    # create a new vector that can be appended to our 
    # results dataframe
    res <- c(
      iteration = iteration,
      sample_size = obs,
      b2true = b2, # Add the true value for b2 for this iteration
      b1 = coefficients(mod)["x"][[1]], # Add the coefficient for x for this iteration
      b0 = coefficients(mod)["(Intercept)"][[1]], # Add the intercept
      b1se = sqrt(diag(vcov(mod)))["x"][[1]], # Add the standard error for b1
      b0se = sqrt(diag(vcov(mod)))["(Intercept)"][[1]] # Add the standard error for the intercept
      )
    # append our results to our results dataframe
    results <- results %>% bind_rows(res)
  }
}

# Now we can calculate our quantities of interest
bias_measures <- results %>%
  group_by(b2true) %>%
  summarise(
    bias = mean(b1) / b1true,
    rmse = sqrt(mean((b1 - b1true)^2)),
    optimism = (sqrt(mean((b1-mean(b1))^2))) / (sqrt(mean(b1se^2)))
  )

bias_measures

# We can create a simple graph of how optimism,
# bias, and rmse change as b2true increases
bias_measures %>%
  pivot_longer(-b2true) %>%
  mutate(
    target = case_when(name == "bias" ~ 1,
                       name == "rmse" ~ 0,
                       name == "optimism" ~ 1)
  ) %>%
  ggplot() +
  aes(x = b2true, y = value) +
  geom_point() +
  geom_line() +
  geom_hline(aes(yintercept = target)) +
  facet_wrap(~name)

# we can also plot the results to show variation
results %>%
  ggplot() +
  geom_density(aes(x = b1)) +
  geom_vline(xintercept = b1true) +
  facet_grid(rows = vars(factor(b2true)))


