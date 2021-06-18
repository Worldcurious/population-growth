## imports

using Plots
using Noise

## constants

STARTING_POP = 40e6
PLAGUE_KILLOFF = 0.6
POST_COLLAPSE_KILLOFF = 2 / 3

SURVIVING_POP = STARTING_POP * (1 - PLAGUE_KILLOFF) * (1 - POST_COLLAPSE_KILLOFF)
years = 0:30

## helper math functions

#sigmoid function
SIGMOID_K = 0.5
function sigmoid(x::Number)::AbstractFloat
    return 1 / (1 + exp(-SIGMOID_K * x))
end

## set annual growth rates year-by-year

# growth rate function has three main components:
# 1) decaying exponential that rises from -4 and approaches +4
# 2) logistic that starts at 0 and starts to drop toward -4 around 15-20 Years
# 3) gaussian noise with a std dev of 0.25

# this is to capture fairly rapid death early on,
# turning to rapid growth as things stabilize and people make babies,
# and eventually slowing as some semblance of modernity re-establishes

growth_rates = [(8 * (1 - exp(-0.5 * year)) - 4) + (4 * (sigmoid(-(year - 20)) - 1)) for year ∈ years]
add_gauss!(growth_rates, 0.25)

growth_plot = plot(years, growth_rates, legend=false)
ylabel!(growth_plot, "Annual Growth Rate (%)")
xlabel!(growth_plot, "Years Post-Collapse")
title!(growth_plot, "Population Growth Rate of California Republic")

## calculate population year-by-year

populations = zeros(length(years))

for i ∈ 1:length(populations)
    if i == 1
        populations[i] = SURVIVING_POP * (1 + (growth_rates[i] / 100))
    else
        populations[i] = populations[i - 1] * (1 + (growth_rates[i] / 100))
    end
end

pop_plot = plot(years, populations, legend=false)
ylabel!(pop_plot, "Population")
xlabel!(pop_plot, "Years Post-Collapse")
title!(pop_plot, "Population of the California Republic")

## put both plots together

plot(growth_plot, pop_plot, layout=(2,1), legend=false)