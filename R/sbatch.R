#' Generate (and optionally submit) a Slurm batch script for an R job
#'
#' Writes a Slurm batch script that activates a conda environment and runs an R
#' script via `Rscript`. Optionally submits the job immediately with `sbatch`.
#'
#' @param r_script Path to the R script to run. Must exist.
#' @param job_name Slurm job name. Defaults to `"rjob"`.
#' @param cpus Number of CPUs per task. Defaults to `8L`.
#' @param mem Memory allocation string (e.g., `"64G"`). Defaults to `"64G"`.
#' @param time Wall-time limit in `"HH:MM:SS"` format. Defaults to
#'   `"12:00:00"`.
#' @param partition Slurm partition name. If `NULL` (default), no
#'   `--partition` directive is written.
#' @param array Slurm array specification (e.g., `"0-9"`). If `NULL`
#'   (default), no `--array` directive is written.
#' @param r_args Character vector of additional arguments passed to `Rscript`.
#'   Defaults to `character(0)`.
#' @param env Conda environment name to activate before running the script.
#'   Defaults to `"myR"`.
#' @param conda_sh Path to the conda `conda.sh` initialisation script.
#' @param log_dir Directory for Slurm log files. Created if it does not exist.
#'   Defaults to `"logs"`.
#' @param email Email address for Slurm notifications. If `NULL` (default), no
#'   mail directives are written.
#' @param mail_type Slurm mail event types. Defaults to `"END,FAIL"`.
#' @param extra_sbatch Character vector of additional raw `#SBATCH` directives
#'   to append.
#' @param out_file Path for the generated `.slurm` script. Defaults to a file
#'   named `<job_name>.slurm` in the same directory as `r_script`.
#' @param submit Logical. If `TRUE`, submits the script via `sbatch`
#'   immediately. Defaults to `FALSE`.
#'
#' @return Invisibly returns the path to the written `.slurm` file.
#' @export
#'
#' @examples
#' \dontrun{
#' make_sbatch("job.R", job_name = "my_job", cpus = 4, mem = "32G",
#'             email = "user@example.com", submit = TRUE)
#' }
make_sbatch <- function(
    r_script, job_name = "rjob", cpus = 8L, mem = "64G", time = "12:00:00",
    partition = NULL, array = NULL, r_args = character(0),
    env = "myR", conda_sh = "/share/apps/anaconda3/2025.06/etc/profile.d/conda.sh",
    log_dir = "logs", email = NULL, mail_type = "END,FAIL",
    extra_sbatch = character(0), out_file = NULL, submit = FALSE) {
  stopifnot(file.exists(r_script))
  dir.create(log_dir, recursive = TRUE, showWarnings = FALSE)
  if (is.null(out_file))
    out_file <- file.path(dirname(r_script), paste0(job_name, ".slurm"))
  log_path <- file.path(log_dir, if (is.null(array)) "%x_%j.out" else "%x_%A_%a.out")
  directives <- c(
    paste0("#SBATCH --job-name=", job_name),
    "#SBATCH --nodes=1", "#SBATCH --ntasks=1",
    paste0("#SBATCH --cpus-per-task=", cpus),
    paste0("#SBATCH --mem=", mem),
    paste0("#SBATCH --time=", time),
    paste0("#SBATCH --output=", log_path),
    if (!is.null(partition)) paste0("#SBATCH --partition=", partition),
    if (!is.null(array))     paste0("#SBATCH --array=", array),
    if (!is.null(email))     paste0("#SBATCH --mail-user=", email),
    if (!is.null(email))     paste0("#SBATCH --mail-type=", mail_type),
    extra_sbatch)
  body <- c(paste0('source "', conda_sh, '"'),
            paste0("conda activate ", env), "",
            paste(c("Rscript", shQuote(r_script), r_args), collapse = " "))
  writeLines(c("#!/bin/bash", directives, "", body, ""), out_file)
  message("Wrote ", out_file)
  if (submit)
    message(paste(system2("sbatch", shQuote(out_file), stdout = TRUE), collapse = "\n"))
  invisible(out_file)
}