#' @export
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