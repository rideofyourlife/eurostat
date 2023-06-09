#' @title Harmonize Country Code
#' @description The European Commission and the Eurostat generally uses ISO
#'    3166-1 alpha-2 codes with two exceptions: EL (not GR) is used to
#'    represent Greece, and UK (not GB) is used to represent the
#'    United Kingdom. This function turns country codes into to ISO
#'    3166-1 alpha-2.
#' @param x A character or a factor vector of eurostat countycodes.
#' @export
#' @author Janne Huovari <janne.huovari@@ptt.fi>
#' @return a vector.
#' @family helpers
#' @examplesIf check_access_to_data()
#' \donttest{
#' lp <- get_eurostat("nama_10_lp_ulc")
#' lp$geo <- harmonize_country_code(lp$geo)
#' }
#'
harmonize_country_code <- function(x) {
  if (is.factor(x)) {
    levels(x) <- harmonize_country_code(levels(x))
  } else {
    x <- gsub("EL", "GR", x)
    x <- gsub("UK", "GB", x)
  }
  x
}
