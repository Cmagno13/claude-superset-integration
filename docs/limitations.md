# Known Limitations / Limitações Conhecidas

Tested on Superset MCP Service `6.1.0rc2` + Claude Opus 4.7, April 2026.

Testado no Superset MCP Service `6.1.0rc2` + Claude Opus 4.7, abril/2026.

---

## 🇺🇸 English

### 1. Limited chart type coverage

`generate_chart` exposes schemas for only **7 chart families**:

| Type | Covers |
|------|--------|
| `big_number` | Big Number, Big Number with Trendline |
| `xy` | Line, Bar, Area, Scatter (via `kind` parameter) |
| `pie` | Pie, Donut |
| `mixed_timeseries` | Mixed charts (two axes, two chart types) |
| `pivot_table` | Pivot Table |
| `table` | Table, AG-Grid Table |
| `handlebars` | Handlebars templates |

**Not creatable via MCP** (but supported in Superset UI):

- Treemap, Sunburst
- Heatmap, Calendar Heatmap
- Radar, Gauge, Funnel
- Sankey, Chord Diagram, Graph Chart
- Waterfall, Box Plot, Histogram
- Word Cloud, Horizon Chart
- All deck.gl types (3D Hexagon, Arc, Heatmap, Polygon, Scatterplot, etc.)
- All map types (Country Map, World Map, MapBox, Cartodiagram)
- Paired t-test Table
- Gantt Chart

**Workaround:** create these through the Superset UI and add them to dashboards separately.

### 2. Big Number with Trendline requires true temporal columns

Attempting to create a Big Number with Trendline using a `BIGINT` year column fails with:

```
Big Number trendline requires a temporal SQL column; 'year' is not temporal.
```

This happens with the example `video_game_sales` dataset because `year` is stored as `BIGINT`, not `DATE`/`TIMESTAMP`.

**Workaround:** edit the dataset in Superset and either:
- Change the column type to `DATE`/`TIMESTAMP`, or
- Create a calculated column that casts it (`CAST(year || '-01-01' AS DATE)`), or
- Use a regular Big Number without trendline + a separate Line Chart

### 3. Table `sort_by` parameter silently corrupts charts

`generate_chart` accepts `sort_by: ["rank"]` (a list of strings) without complaining, but the Superset frontend expects `[[col, direction]]` tuples. The chart saves successfully, renders in isolation, but breaks the dashboard with:

```
Error: Found invalid orderby options
```

**Reproduction:**

```json
{
  "chart_type": "table",
  "columns": [{"name": "rank"}, {"name": "name"}],
  "sort_by": ["rank"]
}
```

**Fix:** remove `sort_by` at creation and let users click column headers to sort. Or use `update_chart` to remove the malformed field from already-created charts.

```json
{
  "identifier": "162",
  "config": {
    "chart_type": "table",
    "columns": [...],
    "row_limit": 20
  }
}
```

(Note the absence of `sort_by`.)

### 4. Virtual dataset fragility

Virtual datasets (dataset ID 28 = `video_game_sales_by_region`) are SQL views on top of physical tables. Any chart built on them warns:

```
This chart uses a virtual dataset (SQL-based). If the dataset is deleted, this chart will break.
```

**Workaround:** none needed if you don't plan to delete the virtual dataset. But worth knowing.

### 5. `list_datasets` column filter requires exact operator names

The filter DSL is strict:

```json
// ❌ Fails:
{"filters": [{"col": "table_name", "opr": "ct", "value": "video_game_sales"}]}

// ✅ Works:
{"filters": [{"col": "table_name", "opr": "ilike", "value": "%video_game_sales%"}]}
```

Valid operators: `eq, ne, sw, ew, in, nin, gt, gte, lt, lte, like, ilike, is_null, is_not_null`.

### 6. Parameter names are case- and style-sensitive

Several endpoints wrap parameters inside a `request` object:

```json
// ❌ Fails:
{"dataset_id": 28}

// ✅ Works:
{"request": {"identifier": "28"}}
```

Always test with a small payload first.

---

## 🇧🇷 Português

