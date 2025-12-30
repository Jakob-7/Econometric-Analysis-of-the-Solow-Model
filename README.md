# Economic Growth and Development  
### An Econometric Analysis of the Solow Model

This repository contains an econometrics project analyzing the determinants of **GDP per capita** using a cross-country panel dataset and the **Solow–Swan growth model** as the theoretical framework.

The project applies **ordinary least squares (OLS)** regression to study the relationship between economic growth, savings, population growth, and human capital.

---

## 🎯 Research Objective

The goal of this project is to empirically test the Solow growth model by estimating the relationship:

\[
\ln(\text{GDP per capita}) = \alpha + \beta \ln(s) - \gamma \ln(n) + \delta \ln(e)
\]

where:
- \( s \) is the savings rate  
- \( n \) is population growth  
- \( e \) is government spending on education (proxy for human capital)

---

## 📊 Data

The analysis uses publicly available **World Bank** datasets:

- **GDP per capita** (constant 2015 USD)
- **Gross savings** (% of GDP)
- **Population growth** (annual %)
- **Government spending on education** (% of GDP)

The final dataset consists of:
- **81 countries**
- **48 years**
- **3,763 observations**

---

## 🧹 Data Processing

Key preprocessing steps:
- Converted datasets from wide to long format
- Merged country-level data by year
- Removed countries and years with more than **30% missing values**
- Imputed remaining missing values using **country-specific means**
- Removed non-positive observations due to log transformation

---

## 📈 Econometric Models

### Baseline Model
\[
\ln(\text{GDP per capita}) = \alpha + \beta \ln(s) - \gamma \ln(n)
\]

Results:
- Savings rate positively and significantly associated with GDP per capita
- Population growth negatively and significantly associated with GDP per capita
- All coefficients statistically significant at the **1% level**
- Relatively low \( R^2 \), consistent with the simplicity of the Solow model

---

### Extended Model with Education
\[
\ln(\text{GDP per capita}) = \alpha + \beta \ln(s) - \gamma \ln(n) + \delta \ln(e)
\]

Key findings:
- Education spending is strongly and positively associated with GDP per capita
- Inclusion of education reduces **omitted variable bias**
- Savings and population coefficients shrink in magnitude
- \( R^2 \) increases substantially
- Residual standard error decreases, indicating improved model fit

---

## 🧠 Interpretation

- The baseline model overestimates the effect of savings and population due to omitted education effects
- Education is positively correlated with savings and negatively correlated with population growth
- Human capital plays a crucial role in explaining cross-country income differences
- Results are consistent with economic growth theory

---

## 📁 Repository Structure

```text
.
├── code/
│   ├── assignment1_part1.R
│   └── assignment1_part2.R
├── data/
│   └── (World Bank CSV files, not modified)
├── report.pdf
├── README.md
