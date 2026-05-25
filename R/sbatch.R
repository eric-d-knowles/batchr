#' @export
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