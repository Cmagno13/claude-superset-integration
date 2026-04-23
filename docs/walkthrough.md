# The Walkthrough / O Walkthrough

This document reproduces the real conversation used to build the 22-chart dashboard from zero.

Este documento reproduz a conversa real usada para construir o dashboard de 22 gráficos do zero.

---

## 🇺🇸 English

### Phase 1 — Orientation (5 minutes)

```
You: Do a health check on my Superset and show me the version and uptime.
```

Claude calls `health_check` and returns status, version (6.1.0rc2), uptime (~2h47min).

```
You: Give me an overview of my Superset instance.
```

Claude calls `get_instance_info` and returns: 13 dashboards, 160 charts, 28 datasets, 1 database (SQLite), 3 users, 5 roles. Plus recent activity (last 7 days: 113 charts modified, 23 datasets updated).

```
You: List the 10 most recently modified datasets.
```

Claude calls `list_datasets` with `order_column=changed_on, order_direction=desc, page_size=10`. Returns ranked list with ID, table name, database.

### Phase 2 — Exploration (5 minutes)

```
You: I'm interested in the video_game_sales dataset. Show me the columns, 
      data types, and suggest 3 interesting analyses.
```

Claude calls `get_dataset_info` on the dataset ID. Finds there are TWO related datasets:
- `video_game_sales_by_region` (virtual, 2 columns)
- `video_game_sales` (physical, 11 columns) ← the real one

Returns the column schema and proposes 3 analyses:
1. Regional genre preferences (heatmap)
2. Platform lifecycle over time (line chart)
3. Publisher market concentration (treemap)

### Phase 3 — SQL analysis (5 minutes)

```
You: Run this query and show me the results:

SELECT Platform, COUNT(*) as qty, SUM(Global_Sales) as total
FROM video_game_sales
GROUP BY Platform
ORDER BY total DESC
LIMIT 10
```

Claude uses `execute_sql` with `database_id=1, sql=...`. Returns formatted table:

| Platform | Games | Sales (M) |
|----------|------:|----------:|
| PS2 | 2,161 | 1,255.64 |
| X360 | 1,265 | 979.96 |
| PS3 | 1,329 | 957.84 |
| Wii | 1,325 | 926.71 |
| DS | 2,162 | 822.20 |
| ... | ... | ... |

### Phase 4 — Building charts (8 minutes)

Key insight: `generate_chart` exposes schemas for 7 chart families. Check with:

```python
get_chart_type_schema(chart_type="big_number", include_examples=True)
```

Then create charts with `generate_chart` + `save_chart=True`.

Example creation — horizontal bar chart:

```
You: Create a horizontal bar chart showing the top 10 platforms by global sales.
```

Config passed to `generate_chart`:
```json
{
  "chart_name": "Top 10 Platforms by Sales",
  "dataset_id": 25,
  "save_chart": true,
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

Returns chart ID (e.g. 156) and explore URL.

See [`examples/chart-configs.md`](../examples/chart-configs.md) for all 22 chart configs.

### Phase 5 — Dashboard assembly (2 minutes)

```
You: Create a dashboard with all the charts I just built.
```

Claude calls `generate_dashboard`:

```json
{
  "dashboard_title": "Video Game Sales — Full Analysis",
  "chart_ids": [154, 155, 156, ... 176],
  "published": true
}
```

Returns dashboard ID 13 with auto-positioned grid layout.

### Phase 6 — Debugging (2 minutes)

When the dashboard threw `Found invalid orderby options`, Claude diagnosed it by analyzing which charts had `sort_by` in their config, then used `update_chart` to remove the malformed parameter. See [`limitations.md`](limitations.md).

### Total time

About 20 minutes of chat, mostly reading Claude's responses. Actual keyboard time was probably ~5 minutes of typing.

---

## 🇧🇷 Português

### Fase 1 — Orientação (5 minutos)

```
Você: Faça um health check no meu Superset e me mostre a versão e o uptime.
```

Claude chama `health_check` e retorna status, versão (6.1.0rc2), uptime (~2h47min).

```
Você: Me dê uma visão geral da minha instância do Superset.
```

Claude chama `get_instance_info` e retorna: 13 dashboards, 160 charts, 28 datasets, 1 banco (SQLite), 3 usuários, 5 roles. Mais atividade recente (últimos 7 dias: 113 charts modificados, 23 datasets atualizados).

```
Você: Liste os 10 datasets mais recentemente modificados.
```

Claude chama `list_datasets` com `order_column=changed_on, order_direction=desc, page_size=10`. Retorna lista ordenada com ID, nome da tabela, banco.

### Fase 2 — Exploração (5 minutos)

```
Você: Estou interessado no dataset video_game_sales. Me mostre as colunas, 
       tipos de dado, e sugira 3 análises interessantes.
