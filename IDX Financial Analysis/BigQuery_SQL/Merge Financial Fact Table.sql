SELECT 
    f.symbol,
    f.year,
    bs.total_assets,
    bs.total_liabilities,
    bs.liabilities_to_assets,
    cf.financing_cash,
    cf.investing_cash,
    cf.operating_cash,
    isd.net_income,
    isd.total_revenue,
    isd.net_margin_perc,
    ks.market_cap,
    ks.shares_outstanding,
    ks.dividend_yield,
    ks.eps,
    ks.pe_ratio,
    sp.date,
    sp.open,
    sp.high,
    sp.low,
    sp.close,
    sp.adj_close,
    sp.volume
FROM 
    `idx-analysis-424717.idx_analysis_dataset.fact_financials`f
JOIN 
    balance_sheet_dim bs ON f.balance_sheet_id = bs.balance_sheet_id
JOIN 
    cash_flow_dim cf ON f.cash_flow_id = cf.cash_flow_id
JOIN 
    income_statement_dim isd ON f.income_statement_id = isd.income_statement_id
JOIN 
    key_stats_dim ks ON f.symbol = ks.symbol
JOIN 
    fact_stock_prices sp ON f.symbol = sp.symbol
JOIN 
    company_dim c ON f.symbol = c.symbol
JOIN 
    date_dim d ON sp.date = d.date
