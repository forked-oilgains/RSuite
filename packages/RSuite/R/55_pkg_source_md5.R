#----------------------------------------------------------------------------
# RSuite
# Copyright (c) 2017, WLOG Solutions
#
# Utilities related to project package source change detection.
#----------------------------------------------------------------------------

#'
#' Checks if packages sources have been changed since last check.
#'
#' It caches check results for subsequent builds.
#'
#' @param pkg_dir name of package folder. (type: character)
#' @param params project parameters package belongs to.
#' @param pkg_type check for the package type.
#'
#' @return TRUE if some changes detected.
#'
#' @keywords internal
#'
has_package_changed <- function(pkg_dir, params, pkg_type) {
  contrib_url <- rsuite_contrib_url(params$get_intern_repo_path(), pkg_type, params$r_ver)
  pkg_path <- file.path(params$pkgs_path, pkg_dir)

  build_name <- get_package_build_name(pkg_path, pkg_type)

  md5_fpath <- file.path(contrib_url, gsub("^(.+)[.](tag[.]gz|tgz|zip)$", ".\\1.md5src.rds", build_name))
  if (!file.exists(file.path(contrib_url, build_name))) {
    pkg_logfinest("... no built package file found")
    unlink(md5_fpath, force = T)
    return(TRUE)
  }

  curr_md5 <- collect_pkg_source_md5(pkg_path)
  if (!file.exists(md5_fpath)) {
    pkg_logfinest("... no cached package md5 sums detected")
    saveRDS(curr_md5, file = md5_fpath)
    return(TRUE)
  }

  prev_md5 <- readRDS(md5_fpath)
  changes <- merge(x = curr_md5, y = prev_md5,
                   by.x = c("file"), by.y = c("file"),
                   all.x = T, all.y = T)
  changes <- changes[is.na(changes$md5.x) | is.na(changes$md5.y) | changes$md5.x != changes$md5.y, ]

  if (nrow(changes) == 0) {
    return(FALSE)
  }

  pkg_logfinest(sprintf("... changes detected in %s", changes$file))
  saveRDS(curr_md5, file = md5_fpath)
  return(TRUE)
}

#'
#' Generates name of package output file.
#'
#' @param pkg_path path to package folder.
#' @param pkg_type type of package output file.
#'
#' @return name of output package file to be generated.
#'
#' @keywords internal
#'
get_package_build_name <- function(pkg_path, pkg_type) {
  desc <- read.dcf(file.path(pkg_path, "DESCRIPTION"))
  pkg_name <- desc[1, "Package"]
  pkg_ver <- desc[1, "Version"]

  if (pkg_type == "source") {
    ext <- ".tar.gz"
  } else if (.Platform$OS.type == "windows") {
    ext <- ".zip"
  } else if (grepl("darwin", R.version$os)) {
    ext <- ".tgz"
  } else {
    ext <- paste0("_R_", Sys.getenv("R_PLATFORM"), ".tar.gz")
  }
  return(paste0(desc[1, "Package"], "_", desc[1, "Version"], ext))
}

#'
#' Collects MD5 sums for all package files important for building
#'
#' @param path to package folder.
#'
#' @return data.frame with columns file and md5.
#'
#' @keywords internal
#'
collect_pkg_source_md5 <- function(pkg_path) {
  files <- c(file.path(pkg_path, c("DESCRIPTION", "NAMESPACE")),
             list.files(file.path(pkg_path, c("inst", "data", "man", "R")),
                        recursive = T, full.names = T))
  sums <- tools::md5sum(files)

  res <- data.frame(file = names(sums), md5 = sums, stringsAsFactors = F, row.names = NULL)
  res$file <- substr(res$file, start = nchar(pkg_path)+1, stop = 1000000L)
  return(res)
}