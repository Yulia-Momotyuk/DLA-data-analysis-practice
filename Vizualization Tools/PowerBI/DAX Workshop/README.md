[![View Repositories](https://img.shields.io/badge/View-My_Repositories-blue?logo=GitHub)](https://github.com/Yulia-Momotyuk?tab=repositories)
[![View My Profile](https://img.shields.io/badge/View-My_Profile-green?logo=GitHub)](https://github.com/Yulia-Momotyuk)
## Project Description 

This project was created as part of my learning exercises in Power BI and DAX to practice creating measures and calculated columns. The project is based on the Contoso report, which I reproduced and improved in terms of visualizations.

---

### What has been done
- Created a Power BI file (`Contoso DAX.pbix`) with all required measures and calculated columns.
- Used key DAX formulas for calculating sales, averages, customer and product counts.
- Applied row context and filter context for more flexible and accurate calculations.
- Created a calculated table for product category and brand combinations.
- Enhanced the report’s visual design for better data analysis experience.

---

### Key DAX formulas used
**Calculated columns:**
```
Sales amount CC = FactSales[Net Price] * FactSales[Quantity]
```
**Measures (with row context and context transition):**
```Sales amount = 
SUMX(
    FactSales,
    FactSales[Net Price] * FactSales[Quantity]
)

Avg Sales per transaction AVERAGEX = 
AVERAGEX(
    FactSales,
    FactSales[Net Price] * FactSales[Quantity]
)

Total Sales = 
CALCULATE(
    [Sales amount],
    ALL(FactSales)
)

Sales % = DIVIDE([Sales amount], [Total Sales])

Margin% = 
VAR _Sales = SUMX(FactSales, FactSales[Net Price] * FactSales[Quantity])
VAR _Costs = SUMX(FactSales, FactSales[Unit Cost] * FactSales[Quantity])
VAR _Profit = _Sales - _Costs
RETURN DIVIDE(_Profit, _Sales)```

## 📬 Contact

[LinkedIn](http://linkedin.com/in/yulia-kononchuk) | [Email](mailto:kononchuk.yuliia@gmail.com)

---
> **Author**: _Yuliia Kononchuk_  
> _This repository is part of my personal learning journey and professional portfolio._ 

