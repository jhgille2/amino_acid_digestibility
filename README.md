# Amino acid digestibility
Code for reading in and cleaning data from amino acid reports

## Overview
The code in this repository is organized as a [targets](https://books.ropensci.org/targets/) workflow and uses [renv](https://rstudio.github.io/renv/index.html) for dependency management. The best way to use the code in this repository is probaby to first [clone it to a new R project](https://happygitwithr.com/push-pull-github#make-a-repo-on-github), restore the environment with [renv::restore()](https://rstudio.github.io/renv/reference/restore.html), and then run the pipeline with `targets::tar_make()`. 

### Input files
The only input files used by this pipeline are an amino acid report file, and a table to map genotype names to sample ids in the report file. The paths to these two files are given in the `aa_report_file` and `genotype_lookup_file` targets. 

Potentially the most likely step to break with new data is the `full_aa_data` target. This is because this step involves joining the cleaned amino acid report data with the genotype lookup table to add genotype names following their names as indicated in the genotype lookup file. This step is likely to break because the join is particular about what columns it uses to join the two dataframes. The genotype lookup table has sample ids in the "id" column, and the cleaned amino acid has them in the "usda_id" column. Deviations from this column naming convention will lead to an error. This is easily fixed however by either changing the column names used to join the two dataframes in the `add_genotype_names` function, or in the genotype name lookup file itself to match what the function is expecting. 

