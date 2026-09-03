

library(lavaan)
library(semTools)
library(dplyr)
library(readr)
library(openxlsx)


data <- read.csv(
  "XXX",
  header = TRUE
)


x_vars <- c("humtot", "hex", "bhs", "cole")

controls <- c("Attitude")



run_serial_model <- function(xvar, data) {
  
  model <- paste0("
    # -------------------------
    # Regressions
    # -------------------------
    Authentichumilityfeelings ~ a1*", xvar, " + c1*Attitude
    Degradinghumilityfeelings ~ a2*", xvar, " + d1*Attitude
    
    emptot ~ b1*Authentichumilityfeelings 
           + b2*Degradinghumilityfeelings 
           + a3*", xvar, " 
           + e1*Attitude
    
    toltot ~ cprime*", xvar, "
           + f1*Authentichumilityfeelings
           + f2*Degradinghumilityfeelings
           + b3*emptot
           + t1*Attitude

    
    # Indirect effects
    
    
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
  
  fit <- sem(
    model,
    data = data,
    estimator = "MLR",
    missing = "fiml",
    fixed.x = FALSE
  )
  
  return(fit)
}



fits <- lapply(x_vars, run_serial_model, data = data)
names(fits) <- x_vars



for (x in x_vars) {
  cat("\n\n==============================\n")
  cat("Model with X =", x, "\n")
  cat("==============================\n")
  
  print(summary(
    fits[[x]],
    fit.measures = TRUE,
    standardized = TRUE,
    rsquare = TRUE
  ))
}



extract_results <- function(fit, xvar) {
  
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

all_results <- bind_rows(
  lapply(names(fits), function(x) extract_results(fits[[x]], x))
)




# all regression paths
direct_paths <- all_results %>%
  filter(op == "~")

# indirect / total effects
effects <- all_results %>%
  filter(op == ":=")



fit_indices <- bind_rows(
  lapply(names(fits), function(x) {
    fitMeasures(
      fits[[x]],
      c("chisq.scaled", "df.scaled", "pvalue.scaled",
        "cfi.scaled", "tli.scaled",
        "rmsea.scaled", "srmr",
        "aic", "bic")
    ) %>%
      as.data.frame() %>%
      t() %>%
      as.data.frame() %>%
      mutate(X = x) %>%
      select(X, everything())
  })
)


wb <- createWorkbook()

addWorksheet(wb, "Direct paths")
writeData(wb, "Direct paths", direct_paths)

addWorksheet(wb, "Indirect and total effects")
writeData(wb, "Indirect and total effects", effects)

addWorksheet(wb, "Fit indices")
writeData(wb, "Fit indices", fit_indices)

saveWorkbook(wb, "MLR_serial_mediation_results.xlsx", overwrite = TRUE)



direct_paths
effects
fit_indices

library(tidySEM)
library(ggplot2)

for (x in names(fits)) {
  
  layout_x <- get_layout(
    x, "", "emptot", "toltot",
    "", "Authentichumilityfeelings", "", "",
    "", "Degradinghumilityfeelings", "", "",
    rows = 3
  )
  
  p <- graph_sem(
    fits[[x]],
    layout = layout_x
  )
  
  print(p)
  
  ggsave(
    filename = paste0(x, "_SEM_plot.png"),
    plot = p,
    width = 12,
    height = 8,
    dpi = 300
  )
}

p_humtot <- graph_sem(
  fits[["humtot"]],
  layout = get_layout(
    "humtot", "", "emptot", "toltot",
    "", "Authentichumilityfeelings", "", "",
    "", "Degradinghumilityfeelings", "", "",
    rows = 3
  )
)

p_humtot


install.packages("semPlot")
library(semPlot)

semPaths(
  fits[["humtot"]],
  what = "std",              
  whatLabels = "std",
  layout = "tree",
  residuals = FALSE,  
  intercepts = FALSE, 
  exoCov = FALSE,
  edge.label.cex = 1.2,
  sizeMan = 10,
  curvePivot = TRUE
)