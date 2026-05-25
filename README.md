
<!-- README.md is generated from README.Rmd. Please edit that file -->

# batchr

<!-- badges: start -->

[![R-CMD-check](https://github.com/eric-d-knowles/batchr/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/eric-d-knowles/batchr/actions/workflows/R-CMD-check.yaml)
<!-- badges: end -->

`batchr` makes it easy to submit R, R Markdown, Quarto, and Jupyter
notebooks as batch jobs on a [Slurm](https://slurm.schedmd.com/) HPC
cluster. It extracts R code from your notebook, writes it to a
standalone script, and generates a ready-to-submit `.slurm` job file —
all in one call.

## Installation

You can install the development version of batchr from
[GitHub](https://github.com/) with:

``` r
# install.packages("pak")
pak::pak("eric-d-knowles/batchr")
```

## Usage

### Submit a notebook as a Slurm job

`batchify()` is the main entry point. It converts a notebook to an R
script, creates a timestamped run directory, and generates (and
optionally submits) a Slurm batch script.

``` r
library(batchr)

batchify(
  "analysis.qmd",
  job_name = "my_analysis",
  run_root = "/scratch/user/runs",
  conda_sh = "/path/to/conda.sh",
  cpus     = 8,
  mem      = "64G",
  time     = "12:00:00",
  email    = "you@example.com",
  submit   = TRUE
)
```

### Selective code extraction

You can mark sections of your notebook to exclude from (or include in)
the batch job using paired marker comments:

    #| batch:start
    # This block is excluded when mode = "exclude" (the default)
    # or the only code run when mode = "include"
    #| batch:end

For example, to skip interactive visualisation code when running on the
cluster:

``` r
batchify("analysis.qmd", mode = "exclude")
```

### Generate a Slurm script without submitting

Use `make_sbatch()` directly if you want to inspect or edit the `.slurm`
file before submitting:

``` r
make_sbatch(
  "job.R",
  job_name = "my_job",
  conda_sh = "/path/to/conda.sh",
  cpus     = 4,
  mem      = "32G",
  submit   = FALSE
)
```

### Extract R code from a notebook

`capture_code()` extracts R code from any supported notebook format and
returns it as a character vector:

``` r
code <- capture_code("analysis.qmd", mode = "exclude")
```

## Supported notebook formats

| Format     | Extension |
|------------|-----------|
| R script   | `.R`      |
| R Markdown | `.Rmd`    |
| Quarto     | `.qmd`    |
| Jupyter    | `.ipynb`  |

# …existing code…—

## `)  submit   = FALSE  mem      = "32G",  cpus     = 4,  conda_sh = "/path/to/conda.sh",  job_name = "my_job",  "job.R",make_sbatch(` r# …existing code…`)  submit   = TRUE  email    = "you@example.com",  time     = "12:00:00",  mem      = "64G",  cpus     = 8,  conda_sh = "/path/to/conda.sh",  run_root = "/scratch/user/runs",  job_name = "my_analysis",  "analysis.qmd",batchify(library(batchr)` routput: github_document

<!-- README.md is generated from README.Rmd. Please edit that file -->

# batchr

<!-- badges: start -->

[![R-CMD-check](https://github.com/eric-d-knowles/batchr/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/eric-d-knowles/batchr/actions/workflows/R-CMD-check.yaml)
<!-- badges: end -->

`batchr` makes it easy to submit R, R Markdown, Quarto, and Jupyter
notebooks as batch jobs on a [Slurm](https://slurm.schedmd.com/) HPC
cluster. It extracts R code from your notebook, writes it to a
standalone script, and generates a ready-to-submit `.slurm` job file —
all in one call.

## Installation

You can install the development version of batchr from
[GitHub](https://github.com/) with:

``` r
# install.packages("pak")
pak::pak("eric-d-knowles/batchr")
```

## Usage

### Submit a notebook as a Slurm job

`batchify()` is the main entry point. It converts a notebook to an R
script, creates a timestamped run directory, and generates (and
optionally submits) a Slurm batch script.

``` r
library(batchr)

batchify(
  "analysis.qmd",
  job_name = "my_analysis",
  run_root = "/scratch/user/runs",
  cpus     = 8,
  mem      = "64G",
  time     = "12:00:00",
  email    = "you@example.com",
  submit   = TRUE
)
```

### Selective code extraction

You can mark sections of your notebook to exclude from (or include in)
the batch job using paired marker comments:

    #| batch:start
    # This block is excluded when mode = "exclude" (the default)
    # or the only code run when mode = "include"
    #| batch:end

For example, to skip interactive visualisation code when running on the
cluster:

``` r
batchify("analysis.qmd", mode = "exclude")
```

### Generate a Slurm script without submitting

Use `make_sbatch()` directly if you want to inspect or edit the `.slurm`
file before submitting:

``` r
make_sbatch(
  "job.R",
  job_name = "my_job",
  cpus     = 4,
  mem      = "32G",
  submit   = FALSE
)
```

### Extract R code from a notebook

`capture_code()` extracts R code from any supported notebook format and
returns it as a character vector:

``` r
code <- capture_code("analysis.qmd", mode = "exclude")
```

## Supported notebook formats

| Format     | Extension |
|------------|-----------|
| R script   | `.R`      |
| R Markdown | `.Rmd`    |
| Quarto     | `.qmd`    |
| Jupyter    | `.ipynb`  |
