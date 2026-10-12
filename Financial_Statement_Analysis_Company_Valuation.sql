CREATE DATABASE IF NOT EXISTS financial_statement_valuation;

USE financial_statement_valuation;

SELECT DATABASE();

-- PROJECT 6: Financial Statement Analysis & Company Valuation
-- MySQL 8.0+
-- Synthetic financial data; all monetary amounts are in INR.

CREATE DATABASE IF NOT EXISTS financial_statement_valuation;
USE financial_statement_valuation;

DROP TABLE IF EXISTS financial_statements;

CREATE TABLE financial_statements (
    fiscal_year INT PRIMARY KEY,
    revenue_inr DECIMAL(18,2) NOT NULL,
    cogs_inr DECIMAL(18,2) NOT NULL,
    gross_profit_inr DECIMAL(18,2) NOT NULL,
    sga_expenses_inr DECIMAL(18,2) NOT NULL,
    rd_expenses_inr DECIMAL(18,2) NOT NULL,
    ebitda_inr DECIMAL(18,2) NOT NULL,
    depreciation_amortization_inr DECIMAL(18,2) NOT NULL,
    ebit_inr DECIMAL(18,2) NOT NULL,
    interest_expense_inr DECIMAL(18,2) NOT NULL,
    tax_expense_inr DECIMAL(18,2) NOT NULL,
    net_income_inr DECIMAL(18,2) NOT NULL,
    capital_expenditure_inr DECIMAL(18,2) NOT NULL,
    cash_inr DECIMAL(18,2) NOT NULL,
    accounts_receivable_inr DECIMAL(18,2) NOT NULL,
    inventory_inr DECIMAL(18,2) NOT NULL,
    current_assets_inr DECIMAL(18,2) NOT NULL,
    property_plant_equipment_inr DECIMAL(18,2) NOT NULL,
    total_assets_inr DECIMAL(18,2) NOT NULL,
    current_liabilities_inr DECIMAL(18,2) NOT NULL,
    long_term_debt_inr DECIMAL(18,2) NOT NULL,
    total_liabilities_inr DECIMAL(18,2) NOT NULL,
    shareholders_equity_inr DECIMAL(18,2) NOT NULL,
    operating_cash_flow_inr DECIMAL(18,2) NOT NULL,
    free_cash_flow_inr DECIMAL(18,2) NOT NULL,
    tax_rate DECIMAL(6,4) NOT NULL
);

INSERT INTO financial_statements VALUES
(2021,820000000,500200000,319800000,118900000,28700000,172200000,31160000,141040000,17220000,30955000,92865000,36900000,45100000,94300000,73800000,246000000,344400000,590400000,155800000,180400000,336200000,254200000,115825000,78925000,0.25),
(2022,905000000,547525000,357475000,128510000,32580000,196385000,35295000,161090000,18100000,35747500,107242500,42535000,52490000,106790000,83260000,280550000,384625000,665175000,170140000,194575000,364715000,300460000,133487500,90952500,0.25),
(2023,1018000000,608764000,409236000,141502000,38684000,229050000,40720000,188330000,19342000,42247000,126741000,49882000,62098000,122160000,95692000,325760000,437740000,763500000,189348000,213780000,403128000,360372000,157281000,107399000,0.25),
(2024,1125000000,666000000,459000000,154125000,43875000,261000000,46125000,214875000,20250000,48656250,145968750,56250000,70875000,137250000,106875000,365625000,489375000,855000000,207000000,230625000,437625000,417375000,180843750,124593750,0.25),
(2025,1248000000,730080000,517920000,168480000,51168000,298272000,52416000,245856000,21216000,56160000,168480000,64896000,83616000,156000000,119808000,411840000,549120000,960960000,227136000,249600000,476736000,484224000,208416000,143520000,0.25);

-- Confirm that all five years loaded
SELECT *
FROM financial_statements
ORDER BY fiscal_year;


-- 1. Historical financial performance
SELECT
    fiscal_year,
    revenue_inr,
    gross_profit_inr,
    ebitda_inr,
    ebit_inr,
    net_income_inr
FROM financial_statements
ORDER BY fiscal_year;


-- 2. Profitability margins
SELECT
    fiscal_year,
    ROUND(gross_profit_inr / NULLIF(revenue_inr, 0) * 100, 2)
        AS gross_margin_pct,
    ROUND(ebitda_inr / NULLIF(revenue_inr, 0) * 100, 2)
        AS ebitda_margin_pct,
    ROUND(net_income_inr / NULLIF(revenue_inr, 0) * 100, 2)
        AS net_profit_margin_pct
FROM financial_statements
ORDER BY fiscal_year;


-- 3. Year-over-year revenue growth
SELECT
    fiscal_year,
    revenue_inr,
    ROUND(
        (revenue_inr / NULLIF(
            LAG(revenue_inr) OVER (ORDER BY fiscal_year), 0
        ) - 1) * 100,
        2
    ) AS revenue_growth_pct
FROM financial_statements
ORDER BY fiscal_year;


-- 4. Balance sheet analysis
SELECT
    fiscal_year,
    total_assets_inr,
    total_liabilities_inr,
    shareholders_equity_inr
FROM financial_statements
ORDER BY fiscal_year;


-- 5. Debt-to-equity ratio
SELECT
    fiscal_year,
    long_term_debt_inr,
    shareholders_equity_inr,
    ROUND(
        long_term_debt_inr /
        NULLIF(shareholders_equity_inr, 0),
        2
    ) AS debt_to_equity_ratio
FROM financial_statements
ORDER BY fiscal_year;


-- 6. Operating cash flow and free cash flow
SELECT
    fiscal_year,
    operating_cash_flow_inr,
    capital_expenditure_inr,
    free_cash_flow_inr
FROM financial_statements
ORDER BY fiscal_year;


-- 7. Expense breakdown as a percentage of revenue
SELECT
    fiscal_year,
    ROUND(cogs_inr / NULLIF(revenue_inr, 0) * 100, 2)
        AS cogs_pct,
    ROUND(sga_expenses_inr / NULLIF(revenue_inr, 0) * 100, 2)
        AS sga_pct,
    ROUND(rd_expenses_inr / NULLIF(revenue_inr, 0) * 100, 2)
        AS rd_pct,
    ROUND(interest_expense_inr / NULLIF(revenue_inr, 0) * 100, 2)
        AS interest_pct
FROM financial_statements
ORDER BY fiscal_year;


-- 8. Financial consistency checks
-- Both check columns should return 0.00
SELECT
    fiscal_year,
    ROUND(
        revenue_inr - cogs_inr - gross_profit_inr, 2
    ) AS gross_profit_check,
    ROUND(
        total_assets_inr - total_liabilities_inr
        - shareholders_equity_inr, 2
    ) AS balance_sheet_check
FROM financial_statements
ORDER BY fiscal_year;