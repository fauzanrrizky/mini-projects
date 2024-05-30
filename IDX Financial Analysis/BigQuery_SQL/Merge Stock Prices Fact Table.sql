SELECT 
    sp.symbol,
    sp.date,
    sp.open,
    sp.high,
    sp.low,
    sp.close,
    sp.adj_close,
    sp.volume
FROM 
    `idx-analysis-424717.idx_analysis_dataset.fact_stock_prices` sp
JOIN 
    `idx-analysis-424717.idx_analysis_dataset.date_dim` d ON sp.date = d.date;

