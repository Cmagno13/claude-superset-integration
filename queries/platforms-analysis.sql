-- =============================================================================
-- Video Game Sales — Platform Analysis
-- =============================================================================
-- Top 10 gaming platforms by total global sales volume.
-- Used in the walkthrough to kick off the analysis.
--
-- Top 10 plataformas de videogame por volume total de vendas globais.
-- Usada no walkthrough para iniciar a análise.
--
-- Dataset: video_game_sales (Apache Superset examples database)
-- Tested on: SQLite, Superset 6.1.0rc2
-- =============================================================================

SELECT
    Platform,
    COUNT(*)           AS qty_games,
    SUM(Global_Sales)  AS total_sales_millions,
    AVG(Global_Sales)  AS avg_sales_per_game,
    MAX(Global_Sales)  AS top_hit_sales
FROM video_game_sales
GROUP BY Platform
ORDER BY total_sales_millions DESC
LIMIT 10;


-- =============================================================================
-- Expected output / Saída esperada
-- =============================================================================
--
-- Platform | qty_games | total_sales_millions | avg_sales_per_game | top_hit_sales
-- ---------+-----------+----------------------+--------------------+---------------
-- PS2      |      2161 |              1255.64 |              0.581 |         20.81
-- X360     |      1265 |               979.96 |              0.775 |         21.82
-- PS3      |      1329 |               957.84 |              0.721 |         21.40
-- Wii      |      1325 |               926.71 |              0.699 |         82.54
-- DS       |      2162 |               822.20 |              0.380 |         29.80
-- PS       |      1196 |               730.66 |              0.611 |         10.95
-- GBA      |       822 |               318.50 |              0.387 |         15.85
-- PSP      |      1213 |               296.28 |              0.244 |          7.67
-- PS4      |       336 |               278.10 |              0.828 |         14.63
-- PC       |       960 |               258.82 |              0.270 |         11.01


-- =============================================================================
-- Additional queries used in the walkthrough
-- Queries adicionais usadas no walkthrough
-- =============================================================================

-- Q2 — Sales by genre
SELECT Genre, SUM(Global_Sales) AS total
FROM video_game_sales
GROUP BY Genre
ORDER BY total DESC;

-- Q3 — Regional split (used as basis for the virtual dataset)
SELECT 'North America' AS region, SUM(NA_Sales) AS sales FROM video_game_sales
UNION ALL
SELECT 'Europe', SUM(EU_Sales) FROM video_game_sales
UNION ALL
SELECT 'Japan', SUM(JP_Sales) FROM video_game_sales
UNION ALL
SELECT 'Other', SUM(Other_Sales) FROM video_game_sales;

-- Q4 — Yearly sales trend
SELECT Year, SUM(Global_Sales) AS total
FROM video_game_sales
WHERE Year IS NOT NULL
GROUP BY Year
ORDER BY Year;

-- Q5 — Top 15 publishers by lifetime sales
SELECT Publisher, SUM(Global_Sales) AS total, COUNT(*) AS games
FROM video_game_sales
GROUP BY Publisher
ORDER BY total DESC
LIMIT 15;
