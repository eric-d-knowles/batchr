test_that("batchify creates a run directory and job.R", {
  tmp_r <- tempfile(fileext = ".R")
  writeLines(c("x <- 1", "y <- 2"), tmp_r)
  run_root <- tempdir()
  batchify(tmp_r, job_name = "test_job", run_root = run_root,
           conda_sh = "/path/to/conda.sh")
  run_dirs <- list.dirs(run_root, recursive = FALSE)
  job_dir <- run_dirs[grepl("test_job_", basename(run_dirs))]
  expect_true(length(job_dir) >= 1)
  expect_true(file.exists(file.path(job_dir[1], "job.R")))
})

test_that("batchify creates a .slurm script", {
  tmp_r <- tempfile(fileext = ".R")
  writeLines("x <- 1", tmp_r)
  slurm_path <- batchify(tmp_r, job_name = "slurm_test", run_root = tempdir(),
                         conda_sh = "/path/to/conda.sh")
  expect_true(file.exists(slurm_path))
  expect_true(grepl("[.]slurm$", slurm_path))
})

test_that("batchify returns the slurm path invisibly", {
  tmp_r <- tempfile(fileext = ".R")
  writeLines("x <- 1", tmp_r)
  result <- batchify(tmp_r, job_name = "ret_test", run_root = tempdir(),
                     conda_sh = "/path/to/conda.sh")
  expect_type(result, "character")
  expect_true(grepl("[.]slurm$", result))
})
