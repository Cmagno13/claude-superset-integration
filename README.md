# Claude + Apache Superset via MCP

> Connecting Claude to Apache Superset through the Model Context Protocol (MCP) — a hands-on walkthrough for conversational data analysis.
>
> Conectando o Claude ao Apache Superset através do Model Context Protocol (MCP) — um tutorial prático para análise de dados conversacional.

[![License: Apache 2.0](https://img.shields.io/badge/License-Apache_2.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)
[![Superset](https://img.shields.io/badge/Apache_Superset-6.1-orange)](https://superset.apache.org/)
[![Claude](https://img.shields.io/badge/Claude-Opus_4.7-purple)](https://claude.ai/)

---

🇧🇷 [Versão em Português](#-português) · 🇺🇸 [English Version](#-english)

---

## 🇺🇸 English

### What is this?

A step-by-step tutorial showing how to connect Claude (via MCP) to an Apache Superset instance so you can perform full data analysis workflows through conversation — from health checks and SQL queries to chart creation and dashboard assembly.

In the walkthrough, I connected Claude to a Superset instance and, in about 20 minutes of chat, produced:

- ✅ 1 health check + instance overview
- ✅ Multi-table SQL analysis
- ✅ 22 charts (Big Numbers, Bar, Line, Area, Scatter, Pie, Mixed, Table, Pivot Table)
- ✅ 1 published dashboard

**No clicks in the Superset UI.**

### Why this matters

The technical layer of BI is becoming a commodity. This repo shows what "analytics as a conversation" actually looks like in practice — including the rough edges.

### Quickstart

```bash
# 1. Clone
git clone https://github.com/YOUR_USERNAME/claude-superset-integration.git
cd claude-superset-integration

# 2. Bring up Superset (Docker)
# See docs/setup.md for full instructions

# 3. Connect Claude via MCP
# See docs/setup.md § "Connecting Claude"
```

Full instructions in [`docs/setup.md`](docs/setup.md).

### Repository structure

```
.
├── README.md                   # This file (PT + EN)
├── LICENSE                     # Apache 2.0
├── docs/
│   ├── setup.md                # How to wire everything up
│   ├── walkthrough.md          # The actual conversation, step by step
│   └── limitations.md          # What doesn't work (yet)
├── queries/
│   └── platforms-analysis.sql  # SQL examples from the walkthrough
├── examples/
│   ├── chart-configs.md        # JSON payloads for creating charts via MCP
│   └── dashboard-assembly.md   # How to assemble charts into a dashboard
└── screenshots/                # Visual proof
```

### What works / what doesn't

✅ **Works well:** health checks, instance info, SQL execution, dataset inspection, chart creation (7 families: big_number, xy, pie, mixed_timeseries, pivot_table, table, handlebars), dashboard assembly, iterative debugging.

⚠️ **Known limitations:**
- Chart types like Treemap, Sunburst, Heatmap, Radar, deck.gl maps don't have MCP schemas exposed
- Big Number with Trendline requires a true SQL temporal column (BIGINT years don't qualify)
- Table `sort_by` parameter accepts strings but the frontend expects tuples — causes dashboard crashes. See [`docs/limitations.md`](docs/limitations.md).

### License

Apache License 2.0 — see [`LICENSE`](LICENSE).

---

## 🇧🇷 Português

### O que é isso?

Um tutorial passo a passo mostrando como conectar o Claude (via MCP) a uma instância do Apache Superset para realizar workflows completos de análise de dados através de conversa — de health checks e queries SQL até criação de gráficos e montagem de dashboards.

No walkthrough, conectei o Claude a uma instância do Superset e, em cerca de 20 minutos de chat, produzi:

- ✅ 1 health check + visão geral da instância
- ✅ Análise SQL com múltiplas queries
- ✅ 22 gráficos (Big Numbers, Bar, Line, Area, Scatter, Pie, Mixed, Table, Pivot Table)
- ✅ 1 dashboard publicado

**Nenhum clique na interface do Superset.**

### Por que isso importa

A camada técnica de BI está virando commodity. Este repositório mostra como "analytics como conversa" se parece na prática — incluindo as pontas soltas.

### Início rápido

```bash
# 1. Clone
git clone https://github.com/SEU_USUARIO/claude-superset-integration.git
cd claude-superset-integration

# 2. Suba o Superset (Docker)
# Veja docs/setup.md para instruções completas

# 3. Conecte o Claude via MCP
# Veja docs/setup.md § "Conectando o Claude"
```

Instruções completas em [`docs/setup.md`](docs/setup.md).

### Estrutura do repositório

```
.
├── README.md                   # Este arquivo (PT + EN)
├── LICENSE                     # Apache 2.0
├── docs/
│   ├── setup.md                # Como conectar tudo
│   ├── walkthrough.md          # A conversa real, passo a passo
│   └── limitations.md          # O que ainda não funciona
├── queries/
│   └── platforms-analysis.sql  # Exemplos de SQL do walkthrough
├── examples/
│   ├── chart-configs.md        # Payloads JSON para criar gráficos via MCP
│   └── dashboard-assembly.md   # Como montar gráficos em dashboard
└── screenshots/                # Prova visual
```

### O que funciona / o que não funciona

✅ **Funciona bem:** health checks, informações da instância, execução de SQL, inspeção de datasets, criação de gráficos (7 famílias: big_number, xy, pie, mixed_timeseries, pivot_table, table, handlebars), montagem de dashboards, debugging iterativo.

⚠️ **Limitações conhecidas:**
- Tipos como Treemap, Sunburst, Heatmap, Radar, mapas deck.gl não têm schemas expostos no MCP
- Big Number com Trendline exige coluna temporal SQL de verdade (anos em BIGINT não contam)
- Parâmetro `sort_by` em tabelas aceita strings mas o frontend espera tuplas — causa crash do dashboard. Veja [`docs/limitations.md`](docs/limitations.md).

### Licença

Apache License 2.0 — veja [`LICENSE`](LICENSE).

---

## Contributing / Contribuindo

Issues e PRs bem-vindos. Se você encontrou um bug ou expandiu os exemplos, abre uma issue.

Issues and PRs welcome. If you found a bug or expanded the examples, open an issue.
