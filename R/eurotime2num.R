#' @title Conversion of Eurostat Time Format to Numeric
#' @description A conversion of a Eurostat time format to numeric.
#' @details Bi-annual, quarterly and monthly data is presented as fraction of
#'          the year in beginning of the period. Conversion of daily data is not
#'          supported.
#' @param x a charter string with time information in Eurostat time format.
#' @return see [as.numeric()].
#' @author Janne Huovari <janne.huovari@@ptt.fi>
#' @family helpers
#' @examplesIf check_access_to_data()
#' \donttest{
#' na_q <- get_eurostat("namq_10_pc", time_format = "raw")
#' na_q$time <- eurotime2num(x = na_q$time)
#'
#' unique(na_q$time)
#' }
#'
#' @export
eurotime2num <- function(x) {
  x <- as.factor(x)
  times <- levels(x)

  if (nchar(times[1]) > 7) {
    tcode <- substr(times[1], 8, 8) # daily
  } else {
    tcode <- substr(times[1], 5, 5) # type of time data
    if (tcode == "") tcode <- "Y"
  }


  # check input type
  if (!(tcode %in% c("Y", "S", "Q", "M", "_"))) {

    # for daily
    if (tcode == "D") {
      warning("Time format is daily data. No numeric conversion was made.")
      # for year intervals
    } else if (tcode == "_") {
      warning("Time format is a year interval. No numeric conversion was made.")
      # for unkown
    } else {
      warning("Unknown time code, ", tcode, ". No numeric conversion was made.\n
              Please fill bug report at https://github.com/rOpenGov/eurostat/issues.")
    }

    return(x)
  }

  year <- substr(times, 1, 4)
  subyear <- substr(times, 6, 7)
  subyear[subyear == ""] <- 1


  levels(x) <- as.numeric(year) +
    (as.numeric(subyear) - 1) * 1 / c(Y = 1, S = 2, Q = 4, M = 12)[tcode]
  y <- as.numeric(as.character(x))
  y
}

#' @title Conversion of Eurostat Time Format to Numeric
#' @description A conversion of a Eurostat time format to numeric.
#' @details 
#' Bi-annual (semester), quarterly, monthly and weekly data can be presented as 
#' a fraction of the year in beginning of the period. Conversion of daily data 
#' is not supported.
#' @param x a charter string with time information in Eurostat time format.
#' @return see [as.numeric()].
#' @author Janne Huovari <janne.huovari@@ptt.fi>, Pyry Kantanen
#' @family helpers
#' @examplesIf check_access_to_data()
#' \donttest{
#' na_q <- get_eurostat("namq_10_pc", time_format = "raw")
#' na_q$time <- eurotime2num(x = na_q$time)
#'
#' unique(na_q$time)
#' }
#'
#' @export
eurotime2num2 <- function(x) {
  x <- as.factor(x)
  times <- levels(x)
  
  if (nchar(times[1]) > 8) {
    # Finds the only format that is longer than YYYY-WNN (weeks, 8 chars)
    # Day/date notation: YYYY-MM-DD, 10 chars 
    # tcode <- substr(times[1], 8, 8)
    tcode <- "D"
  } else {
    # Possible tcodes: S, Q, 0 or 1 (months), W
    # tcode: type of time data
    tcode <- substr(times[1], 6, 6)
    # if tcode is empty, the data is probably annual
    if (tcode == "0" || tcode == "1") {
      tcode <- "M"
    } else if (tcode == "") {
      tcode <- "A"
    }
  }
  
  
  # check input type
  if (!(tcode %in% c("A", "S", "Q", "M", "W", "D"))) {
    
    # for daily
    if (tcode == "D") {
      warning("Time format is daily data. No numeric conversion was made.")
    } else {
      warning("Unknown time code, ", tcode, ". No numeric conversion was made.\n
              Please fill bug report at https://github.com/rOpenGov/eurostat/issues.")
    }
    
    return(x)
  }

  year <- substr(times, 1, 4)
  subyear <- substr(times, 6, 8)
  # The only characters that can be present are S, Q and W
  subyear <- gsub("[SQW]", "", subyear)

  subyear[subyear == ""] <- 1

  levels(x) <- as.numeric(year) +
    (as.numeric(subyear) - 1) * 1 / c(A = 1, S = 2, Q = 4, M = 12, W = 53)[tcode]
  y <- as.numeric(as.character(x))
  y
}
