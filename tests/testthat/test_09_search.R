test_that("search_eurostat finds", {
  skip_on_cran()
  skip_if_offline()
  expect_equal(
    search_eurostat(
      "Dwellings by type of housing, building and NUTS 3",
      type = "dataset"
    )$code[1],
    "cens_01rdhh"
  )
})
