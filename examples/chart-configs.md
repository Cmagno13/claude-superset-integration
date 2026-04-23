# Chart Configurations / Configurações de Chart

Ready-to-use JSON payloads for creating charts via the `generate_chart` MCP tool. All use `dataset_id: 25` (the `video_game_sales` example dataset) — adjust for your own dataset.

Payloads JSON prontos para criar charts via ferramenta MCP `generate_chart`. Todos usam `dataset_id: 25` (dataset de exemplo `video_game_sales`) — ajuste para seu próprio dataset.

---

## Big Number — Total global sales

```json
{
  "dataset_id": 25,
  "save_chart": true,
  "chart_name": "Total Global Sales",
  "config": {
    "chart_type": "big_number",
    "metric": {"name": "global_sales", "aggregate": "SUM"},
    "subheader": "Millions of units sold (all games)",
    "y_axis_format": ",.0f"
  }
}
```

## Big Number — Distinct publishers

```json
{
  "dataset_id": 25,
  "save_chart": true,
  "chart_name": "Distinct Publishers",
  "config": {
    "chart_type": "big_number",
    "metric": {"name": "publisher", "aggregate": "COUNT_DISTINCT"},
    "subheader": "Total publishers in catalog",
    "y_axis_format": ",.0f"
  }
}
```

## Horizontal Bar — Top 10 platforms

```json
{
  "dataset_id": 25,
  "save_chart": true,
  "chart_name": "Top 10 Platforms by Sales",
  "config": {
    "chart_type": "xy",
    "kind": "bar",
    "orientation": "horizontal",
    "x": {"name": "platform"},
    "y": [{"name": "global_sales", "aggregate": "SUM"}],
    "row_limit": 10,
    "x_axis": {"title": "Platform"},
    "y_axis": {"title": "Global Sales (millions)"}
  }
}
```

## Line Chart — Sales by year, grouped by platform

```json
{
  "dataset_id": 25,
  "save_chart": true,
  "chart_name": "Sales by Platform Over Years",
  "config": {
    "chart_type": "xy",
    "kind": "line",
    "x": {"name": "year"},
    "y": [{"name": "global_sales", "aggregate": "SUM"}],
    "group_by": [{"name": "platform"}],
    "x_axis": {"title": "Year"},
    "y_axis": {"title": "Global Sales (millions)"}
  }
}
```

## Stacked Area — Sales by genre over years

```json
{
  "dataset_id": 25,
  "save_chart": true,
  "chart_name": "Sales by Year and Genre",
  "config": {
    "chart_type": "xy",
    "kind": "area",
    "stacked": true,
    "x": {"name": "year"},
    "y": [{"name": "global_sales", "aggregate": "SUM"}],
    "group_by": [{"name": "genre"}],
    "x_axis": {"title": "Year"},
    "y_axis": {"title": "Global Sales (millions)"}
  }
}
```

## Scatter Plot — NA sales vs EU sales

```json
{
  "dataset_id": 25,
  "save_chart": true,
  "chart_name": "NA vs EU Sales Correlation",
  "config": {
    "chart_type": "xy",
    "kind": "scatter",
    "x": {"name": "na_sales"},
    "y": [{"name": "eu_sales", "aggregate": "SUM"}],
    "row_limit": 500,
    "x_axis": {"title": "North America Sales (M)"},
    "y_axis": {"title": "Europe Sales (M)"}
  }
}
```

## Pie Chart — Sales by genre

```json
{
  "dataset_id": 25,
  "save_chart": true,
  "chart_name": "Sales by Genre",
  "config": {
    "chart_type": "pie",
    "dimension": {"name": "genre"},
    "metric": {"name": "global_sales", "aggregate": "SUM"},
    "row_limit": 15
  }
}
```

## Mixed Chart — Sales + game count by year (dual axis)

```json
{
  "dataset_id": 25,
  "save_chart": true,
  "chart_name": "Sales and Game Count by Year",
  "config": {
    "chart_type": "mixed_timeseries",
    "x": {"name": "year"},
    "y": [{"name": "global_sales", "aggregate": "SUM"}],
    "y_secondary": [{"name": "name", "aggregate": "COUNT"}],
    "primary_kind": "line",
    "secondary_kind": "bar",
    "x_axis": {"title": "Year"},
    "y_axis": {"title": "Global Sales (millions)"},
    "y_axis_secondary": {"title": "Game Count"}
  }
}
```

## Table — Top 20 games (raw mode)

```json
{
  "dataset_id": 25,
  "save_chart": true,
  "chart_name": "Top 20 Best-Selling Games",
  "config": {
    "chart_type": "table",
    "columns": [
      {"name": "rank"},
      {"name": "name"},
      {"name": "platform"},
      {"name": "year"},
      {"name": "genre"},
      {"name": "publisher"},
      {"name": "global_sales"}
    ],
    "row_limit": 20
  }
}
```

⚠️ **Do NOT add `"sort_by": ["rank"]`** — it breaks dashboards. See [`limitations.md`](../docs/limitations.md) § 3.

## Table — Aggregated by platform

```json
{
  "dataset_id": 25,
  "save_chart": true,
  "chart_name": "Platform Rankings (Aggregate)",
  "config": {
    "chart_type": "table",
    "columns": [
      {"name": "platform"},
      {"name": "name", "aggregate": "COUNT"},
      {"name": "global_sales", "aggregate": "SUM"},
      {"name": "global_sales", "aggregate": "AVG"},
      {"name": "global_sales", "aggregate": "MAX"}
    ],
    "row_limit": 30
  }
}
```

## Pivot Table — Genre × Platform

```json
{
  "dataset_id": 25,
  "save_chart": true,
  "chart_name": "Genre × Platform Matrix",
  "config": {
    "chart_type": "pivot_table",
    "rows": [{"name": "genre"}],
    "columns": [{"name": "platform"}],
    "metrics": [{"name": "global_sales", "aggregate": "SUM"}]
  }
}
```

---

## Tip: the 2-step chart creation pattern

Dica: o padrão de 2 passos para criar charts.

Before calling `generate_chart`, introspect the schema for the chart type you want:

Antes de chamar `generate_chart`, inspecione o schema do tipo de chart que você quer:

```
get_chart_type_schema(chart_type="mixed_timeseries", include_examples=True)
```

The response tells you exactly which fields are required and their constraints. This saves a lot of trial-and-error when the MCP API rejects payloads.

A resposta diz exatamente quais campos são obrigatórios e suas restrições. Economiza muita tentativa-e-erro quando a API MCP rejeita payloads.
