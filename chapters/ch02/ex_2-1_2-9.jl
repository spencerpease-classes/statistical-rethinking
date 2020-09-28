using Distributions: Binomial, pdf
using StatsPlots
using Turing

include(pwd() * "/functions/quap.jl")

# ex 2.1 ------------------------------------------------------------------

ways = [0, 3, 8, 9, 0]
ways / sum(ways)


# ex 2.2 ------------------------------------------------------------------

dbinom(k, n, p) = binomial(n, k) * p^k * (1-p)^(n-k)
dbinom(6, 9, .5)
# or
pdf(Binomial(9, 0.5), 6)


# ex 2.3 ------------------------------------------------------------------

p_grid = range(0, 1, length=20)
prior_unif = ones(20)
likelihood = [pdf(Binomial(9, p), 6) for p ∈ p_grid]

function grid_posterior(likelihood, prior)
    unstd_posterior = likelihood .* prior
    unstd_posterior / sum(unstd_posterior)
end

posterior_unif = grid_posterior(likelihood, prior_unif)


# ex 2.4 ------------------------------------------------------------------

function plot_grid_approx(p_grid, posterior)
    plot(
        p_grid, posterior,
        marker="o-", legend=false,
        xlab="Prob. of water", ylab="Posterior Prob."
    )
end

plot_grid_approx(p_grid, posterior_unif)

# ex 2.5 ------------------------------------------------------------------

prior_step = @. ifelse(p_grid < 0.5, 0, 1)
prior_exp = @. exp(-5 * abs(p_grid - 0.5))

posterior_step = grid_posterior(likelihood, prior_step)
posterior_exp = grid_posterior(likelihood, prior_exp)

plot_grid_approx(p_grid, posterior_step)
plot_grid_approx(p_grid, posterior_exp)


# ex 2.6 ------------------------------------------------------------------

@model globe_qa(W, L) = begin
    p ~ Uniform(0, 1)
    W ~ Binomial(W + L, p)
end

W, L = (6, 3) .* 1

quap_result = globe_qa(W, L) |> quap
println(quap_result.distr)

# ex 2.7 ------------------------------------------------------------------

plot(quap_result.distr, label="quap")
plot!(Beta(W+1, L+1), label="exact")
plot!(xlabel="Prop. of water", ylabel="Density", title="n = $(W+L)")


# ex 2.8 ------------------------------------------------------------------

n_samples = 1000
p = Array{Float64}(undef, n_samples)
p[1] = 0.5

for i ∈ 2:n_samples

    p_new = rand(Normal(p[i-1], 0.1))
    p_new < 0 && (p_new = abs(p_new))
    p_new > 1 && (p_new = 2 - p_new)

    q0, q1 = @. pdf(Binomial(W+L, (p[i-1], p_new)), W)

    p[i] = rand(Uniform()) < q1/q0 ? p_new : p[i-1]

end

density(p, label="MCMC")
plot!(Beta(W+1, L+1), label="Exact")
