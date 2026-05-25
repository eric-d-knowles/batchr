#' Convert a notebook to an R script and submit it as a Slurm batch job
#'
#' Creates a timestamped run directory, extracts R code from a notebook using
#' [capture_code()], writes it to `job.R`, and generates (and optionally
#' submits) a Slurm batch script via [make_sbatch()].
#'
#' @param notebook Path to the notebook file (`.R`, `.Rmd`, `.qmd`, or
#'   `.ipynb`).
#' @param job_name A short name for the Slurm job. Also used as the name of the
#'   run subdirectory prefix.
#' @param run_root Path to the root directory where timestamped run directories
#'   are created. Defaults to `"/scratch/edk202/runs"`.
#' @param mode Passed to [capture_code()]. Either `"exclude"` (default) to
#'   strip code between `batch:start`/`batch:end` markers, or `"include"` to
#'   keep only that code.
#' @param submit Logical. If `TRUE`, the Slurm script is submitted immediately
#'   via `sbatch`. Defaults to `FALSE`.
#' @param ... Additional arguments passed to [make_sbatch()] (e.g., `cpus`,
#'   `mem`, `time`, `email`).
#'
#' @return Invisibly returns the path to the generated `.slurm` script.
#' @export
#'
#' @examples
#' \dontrun{
#' batchify("analysis.qmd", job_name = "my_analysis", cpus = 4, mem = "32G")
#' }
batchify <- function(notebook, job_name, run_root = "/scratch/edk202/runs",
                     mode = "exclude", submit = FALSE, ...) {
  run_dir <- file.path(run_root,
                       paste0(job_name, "_", format(Sys.time(), "%Y%m%d_%H%M%S")))
  dir.create(run_dir, recursive = TRUE, showWarnings = FALSE)
  code_file <- file.path(run_dir, "job.R")
  writeLines(capture_code(notebook, mode = mode), code_file)
  make_sbatch(r_script = code_file, job_name = job_name,
              log_dir  = run_dir,
              out_file = file.path(run_dir, paste0(job_name, ".slurm")),
              submit   = submit, ...)
}