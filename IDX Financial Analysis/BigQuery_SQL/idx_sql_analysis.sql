-- Which companies have the highest total assets in the balance sheet last year? (2023)
WITH CompanyBalanceSheet AS (
    SELECT 
      f.symbol, b.total_assets
    FROM 
      `idx-analysis-424717.idx_analysis_dataset.fact_financials` AS f
    JOIN 
      `idx-analysis-424717.idx_analysis_dataset.balance_sheet_dim` AS b ON f.balance_sheet_id = b.balance_sheet_id
    where 
      f.year=(
        SELECT MAX(f.Year)
        FROM `idx-analysis-424717.idx_analysis_dataset.fact_financials` AS f
      )   
)
SELECT 
  c.symbol, c.company_name, cb.total_assets
FROM 
  CompanyBalanceSheet AS cb
JOIN 
  `idx-analysis-424717.idx_analysis_dataset.company_dim` AS c ON cb.symbol = c.symbol
ORDER BY 
  cb.total_assets DESC
LIMIT 10;



-- List the top 5 companies that had the highest net income margin percentage in the latest available year
WITH LatestYear AS (
    SELECT 
      MAX(year) AS latest_year
    FROM 
      `idx-analysis-424717.idx_analysis_dataset.fact_financials`
),
NetIncomeMargin AS (
    SELECT 
      f.symbol, c.company_name, i.net_margin_percent, f.year
    FROM 
      `idx-analysis-424717.idx_analysis_dataset.fact_financials` AS f
    JOIN 
      `idx-analysis-424717.idx_analysis_dataset.income_statement_dim` AS i ON f.income_statement_id = i.income_statement_id
    JOIN 
      `idx-analysis-424717.idx_analysis_dataset.company_dim` AS c ON f.symbol = c.symbol
    WHERE 
      f.year = (SELECT latest_year FROM LatestYear)
)
SELECT 
  symbol, company_name, net_margin_percent
FROM 
  NetIncomeMargin
ORDER BY 
  net_margin_percent DESC
LIMIT 5;



-- List the companies with bad debt ratio (liabilites to asset >60%) on 2023
SELECT 
  f.symbol, b.liabilities_to_assets_percent
FROM 
  `idx-analysis-424717.idx_analysis_dataset.fact_financials` AS f
JOIN 
  `idx-analysis-424717.idx_analysis_dataset.balance_sheet_dim` AS b ON f.balance_sheet_id = b.balance_sheet_id
WHERE 
  b.liabilities_to_assets_percent > 60 AND f.Year = 2023
ORDER BY 
  b.liabilities_to_assets_percent DESC;



-- List the company income growth rate in the last two years
WITH last_two_years_net_income AS (
  SELECT 
    f. symbol, f.Year, i.net_income
  FROM
    `idx-analysis-424717.idx_analysis_dataset.fact_financials` AS f
  JOIN
    `idx-analysis-424717.idx_analysis_dataset.income_statement_dim` AS i ON f.income_statement_id = i.income_statement_id
  WHERE 
    f.Year IN (SELECT MAX(Year) FROM `idx-analysis-424717.idx_analysis_dataset.fact_financials`)
    OR f.year IN (SELECT MAX(Year)-1 FROM `idx-analysis-424717.idx_analysis_dataset.fact_financials`)
), 
income_growth_table AS (
  SELECT 
    r1.symbol,
    (r2.net_income - r1.net_income)/r1.net_income * 100 AS income_growth
  FROM last_two_years_net_income r1
  JOIN last_two_years_net_income r2 ON r1.symbol = r2.symbol AND r2.Year=r1.year+1
  WHERE 
    r1.Year = (
      SELECT MAX(Year) - 1
      FROM last_two_years_net_income
    )
)
SELECT 
  i.symbol,
  i.income_growth,
  s.sector
FROM 
  income_growth_table AS i
JOIN `idx-analysis-424717.idx_analysis_dataset.company_dim` AS s ON i.symbol = s.symbol
ORDER BY
  i.income_growth DESC;

-- RUmus: (r2.net_income - r1.net_income)/r1.net_income * 100