### 1. Cobertura limitada de tipos de chart

O `generate_chart` expõe schemas para apenas **7 famílias de chart**:

| Tipo | Cobre |
|------|-------|
| `big_number` | Big Number, Big Number with Trendline |
| `xy` | Line, Bar, Area, Scatter (via parâmetro `kind`) |
| `pie` | Pie, Donut |
| `mixed_timeseries` | Mixed charts (dois eixos, dois tipos) |
| `pivot_table` | Pivot Table |
| `table` | Table, AG-Grid Table |
| `handlebars` | Templates Handlebars |

**Não criáveis via MCP** (mas suportados na UI do Superset):

- Treemap, Sunburst
- Heatmap, Calendar Heatmap
- Radar, Gauge, Funnel
- Sankey, Chord Diagram, Graph Chart
- Waterfall, Box Plot, Histogram
- Word Cloud, Horizon Chart
- Todos os tipos deck.gl (3D Hexagon, Arc, Heatmap, Polygon, Scatterplot, etc.)
- Todos os tipos de mapa (Country Map, World Map, MapBox, Cartodiagram)
- Paired t-test Table
- Gantt Chart

**Contorno:** crie esses na UI do Superset e adicione nos dashboards separadamente.

### 2. Big Number com Trendline exige colunas temporais reais

Tentar criar um Big Number com Trendline usando uma coluna `year` do tipo `BIGINT` falha com:

```
Big Number trendline requires a temporal SQL column; 'year' is not temporal.
```

Isso acontece com o dataset de exemplo `video_game_sales` porque `year` é armazenado como `BIGINT`, não `DATE`/`TIMESTAMP`.

**Contorno:** edite o dataset no Superset e:
- Mude o tipo da coluna para `DATE`/`TIMESTAMP`, ou
- Crie uma coluna calculada que faça o cast (`CAST(year || '-01-01' AS DATE)`), ou
- Use um Big Number normal sem trendline + um Line Chart separado

### 3. Parâmetro `sort_by` em Table corrompe charts silenciosamente

O `generate_chart` aceita `sort_by: ["rank"]` (lista de strings) sem reclamar, mas o frontend do Superset espera tuplas `[[col, direção]]`. O chart é salvo, renderiza isoladamente, mas quebra o dashboard com:

```
Error: Found invalid orderby options
```

**Reprodução:**

```json
{
  "chart_type": "table",
  "columns": [{"name": "rank"}, {"name": "name"}],
  "sort_by": ["rank"]
}
```

**Correção:** remova `sort_by` na criação e deixe os usuários clicarem nos headers para ordenar. Ou use `update_chart` para remover o campo mal formatado de charts já criados.

```json
{
  "identifier": "162",
  "config": {
    "chart_type": "table",
    "columns": [...],
    "row_limit": 20
  }
}
```

(Note a ausência do `sort_by`.)

### 4. Fragilidade de datasets virtuais

Datasets virtuais (como o ID 28 = `video_game_sales_by_region`) são views SQL em cima de tabelas físicas. Qualquer chart criado sobre eles emite o aviso:

```
This chart uses a virtual dataset (SQL-based). If the dataset is deleted, this chart will break.
```

**Contorno:** nenhum necessário se você não planeja deletar o dataset virtual. Mas é bom saber.

### 5. Filtro de coluna no `list_datasets` exige operadores exatos

A DSL de filtros é estrita:

```json
// ❌ Falha:
{"filters": [{"col": "table_name", "opr": "ct", "value": "video_game_sales"}]}

// ✅ Funciona:
{"filters": [{"col": "table_name", "opr": "ilike", "value": "%video_game_sales%"}]}
```

Operadores válidos: `eq, ne, sw, ew, in, nin, gt, gte, lt, lte, like, ilike, is_null, is_not_null`.

### 6. Nomes de parâmetro são sensíveis a caso e estilo

Vários endpoints embrulham parâmetros dentro de um objeto `request`:

```json
// ❌ Falha:
{"dataset_id": 28}

// ✅ Funciona:
{"request": {"identifier": "28"}}
```

Sempre teste com um payload pequeno antes.
