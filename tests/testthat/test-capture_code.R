library(testthat)

test_that("multiplication works", {
  expect_equal(2 * 2, 4)
})

test_that("capture_code reads a plain .R file", {
  tmp <- tempfile(fileext = ".R")
  writeLines(c("x <- 1", "y <- 2"), tmp)
  result <- capture_code(tmp)
  expect_equal(result, c("x <- 1", "y <- 2"))
})

test_that("capture_code accepts a character vector directly", {
  code <- c("a <- 1", "b <- 2")
  expect_equal(capture_code(code), code)
})

test_that("exclude mode removes marked blocks", {
  code <- c(
    "before <- 1",
    "#| batch:start",
    "excluded <- 2",
    "#| batch:end",
    "after <- 3"
  )
  result <- capture_code(code, mode = "exclude")
  expect_true("before <- 1" %in% result)
  expect_true("after <- 3" %in% result)
  expect_false("excluded <- 2" %in% result)
})

test_that("include mode keeps only marked blocks", {
  code <- c(
    "before <- 1",
    "#| batch:start",
    "included <- 2",
    "#| batch:end",
    "after <- 3"
  )
  result <- capture_code(code, mode = "include")
  expect_equal(result, "included <- 2")
})

test_that("include mode errors when no markers present", {
  code <- c("x <- 1", "y <- 2")
  expect_error(capture_code(code, mode = "include"), "no batch:start/end markers")
})

test_that("unbalanced markers produce an error", {
  code <- c("#| batch:start", "x <- 1")
  expect_error(capture_code(code), "Unbalanced batch markers")
})

test_that("end before start produces an error", {
  code <- c("#| batch:end", "x <- 1", "#| batch:start")
  expect_error(capture_code(code), "batch:end precedes its start")
})
