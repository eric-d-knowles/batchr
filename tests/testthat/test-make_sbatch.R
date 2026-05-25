test_that("make_sbatch writes a .slurm file", {
  tmp_r <- tempfile(fileext = ".R")
  writeLines("x <- 1", tmp_r)
  out <- tempfile(fileext = ".slurm")
  make_sbatch(tmp_r, job_name = "test_job", out_file = out,
              log_dir = tempdir(), conda_sh = "/path/to/conda.sh")
  expect_true(file.exists(out))
})

test_that("make_sbatch script contains expected directives", {
  tmp_r <- tempfile(fileext = ".R")
  writeLines("x <- 1", tmp_r)
  out <- tempfile(fileext = ".slurm")
  make_sbatch(tmp_r, job_name = "myjob", cpus = 4, mem = "16G",
              time = "02:00:00", out_file = out, log_dir = tempdir(),
              conda_sh = "/path/to/conda.sh")
  lines <- readLines(out)
  expect_true(any(grepl("--job-name=myjob", lines)))
  expect_true(any(grepl("--cpus-per-task=4", lines)))
  expect_true(any(grepl("--mem=16G", lines)))
  expect_true(any(grepl("--time=02:00:00", lines)))
})

test_that("make_sbatch includes email directives when email provided", {
  tmp_r <- tempfile(fileext = ".R")
  writeLines("x <- 1", tmp_r)
  out <- tempfile(fileext = ".slurm")
  make_sbatch(tmp_r, job_name = "job", out_file = out,
              log_dir = tempdir(), email = "user@example.com",
              conda_sh = "/path/to/conda.sh")
  lines <- readLines(out)
  expect_true(any(grepl("--mail-user=user@example.com", lines)))
})

test_that("make_sbatch errors if r_script does not exist", {
  expect_error(make_sbatch("nonexistent.R", conda_sh = "/path/to/conda.sh"), "file.exists")
})

test_that("make_sbatch returns the output path invisibly", {
  tmp_r <- tempfile(fileext = ".R")
  writeLines("x <- 1", tmp_r)
  out <- tempfile(fileext = ".slurm")
  result <- make_sbatch(tmp_r, out_file = out, log_dir = tempdir(),
                        conda_sh = "/path/to/conda.sh")
  expect_equal(result, out)
})
