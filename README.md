
# Connect Julia to Taxsim32 via Stata

"You provide the data, the [NBER TAXSIM program](https://taxsim.nber.org) returns the tax calculations from our server in seconds."

`Julia_Taxsim32_Stata.jl` illustrates how to prepare Taxsim32 input data in Julia and obtain imputed tax information using a simple function call to `taxsim32_stata.jl`. Requires Stata. Written and tested on MacOS (10.15.7 Catalina), Julia 1.5.1, Stata SE 14.0

## Instructions

To configure `taxsim32_stata.jl`, proceed as follows

1. Open Stata and install `taxsim32.ado`. Instructions here: https://users.nber.org/~taxsim/taxsim32/stata-remote.html

2. Adjust the Julia system command to work on your machine (see `taxsim32_stata.jl` lines 15 and 16)
- Mac: make sure the Stata executable is added to your PATH
- PC: point the command to the Stata exe file (I guess...)

## Example

```
using CSV, DataFrames

# Taxsim32 input: Dataframe with columns (order, names) as required by taxsim32.ado
df_taxsim32_input = DataFrame(year = 1970, mstat = 2, ltcg = 100000)

# Set directory (all generated files will be deleted after use)
dir = "/Users/main/Downloads/"

df_taxsim32_output = taxsim32_stata(main_dir, df_taxsim32_input)
```

