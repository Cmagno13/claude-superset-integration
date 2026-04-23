# Setup Guide / Guia de Configuração

🇧🇷 [Pular para Português](#-português) · 🇺🇸 [English below](#-english)

---

## 🇺🇸 English

### Prerequisites

- Docker + Docker Compose
- Claude (desktop app or web with MCP support) — Claude Opus 4.7 or later recommended
- Basic familiarity with Apache Superset
- ~20 minutes

### Step 1 — Spin up Apache Superset

The easiest route is the official Docker Compose setup, which ships with example datasets (including `video_game_sales` used in the walkthrough).

```bash
git clone https://github.com/apache/superset.git
cd superset
docker compose -f docker-compose-non-dev.yml up -d
```

Wait 2-3 minutes for all containers to boot. Then access:

- URL: `http://localhost:8088`
- Default user: `admin`
- Default password: `admin`

⚠️ **Security note:** change the admin password before exposing Superset to any network. The default credentials are public knowledge.

### Step 2 — Load the example datasets

Once logged in, go to `Settings → List Users → Load Examples` (or run `superset load_examples` inside the container). This loads the `video_game_sales` dataset and ~27 others.

Verify by going to `Datasets` — you should see at least 28 entries.

### Step 3 — Install the Superset MCP server

The MCP (Model Context Protocol) server for Superset exposes tools Claude can call. Installation varies depending on your Claude client.

**For Claude Desktop:**

1. Locate your Claude Desktop config:
   - macOS: `~/Library/Application Support/Claude/claude_desktop_config.json`
   - Windows: `%APPDATA%\Claude\claude_desktop_config.json`
   - Linux: `~/.config/Claude/claude_desktop_config.json`

2. Add the Superset MCP server:

```json
{
  "mcpServers": {
    "superset": {
      "command": "npx",
      "args": ["-y", "@superset-mcp/server"],
      "env": {
        "SUPERSET_URL": "http://localhost:8088",
        "SUPERSET_USERNAME": "admin",
        "SUPERSET_PASSWORD": "CHANGE_ME"
      }
    }
  }
}
```

3. Restart Claude Desktop. The Superset tools should appear in the tool list.

> **Note:** the exact package name and config shape may differ depending on which MCP server implementation you use. Check the Superset community Slack (`#using-superset`) for the current recommendation. At the time of writing (April 2026), the Superset MCP service is at version 6.1.x.

**For Claude web (claude.ai):**

Claude on the web supports MCP through the Connectors feature. In Settings → Connectors, add a new connector pointing to your Superset MCP server URL. This typically requires exposing the MCP server through a publicly reachable URL (or tunneling with ngrok/Cloudflare Tunnel for local testing).

### Step 4 — Verify the connection

Open a new conversation in Claude and ask:

> Do a health check on my Superset and show me the version and uptime.

Claude should call the `health_check` MCP tool and respond with status, version (e.g. `6.1.0rc2`), and uptime in seconds.

If you get errors, check:

- Is Superset running? (`docker ps` should show `superset_app` as healthy)
- Are the credentials in the MCP config correct?
- Can you hit `http://localhost:8088/health` from your shell and get `OK`?

### Step 5 — Try a first analysis

```
> Give me an overview of my Superset instance.
> List the 10 most recently modified datasets.
> Show me the columns of the video_game_sales dataset.
```

Claude will chain `get_instance_info`, `list_datasets`, and `get_dataset_info` tools to answer.

### Step 6 — Run SQL through the conversation

```
> Run this query on the examples database:
>
> SELECT Platform, COUNT(*) as qty, SUM(Global_Sales) as total
> FROM video_game_sales
> GROUP BY Platform
> ORDER BY total DESC
> LIMIT 10
```

Claude uses the `execute_sql` tool and returns the results formatted.

### Step 7 — Create charts and a dashboard

See [`walkthrough.md`](walkthrough.md) for the full transcript of how to ask Claude to create multiple charts and assemble them into a dashboard.

### Troubleshooting

**"Column X not found in dataset":** Superset columns are case-sensitive. `global_sales` ≠ `Global_Sales`. Check with `get_dataset_info` first.

**"Big Number trendline requires a temporal SQL column":** the year column in many example datasets is `BIGINT`, not a real temporal type. Edit the dataset in Superset to mark the column as temporal, or use a different chart type.

**"Found invalid orderby options" on the dashboard:** a Table chart with a malformed `sort_by` field. See [`limitations.md`](limitations.md) for the fix.

**Tools don't appear in Claude:** restart the Claude Desktop app. MCP servers are loaded at startup.

---

## 🇧🇷 Português

### Pré-requisitos

- Docker + Docker Compose
- Claude (aplicativo desktop ou web com suporte a MCP) — Claude Opus 4.7 ou posterior recomendado
- Familiaridade básica com Apache Superset
- ~20 minutos

### Passo 1 — Subir o Apache Superset

A rota mais fácil é o Docker Compose oficial, que já vem com datasets de exemplo (incluindo o `video_game_sales` usado no walkthrough).

```bash
git clone https://github.com/apache/superset.git
cd superset
docker compose -f docker-compose-non-dev.yml up -d
```

Aguarde 2-3 minutos para todos os containers subirem. Depois acesse:

- URL: `http://localhost:8088`
- Usuário padrão: `admin`
- Senha padrão: `admin`

⚠️ **Nota de segurança:** troque a senha de admin antes de expor o Superset em qualquer rede. As credenciais padrão são conhecidas publicamente.

### Passo 2 — Carregar datasets de exemplo

Uma vez logado, vá em `Settings → List Users → Load Examples` (ou rode `superset load_examples` dentro do container). Isso carrega o dataset `video_game_sales` e ~27 outros.

Verifique indo em `Datasets` — você deve ver pelo menos 28 entradas.

### Passo 3 — Instalar o MCP server do Superset

O MCP (Model Context Protocol) server do Superset expõe ferramentas que o Claude pode chamar. A instalação varia dependendo do cliente Claude usado.

**Para Claude Desktop:**

1. Localize o arquivo de configuração do Claude Desktop:
   - macOS: `~/Library/Application Support/Claude/claude_desktop_config.json`
   - Windows: `%APPDATA%\Claude\claude_desktop_config.json`
   - Linux: `~/.config/Claude/claude_desktop_config.json`

2. Adicione o MCP server do Superset:

```json
{
  "mcpServers": {
    "superset": {
      "command": "npx",
      "args": ["-y", "@superset-mcp/server"],
      "env": {
        "SUPERSET_URL": "http://localhost:8088",
        "SUPERSET_USERNAME": "admin",
        "SUPERSET_PASSWORD": "TROCAR"
      }
    }
  }
}
```

3. Reinicie o Claude Desktop. As ferramentas do Superset devem aparecer na lista.

> **Nota:** o nome exato do pacote e o formato do config podem variar dependendo de qual implementação de MCP server você usar. Confira o Slack da comunidade Superset (`#using-superset`) para a recomendação atual. No momento em que escrevo (abril/2026), o serviço MCP do Superset está na versão 6.1.x.

**Para Claude web (claude.ai):**

O Claude web suporta MCP através do recurso Connectors. Em Settings → Connectors, adicione um novo conector apontando para a URL do seu MCP server. Normalmente isso exige expor o MCP server por uma URL pública (ou usar túnel via ngrok/Cloudflare Tunnel para testes locais).

### Passo 4 — Verificar a conexão

Abra uma nova conversa no Claude e pergunte:

> Faça um health check no meu Superset e me mostre a versão e o uptime.

O Claude deve chamar a ferramenta MCP `health_check` e responder com status, versão (ex: `6.1.0rc2`) e uptime em segundos.

Se der erro, verifique:

- O Superset está rodando? (`docker ps` deve mostrar `superset_app` como healthy)
- As credenciais do MCP config estão corretas?
- Consegue acessar `http://localhost:8088/health` e receber `OK`?

### Passo 5 — Tentar uma primeira análise

```
> Me dê uma visão geral da minha instância do Superset.
> Liste os 10 datasets mais recentemente modificados.
> Me mostre as colunas do dataset video_game_sales.
```

O Claude vai encadear as ferramentas `get_instance_info`, `list_datasets` e `get_dataset_info` para responder.

### Passo 6 — Rodar SQL na conversa

```
> Rode esta query no banco de exemplos:
>
> SELECT Platform, COUNT(*) as qtd, SUM(Global_Sales) as total
> FROM video_game_sales
> GROUP BY Platform
> ORDER BY total DESC
> LIMIT 10
```

O Claude usa a ferramenta `execute_sql` e retorna os resultados formatados.

### Passo 7 — Criar gráficos e um dashboard

Veja [`walkthrough.md`](walkthrough.md) para o transcript completo de como pedir ao Claude para criar múltiplos gráficos e montar um dashboard.

### Problemas comuns

**"Column X not found in dataset":** colunas no Superset são case-sensitive. `global_sales` ≠ `Global_Sales`. Cheque primeiro com `get_dataset_info`.

**"Big Number trendline requires a temporal SQL column":** a coluna de ano em muitos datasets de exemplo é `BIGINT`, não um tipo temporal real. Edite o dataset no Superset para marcar a coluna como temporal, ou use outro tipo de chart.

**"Found invalid orderby options" no dashboard:** um chart Table com `sort_by` mal formatado. Veja [`limitations.md`](limitations.md) para a correção.

**Ferramentas não aparecem no Claude:** reinicie o Claude Desktop. MCP servers são carregados na inicialização.
