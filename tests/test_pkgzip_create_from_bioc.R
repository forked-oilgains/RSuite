#----------------------------------------------------------------------------
# RSuite
# Copyright (c) 2017, WLOG Solutions
#----------------------------------------------------------------------------
context("Testing if creation of PKGZIP from Bioconductor works properly [test_pkgzip_create_from_bioc]")

library(RSuite)
library(testthat)

source("R/test_utils.R")
source("R/project_management.R")
source("R/pkgzip_management.R")


test_that_managed("Create PKGZIP out of sources on Bioc (basic)", {
  prj <- init_test_project(repo_adapters = c("CRAN"))
  pkgzip <- init_test_pkgzip()

  RSuite::pkgzip_build_bioc_package("BiocGenerics",
                                    prj = prj, pkg_type = "source", path = pkgzip$path)

  expect_that_pkgzip_contains("BiocGenerics", type = "source", pkgzip = pkgzip)
})
