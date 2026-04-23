# Dashboard Assembly / Montagem de Dashboard

How to combine multiple charts into a single Superset dashboard via MCP.

Como combinar múltiplos charts em um único dashboard do Superset via MCP.

---

## The `generate_dashboard` tool

Call signature:

```json
{
  "dashboard_title": "Video Game Sales — Full Analysis",
  "chart_ids": [154, 155, 156, 157, 158, 159, 160, 161, 162, 163,
                164, 166, 167, 168, 169, 170, 171, 172, 173, 174,
                175, 176],
  "published": true
}
```

Returns the dashboard ID and URL. The Superset backend auto-positions charts in a 2-column grid.

Retorna o ID e URL do dashboard. O backend do Superset auto-posiciona os charts em grid de 2 colunas.

---

## Ordering strategy / Estratégia de ordenação

🇺🇸 The order in `chart_ids` matters — it determines the grid position. Suggested order for a storytelling dashboard:

🇧🇷 A ordem em `chart_ids` importa — ela determina a posição no grid. Ordem sugerida para um dashboard que conta uma história:

```
1. Big Numbers first (KPIs at the top / KPIs no topo)
   └── Total sales, Total games, Distinct publishers, etc.

2. Macro view / Visão macro
   └── Top platforms bar chart, Yearly trend line chart

3. Distributions / Distribuições
   └── Pie charts (genre, region)

4. Deep dives / Análises profundas
   └── Stacked areas, grouped lines

5. Detail tables last / Tabelas de detalhe por último
   └── Top 20 games, aggregated tables, pivot tables
```

---

## Adding charts to an existing dashboard / Adicionando charts a dashboard existente

Use `add_chart_to_existing_dashboard` (not `generate_dashboard`) for existing dashboards:

Use `add_chart_to_existing_dashboard` (não `generate_dashboard`) para dashboards existentes:

```json
{
  "dashboard_id": 13,
  "chart_id": 177
}
```

Do NOT call `generate_dashboard` as a "fallback" — it creates a new dashboard instead of updating.

NÃO chame `generate_dashboard` como "fallback" — ele cria um dashboard novo em vez de atualizar.

---

## Gotchas / Pegadinhas

**🇺🇸 One bad chart breaks the whole dashboard.**
If any chart in the list has a malformed config (like the `sort_by` issue documented in [`limitations.md`](../docs/limitations.md) § 3), the whole dashboard fails to load with an opaque error. Debugging: remove charts from the list one at a time to identify the culprit.

**🇧🇷 Um chart ruim quebra o dashboard inteiro.**
Se qualquer chart da lista tiver config mal formatado (como o problema do `sort_by` documentado em [`limitations.md`](../docs/limitations.md) § 3), o dashboard inteiro falha com erro opaco. Debugging: remova charts da lista um por vez para identificar o culpado.

**🇺🇸 Grid layout is auto-generated.**
Auto-positioning is basic. For production dashboards, open the dashboard in the Superset UI and drag-drop charts to rearrange. The MCP tool doesn't expose fine-grained layout control.

**🇧🇷 Layout de grid é auto-gerado.**
O auto-posicionamento é básico. Para dashboards em produção, abra o dashboard na UI do Superset e arraste-solte os charts para reorganizar. O MCP tool não expõe controle detalhado de layout.

**🇺🇸 Dashboard filters aren't set via this tool.**
Native filters, cross-filters, and tabs must be added through the Superset UI after dashboard creation.

**🇧🇷 Filtros de dashboard não são configurados por esta ferramenta.**
Filtros nativos, cross-filters e abas devem ser adicionados pela UI do Superset depois da criação.