```

Claude chama `get_dataset_info` no ID do dataset. Descobre que existem DOIS datasets relacionados:
- `video_game_sales_by_region` (virtual, 2 colunas)
- `video_game_sales` (físico, 11 colunas) ← o real

Retorna o schema de colunas e propõe 3 análises:
1. Preferências regionais de gênero (heatmap)
2. Ciclo de vida de plataformas (line chart)
3. Concentração de mercado por publisher (treemap)

### Fase 3 — Análise SQL (5 minutos)

```
Você: Rode esta query e me mostre os resultados:

SELECT Platform, COUNT(*) as qtd, SUM(Global_Sales) as total
FROM video_game_sales
GROUP BY Platform
ORDER BY total DESC
LIMIT 10
```

Claude usa `execute_sql` com `database_id=1, sql=...`. Retorna tabela formatada:

| Plataforma | Jogos | Vendas (M) |
|------------|------:|-----------:|
| PS2 | 2.161 | 1.255,64 |
| X360 | 1.265 | 979,96 |
| PS3 | 1.329 | 957,84 |
| Wii | 1.325 | 926,71 |
| DS | 2.162 | 822,20 |
| ... | ... | ... |

### Fase 4 — Criando charts (8 minutos)

Insight-chave: `generate_chart` expõe schemas de 7 famílias de chart. Cheque com:

```python
get_chart_type_schema(chart_type="big_number", include_examples=True)
```

Depois crie charts com `generate_chart` + `save_chart=True`.

Exemplo de criação — bar chart horizontal:

```
Você: Crie um bar chart horizontal mostrando as top 10 plataformas por vendas globais.
```

Config passado para `generate_chart`:
```json
{
  "chart_name": "Top 10 Plataformas por Vendas",
  "dataset_id": 25,
  "save_chart": true,
  "config": {
    "chart_type": "xy",
    "kind": "bar",
    "orientation": "horizontal",
    "x": {"name": "platform"},
    "y": [{"name": "global_sales", "aggregate": "SUM"}],
    "row_limit": 10,
    "x_axis": {"title": "Plataforma"},
    "y_axis": {"title": "Vendas Globais (milhões)"}
  }
}
```

Retorna ID do chart (ex: 156) e URL do explore.

Veja [`examples/chart-configs.md`](../examples/chart-configs.md) para todas as 22 configs.

### Fase 5 — Montagem do dashboard (2 minutos)

```
Você: Crie um dashboard com todos os charts que acabei de construir.
```

Claude chama `generate_dashboard`:

```json
{
  "dashboard_title": "Video Game Sales — Análise Completa",
  "chart_ids": [154, 155, 156, ... 176],
  "published": true
}
```

Retorna dashboard ID 13 com layout em grid auto-posicionado.

### Fase 6 — Debugging (2 minutos)

Quando o dashboard deu o erro `Found invalid orderby options`, o Claude diagnosticou analisando quais charts tinham `sort_by` no config, depois usou `update_chart` para remover o parâmetro mal formatado. Veja [`limitations.md`](limitations.md).

### Tempo total

Cerca de 20 minutos de chat, a maior parte lendo as respostas do Claude. Tempo real de teclado foi provavelmente ~5 minutos digitando.
