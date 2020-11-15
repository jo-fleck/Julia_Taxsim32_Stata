
### Taxsim32 Integration for Julia using taxsim32.ado

# This file allows to prepare Taxsim32 input data in Julia and obtain imputed
# tax information using a simple function call. Requires Stata.

# Written and tested on MacOS (10.15.7 Catalina), Julia 1.5.1, Stata SE 14.0
# Maintained here: https://github.com/jo-fleck/Julia_Taxsim32_Stata
# Copyright (C) 2020 Johannes Fleck; www.jofleck.com // Johannes.Fleck@eui.eu

# My Julia Taxsim package will be available shortly (does not require Stata)


## Structure

# 1. Instructions
# 2. Function Definition
# 3. Example


## 1. Instructions

# To configure taxsim32_stata.jl, proceed as follows

# 1) Open Stata and install taxsim32.ado
# Instructions here: https://users.nber.org/~taxsim/taxsim32/stata-remote.html

# 2) Adjust the Julia system command to work on your machine (see lines 49 and 50)
# Mac: make sure the Stata executable is added to your PATH
# PC: point the command to the Stata exe file (I guess...)


## 2. Function Definition

function taxsim32_stata(dir, df) # (version: 1.0.0)

CSV.write(dir * "taxsim32_input.csv", df); # Save Taxsim32 input as csv

# Generate intermediate Stata do file: Loads taxsim32 input data, calls taxsim32.ado, saves taxsim32 output data
tmp_do_file = ["clear all", "cd " * dir, "import delimited using " * dir * "taxsim32_input.csv", "taxsim32, full", "use " * dir * "taxsim_out.dta, clear", "export delimited " * dir * "taxsim32_output.csv"]
outfile = dir * "tmp_do_file.do"
open(outfile, "w") do f
  for i in tmp_do_file
    println(f, i)
  end
end

# Create and issue system command
command_taxsim32_do = `stata-se -b do $outfile`;
process_taxsim32_do = run(command_taxsim32_do, wait = true);

df_taxsim32 = CSV.read(dir * "taxsim32_output.csv", DataFrame); # import Taxsim32 output

# Avoid cluttering: Remove tmp_do_file, csvs and files created by taxsim32.ado
rm(dir * "tmp_do_file.do"); rm(dir * "taxsim32_input.csv"); rm(dir * "taxsim32_output.csv");
rm(dir * "taxsim_out.dta"); rm(dir * "txpydata.raw"); rm(dir * "results.raw");
# rm("/Users/main/tmp_do_file.log"); # generated in main dir by taxsim32.ado

  return df_taxsim32

end


## 3. Example

using CSV, DataFrames

# Taxsim32 input: Dataframe with columns as required by taxsim32.ado (order, names)
df_taxsim32_input = DataFrame(year = 1970, mstat = 2, ltcg = 100000)

# Set directory (all generated files will be deleted after use)
dir = "/Users/main/Downloads/"

df_taxsim32_output = taxsim32_stata(main_dir, df_taxsim32_input)

# To use taxsim32_stata.jl as external function, save the code in 2. as a .jl file
# (or download from https://github.com/jo-fleck/Julia_Taxsim32_Stata.jl) and use
include("DIR/taxsim32_stata.jl")
