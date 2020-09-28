
library(ggplot2)
library(rethinking)
library(tibble)
library(tidyr)


# ex 2.1 ------------------------------------------------------------------

ways <- c(0, 3, 8, 9, 0)
ways / sum(ways)


# ex 2.2 ------------------------------------------------------------------

dbinom(6, size = 9, prob = 0.5)


# ex 2.3 ------------------------------------------------------------------

p_grid <- seq(0, 1, length.out = 20)
prior_unif <- rep(1, 20)
likelihood <- dbinom(6, size = 9, prob = p_grid)

grid_posterior <- function(likelihood, prior) {

  unstd_posterior <- likelihood * prior
  unstd_posterior / sum(unstd_posterior)

}

posterior_unif <- grid_posterior(likelihood, prior_unif)


# ex 2.4 ------------------------------------------------------------------

plot_grid_approx <- function(p_grid, posterior) {

  ggplot(data.frame(x = p_grid, y = posterior), aes(x = x, y = y)) +
    geom_line() +
    geom_point() +
    labs(x = "Prob. of water", y = "Posterior Prob.")

}

plot_grid_approx(p_grid, posterior_unif)


# ex 2.5 ------------------------------------------------------------------

prior_step <- ifelse(p_grid < 0.5, 0, 1)
prior_exp <- exp(-5 * abs(p_grid - 0.5))

posterior_step <- grid_posterior(likelihood, prior_step)
posterior_exp <- grid_posterior(likelihood, prior_exp)

plot_grid_approx(p_grid, posterior_step)
plot_grid_approx(p_grid, posterior_exp)


# ex 2.6 ------------------------------------------------------------------

W <- 6
L <- 3

globe_qa <- quap(
  alist(
    W ~ dbinom(W + L, p),
    p ~ dunif(0, 1)
  ),
  data = list(W = W, L = L)
)

quap_result <- precis(globe_qa)


# ex 2.7 ------------------------------------------------------------------

plot_quap_exact <-
  tibble(
    x = seq(0, 1, length.out = 100),
    exact = dbeta(x, W + 1, L + 1),
    quap = dnorm(x, quap_result[["mean"]], quap_result[["sd"]])
  ) %>%
  pivot_longer(!x, names_to = "method", values_to = "density") %>%
  ggplot(aes(x = x, y = density, color = method)) +
  geom_line() +
  labs(subtitle = paste("n =", W + L), x = "Prop. water", y = "Density")

plot_quap_exact


# ex 2.8 ------------------------------------------------------------------

n_samples <- 1000
p <- rep(NA_real_, n_samples)
p[1] <- 0.5

for (i in 2:n_samples) {

  p_new <- rnorm(1, p[i - 1], 0.1)

  if (p_new < 0) p_new <- abs(p_new)
  if (p_new > 1) p_new <- 2 - p_new

  q0 <- dbinom(W, W + L, p[i - 1])
  q1 <- dbinom(W, W + L, p_new)

  p[i] <- ifelse(runif(1) < q1/q0, p_new, p[i - 1])

}


# ex 2.9 ------------------------------------------------------------------

plot_mcmc_exact <-
  tibble(
    mcmc = p,
    exact = qbeta(seq(0, 1, length.out = n_samples), W + 1, L + 1)
  ) %>%
  pivot_longer(everything(), names_to = "method", values_to = "density") %>%
  ggplot(aes(x = density, color = method)) +
  geom_density() +
  xlim(0, 1)

plot_mcmc_exact
