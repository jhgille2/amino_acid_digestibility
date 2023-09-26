## Load your packages, e.g. library(targets).
source("./packages.R")

## Load your R files
lapply(list.files("./R", full.names = TRUE), source)

## tar_plan supports drake-style targets and also tar_target()
tar_plan(

# target = function_to_make(arg), ## drake style

# tar_target(target2, function_to_make2(arg)) ## targets style
  
  tar_file(example_aa,
           here::here("data", "example_amino_acid_data.xls")),
  
  # The raw amino acid data
  tar_file(aa_report_file,
           here::here("data", "raw data", "11238 Shea.xls")), 
  
  # A table to assign genotype names to IDs
  tar_file(genotype_lookup_file,
           here::here("data", "genotype_lookup_table.csv")),
  
  # Clean the raw amino acid data file
  tar_target(clean_aa_data,
             clean_aa_report(aa_report_file)),
  
  # Add the genotype names to the cleaned data
  tar_target(full_aa_data,
             add_genotype_names(genotype_lookup_file, clean_aa_data))

)
