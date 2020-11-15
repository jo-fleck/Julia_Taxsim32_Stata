function taxsim32_stata(dir, df) # (version: 1.0.0)

CSV.write(dir * "taxsim32_input.csv", df); # Save Taxsim32 input as csv

# Generate intermediate Stata do file: Loads data, calls taxsim32.ado, saves results
tmp_do_file = ["clear all", "cd " * dir, "import delimited using " * dir * "taxsim32_input.csv", "taxsim32, full", "use " * dir * "taxsim_out.dta, clear", "export delimited " * dir * "taxsim32_output.csv"]
outfile = dir * "tmp_do_file.do"
open(outfile, "w") do f
  for i in tmp_do_file
    println(f, i)
  end
end

# Create and issue system command, import Taxsim32 output
command_taxsim32_do = `stata-se -b do $outfile`;
process_taxsim32_do = run(command_taxsim32_do, wait = true);
df_taxsim32 = CSV.read(dir * "taxsim32_output.csv", DataFrame);

# Avoid cluttering: Remove tmp_do_file, csvs and files created by taxsim32.ado
rm(dir * "tmp_do_file.do"); rm(dir * "taxsim32_input.csv"); rm(dir * "taxsim32_output.csv");
rm(dir * "taxsim_out.dta"); rm(dir * "txpydata.raw"); rm(dir * "results.raw");
rm("/Users/main/tmp_do_file.log"); # generated in main dir by taxsim32.ado

  return df_taxsim32

end
