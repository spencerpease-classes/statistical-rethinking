using Turing
using Optim
using StatsBase
using LinearAlgebra

"""
    quap(model args...; kwargs...)

From: https://github.com/StatisticalRethinkingJulia/TuringModels.jl/blob/master/src/quap_turing.jl
"""
function quap(model::Turing.Model, args...; kwargs...)
    opt = optimize(model, MAP(), args...; kwargs...)

    coef = opt.values.array
    var_cov_matrix = informationmatrix(opt)
    sym_var_cov_matrix = Symmetric(var_cov_matrix)  # lest MvNormal complains, loudly
    converged = Optim.converged(opt.optim_result)

    distr = if length(coef) == 1
        Normal(coef[1], √sym_var_cov_matrix[1])  # Normal expects stddev
    else
        MvNormal(coef, sym_var_cov_matrix)       # MvNormal expects variance matrix
    end

    (coef = coef, vcov = sym_var_cov_matrix, converged = converged, distr = distr)
end
