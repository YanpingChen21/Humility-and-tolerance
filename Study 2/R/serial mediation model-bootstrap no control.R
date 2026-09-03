

library(lavaan)
library(semTools)
library(dplyr)
library(readr)
library(openxlsx)
library(tidySEM)
library(ggplot2)
library(semPlot)



data <- read.csv(
  "XXX",
  header = TRUE
)



x_vars <- c("humtot", "hex", "bhs", "cole")

controls <- c("Attitude", "gender", "age")


make_serial_model <- function(xvar) {
  
  model <- paste0("

    # Regressions
    Authentichumilityfeelings ~ a1*", xvar, " + c1*Attitude + c2*gender + c3*age
    Degradinghumilityfeelings ~ a2*", xvar, " + d1*Attitude + d2*gender + d3*age
    
    emptot ~ b1*Authentichumilityfeelings 
           + b2*Degradinghumilityfeelings 
           + a3*", xvar, " 
           + e1*Attitude + e2*gender + e3*age
    
    toltot ~ cprime*", xvar, "
           + f1*Authentichumilityfeelings
           + f2*Degradinghumilityfeelings
           + b3*emptot
           + t1*Attitude + t2*gender + t3*age

    
    # X -> Authentic humility -> Tolerance
    ind_auth_tol := a1*f1
    
    # X -> Degrading humility -> Tolerance
    ind_degr_tol := a2*f2
    
    # X -> Empathy -> Tolerance
    ind_emp_tol := a3*b3
    
    # X -> Authentic humility -> Empathy -> Tolerance
    ind_auth_emp_tol := a1*b1*b3
    
    # X -> Degrading humility -> Empathy -> Tolerance
    ind_degr_emp_tol := a2*b2*b3
    
    # Total indirect effect
    total_indirect := ind_auth_tol 
                    + ind_degr_tol 
                    + ind_emp_tol 
                    + ind_auth_emp_tol 
                    + ind_degr_emp_tol
    
    # Total effect
    total_effect := cprime + total_indirect
  ")
  
  return(model)
}



run_serial_model_mlr <- function(xvar, data) {
  
  fit <- sem(
    model = make_serial_model(xvar),
    data = data,
    estimator = "MLR",
    missing = "fiml",
    fixed.x = FALSE
  )
  
  return(fit)
}



run_serial_model_boot <- function(xvar, data, nboot = 5000) {
  
  fit <- sem(
    model = make_serial_model(xvar),
    data = data,
    estimator = "ML",
    se = "bootstrap",
    bootstrap = nboot,
    missing = "fiml",
    fixed.x = FALSE
  )
  
  return(fit)
}



fits_mlr <- lapply(x_vars, run_serial_model_mlr, data = data)
names(fits_mlr) <- x_vars



set.seed(12345)

fits_boot <- lapply(
  x_vars,
  run_serial_model_boot,
  data = data,
  nboot = 5000
)

names(fits_boot) <- x_vars



for (x in x_vars) {
  cat("\n\n==============================\n")
  cat("MLR Model with X =", x, "\n")
  cat("==============================\n")
  
  print(summary(
    fits_mlr[[x]],
    fit.measures = TRUE,
    standardized = TRUE,
    rsquare = TRUE
  ))
}



for (x in x_vars) {
  cat("\n\n==============================\n")
  cat("Bootstrap indirect effects with X =", x, "\n")
  cat("==============================\n")
  
  boot_results <- parameterEstimates(
    fits_boot[[x]],
    standardized = TRUE,
    ci = TRUE,
    boot.ci.type = "perc"
  ) %>%
    filter(op == ":=")
  
  print(boot_results)
}


extract_mlr_results <- function(fit, xvar) {
  
  parameterEstimates(
    fit,
    standardized = TRUE,
    ci = TRUE
  ) %>%
    mutate(X = xvar) %>%
    select(
      X,
      lhs,
      op,
      rhs,
      label,
      est,
      se,
      z,
      pvalue,
      ci.lower,
      ci.upper,
      std.all
    )
}

all_mlr_results <- bind_rows(
  lapply(names(fits_mlr), function(x) extract_mlr_results(fits_mlr[[x]], x))
)

direct_paths_mlr <- all_mlr_results %>%
  filter(op == "~")

effects_mlr <- all_mlr_results %>%
  filter(op == ":=")



extract_boot_results <- function(fit, xvar) {
  
  parameterEstimates(
    fit,
    standardized = TRUE,
    ci = TRUE,
    boot.ci.type = "perc"
  ) %>%
    mutate(X = xvar) %>%
    select(
      X,
      lhs,
      op,
      rhs,
      label,
      est,
      se,
      z,
      pvalue,
      ci.lower,
      ci.upper,
      std.all
    )
}

all_boot_results <- bind_rows(
  lapply(names(fits_boot), function(x) extract_boot_results(fits_boot[[x]], x))
)

direct_paths_boot <- all_boot_results %>%
  filter(op == "~")

effects_boot <- all_boot_results %>%
  filter(op == ":=")


bootstrap_indirect_effects <- effects_boot %>%
  filter(label %in% c(
    "ind_auth_tol",
    "ind_degr_tol",
    "ind_emp_tol",
    "ind_auth_emp_tol",
    "ind_degr_emp_tol",
    "total_indirect",
    "total_effect"
  )) %>%
  arrange(X, label)


r2_emp_tol <- bind_rows(
  lapply(names(fits_mlr), function(x) {
    
    r2 <- inspect(fits_mlr[[x]], "r2")
    
    data.frame(
      X = x,
      Outcome = names(r2),
      R2 = as.numeric(r2)
    )
  })
) %>%
  filter(Outcome %in% c("emptot", "toltot")) %>%
  mutate(
    Outcome = recode(
      Outcome,
      "emptot" = "Empathy",
      "toltot" = "Tolerance"
    )
  )

r2_emp_tol


fit_indices_mlr <- bind_rows(
  lapply(names(fits_mlr), function(x) {
    fitMeasures(
      fits_mlr[[x]],
      c(
        "chisq.scaled",
        "df.scaled",
        "pvalue.scaled",
        "cfi.scaled",
        "tli.scaled",
        "rmsea.scaled",
        "srmr",
        "aic",
        "bic"
      )
    ) %>%
      as.data.frame() %>%
      t() %>%
      as.data.frame() %>%
      mutate(X = x) %>%
      select(X, everything())
  })
)



fit_indices_boot_ml <- bind_rows(
  lapply(names(fits_boot), function(x) {
    fitMeasures(
      fits_boot[[x]],
      c(
        "chisq",
        "df",
        "pvalue",
        "cfi",
        "tli",
        "rmsea",
        "srmr",
        "aic",
        "bic"
      )
    ) %>%
      as.data.frame() %>%
      t() %>%
      as.data.frame() %>%
      mutate(X = x) %>%
      select(X, everything())
  })
)



wb <- createWorkbook()

addWorksheet(wb, "MLR Direct paths")
writeData(wb, "MLR Direct paths", direct_paths_mlr)

addWorksheet(wb, "MLR Indirect total effects")
writeData(wb, "MLR Indirect total effects", effects_mlr)

addWorksheet(wb, "MLR Fit indices")
writeData(wb, "MLR Fit indices", fit_indices_mlr)

addWorksheet(wb, "MLR R-squared")
writeData(wb, "MLR R-squared", r2_emp_tol)

addWorksheet(wb, "Bootstrap Direct paths")
writeData(wb, "Bootstrap Direct paths", direct_paths_boot)

addWorksheet(wb, "Bootstrap indirect effects")
writeData(wb, "Bootstrap indirect effects", bootstrap_indirect_effects)

addWorksheet(wb, "Bootstrap all effects")
writeData(wb, "Bootstrap all effects", effects_boot)

addWorksheet(wb, "Bootstrap ML Fit indices")
writeData(wb, "Bootstrap ML Fit indices", fit_indices_boot_ml)

saveWorkbook(
  wb,
  "MLR_and_bootstrap_5000_serial_mediation_results.xlsx",
  overwrite = TRUE
)


direct_paths_mlr
effects_mlr
fit_indices_mlr
r2_emp_tol

bootstrap_indirect_effects
effects_boot
fit_indices_boot_ml

