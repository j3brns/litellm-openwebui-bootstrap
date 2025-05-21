!EXPERIMENTAL!

# Bootstrap an Open LLM and AI Gateway for home or leisure
##  Open WebUI GUI with LiteLLM Bootstrapped as containers for Rpi :

![License](https://img.shields.io/badge/license-MIT-blue.svg)
![Docker](https://img.shields.io/badge/docker-powered-blue.svg)

A reasonably robust setup for running Open WebUI with LiteLLM as a backend proxy, providing access to state-of-the-art AI models through a user-friendly interface. This project uses Docker Compose to orchestrate the services seamlessly.
Open WebUI provides an intuitive, chat-based graphical interface, making it easy to interact with the various language models. LiteLLM acts as a robust backend proxy, standardizing API calls to a wide array of LLM providers and managing model configurations.

## 🚀 Features

- **Simple Setup**: Get running with minimal configuration using Docker Compose
- **Multiple Models**: Support for various AI providers (Anthropic, OpenAI, DeepSeek, Codestral, and Groq)
- **User-Friendly Interface**: Intuitive UI for interacting with AI models
- **Centralized Management**: LiteLLM provides unified API access to all models

## 📋 Prerequisites

- Docker and Docker Compose installed on your system
- API keys for the AI models you plan to use

## ⚙️ Configuration

### Environment Variables

1. Create a `.env` file in the project root with the following content:

```env
MASTER_KEY=your_master_key  # Required. Set to a strong, unique, randomly generated string. This key is used by Open WebUI to authenticate with LiteLLM.
ANTHROPIC_API_KEY=your_anthropic_api_key
OPENAI_API_KEY=your_openai_api_key
OPENROUTER_API_KEY=your_openrouter_api_key
DEEPSEEK_API_KEY=your_deepseek_api_key
CODESTRAL_API_KEY=your_codestral_api_key
GROQ_API_KEY=your_groq_api_key
```

Replace `your_*_api_key` with your actual API keys.

### Model Configuration

Ensure the `config.yml` file is present in the project root. This file configures the available models for LiteLLM. You can customize it to add more models as needed.

## 🔧 Installation & Usage

1. Clone this repository:
   ```bash
   git clone https://github.com/j3brns/openwebui-litellm-setup.git
   cd openwebui-litellm-setup
   ```

2. Set up your `.env` file with the appropriate API keys

3. Start the services:
   ```bash
   docker-compose up -d
   ```

4. Access the interfaces:
   - Open WebUI: [http://localhost:3000](http://localhost:3000)
   - LiteLLM OpenAPI: [http://localhost:4000](http://localhost:4000)

## 🧩 Services Architecture

The services interact as follows: Users connect to Open WebUI, which then communicates with LiteLLM. LiteLLM, acting as a proxy and translation layer, forwards requests to the appropriate configured LLM provider API. The PostgreSQL database stores metadata for LiteLLM and data for Open WebUI.

```
+-----------------+      +-----------------+      +----------------------+
|   User via      |----->|   Open WebUI    |----->|       LiteLLM        |
|   Browser       |      | (Port 3000)     |      | (Port 4000)          |
+-----------------+      +-----------------+      +----------------------+
                               |                         |        /|\
                               |                         |       / | \
                               |                         |      /  |  \
                               |                         V     V   V   V
                               |      +-----------------+  +-------+-------+
                               |      |   PostgreSQL    |  | LLM Providers |
                               |----->|   Database      |  | (OpenAI, etc.)|
                               |      +-----------------+  +---------------+
                               +------> (OIDC/Auth data,
                                        Chat History etc.)
```

| Service | Port | Description |
|---------|------|-------------|
| Open WebUI | 3000 | User interface for interacting with AI models |
| LiteLLM | 4000 | Backend proxy that handles requests to various AI providers |

## ⚙️ Service Configuration Details

This project is configured with several best practices in mind:

### Dockerfile (`litellm` service)
- **Non-Root User:** The Docker image for the `litellm` service is configured to run the application as a non-root user (`litellm_user`), enhancing security by reducing potential container vulnerabilities.
- **CMD for Debug vs. Production:** The `Dockerfile` itself contains two `CMD` instructions for the `litellm` service:
    - The default `CMD ["--port", "4000", "--config", "config.yml", "--detailed_debug"]` is used if you build an image directly from the Dockerfile (e.g., for development or testing). The `--detailed_debug` flag provides verbose logging.
    - A commented-out CMD `CMD ["--port", "4000", "--config", "config.yml"]` is recommended for production to avoid excessive logging and potential performance impacts.
- When using `docker-compose up`, the `command` specified in `docker-compose.yaml` for the `litellm` service (`--config /app/config.yaml --port 4000`) is used, which does *not* include `--detailed_debug` by default, making it suitable for general use.
- **Base Image:** The `Dockerfile` for `litellm` uses `FROM ghcr.io/berriai/litellm-database:main-latest`. Similar to other images tagged with `main` or `latest`, this tracks recent changes. For critical production setups where maximum stability is desired, you might consider investigating if specific tagged releases or commit SHAs of this base image are available and adapt the `Dockerfile` accordingly.

### Docker Compose (`docker-compose.yaml`)
- **Image Tagging:**
    - `open-webui`: Uses a specific version tag (e.g., `v0.6.10`) from `ghcr.io/open-webui/open-webui` for improved stability. You can check for newer versions on the [Open WebUI Releases page](https://github.com/open-webui/open-webui/releases).
    - `litellm`: Uses the `main-latest` tag from `ghcr.io/berriai/litellm-database`. While this provides recent features, for critical production environments, consider finding and pinning to a specific SHA digest or a tagged release if available for this image to ensure maximum stability.
    - `postgres`: Uses a specific major version tag (e.g., `postgres:16-alpine`) to prevent unexpected automatic upgrades to new major versions of PostgreSQL and uses a smaller alpine variant.
- **Database Credentials:** As mentioned in "Security Considerations," the default Postgres credentials in `docker-compose.yaml` should be changed for production.

## 🤖 Available Models

The following models are pre-configured in `config.yml`:

### Anthropic
- Claude 3.7 Sonnet (claude-3-7-sonnet-20250219)
- Claude 3.5 Sonnet (claude-3-5-sonnet-20241022)

### OpenAI
- gpt-4o
- gpt-4o-mini

### OpenRouter
- Llama 3.1 405B Instruct (meta-llama/llama-3.1-405b-instruct)
- Llama 3.1 Sonar Large Online (perplexity/llama-3.1-sonar-large-128k-online)

### Groq
- Llama 3.1 70B (groq/llama-3.1-70b-versatile)
- Llama 3.1 8B (groq/llama-3.1-8b-instant)

### DeepSeek
- DeepSeek Coder (deepseek/deepseek-coder)
- DeepSeek Chat (deepseek/deepseek-chat)

### Codestral
- Codestral (text-completion-codestral/codestral-latest)

## 📊 Resource Considerations

The resource usage (CPU, RAM, Disk Space) of this setup can vary significantly based on:
- The number and size of LLMs configured and used via LiteLLM.
- The amount of data stored by Open WebUI (e.g., chat history, user documents for RAG).
- The PostgreSQL database's size over time.
- The level of activity (number of concurrent users, frequency of requests).

**For Raspberry Pi or other low-resource devices:**
- Carefully select the models you enable. Smaller models will consume fewer resources.
- Monitor system resource usage regularly.
- Performance may vary, especially with larger models or high traffic.
- Ensure sufficient disk space, especially for the Open WebUI volume and the database.

## 🔒 Security Considerations

- Store API keys securely and never commit them to version control
- The `.env` file should be included in your `.gitignore`
- The `.env` file *is* included in this project's `.gitignore` to help prevent accidental commitment of your secrets.
- Consider using Docker secrets for production environments
- The `MASTER_KEY` protects access to your setup; use a strong, unique value
- Note that your `config.yml` references environment variables using the `os.environ/VARIABLE_NAME` syntax
- For improved security, consider implementing the optional guardrails functionality
- The `docker-compose.yaml` file uses default credentials for the PostgreSQL database (`llmproxy`/`dbpassword9090`). For any deployment beyond local testing on a trusted machine, it is strongly recommended to change these defaults. You can do this by editing the `POSTGRES_USER` and `POSTGRES_PASSWORD` environment variables in the `db` service within `docker-compose.yaml`, and correspondingly update the `DATABASE_URL` in the `litellm` service. For better security, consider managing these credentials via your `.env` file and referencing them in `docker-compose.yaml` (e.g., `POSTGRES_USER=\${POSTGRES_USER_FROM_ENV}`).

## 🔍 Troubleshooting

If you encounter issues:

1. Check Docker logs:
   ```bash
   docker-compose logs open-webui
   docker-compose logs litellm
   ```

2. Verify your API keys are correct in the `.env` file

3. Ensure ports 3000 and 4000 are not being used by other applications

## 📦 Extending

To add more models:

1. Update your `.env` file with any new API keys
2. Modify the `config.yml` to include the new models, following the existing format:
   ```yaml
   - model_name: Your Model Display Name
     litellm_params:
       model: provider/model-identifier
       api_key: os.environ/YOUR_API_KEY
   ```
3. Restart the services: `docker-compose restart`

### Adding Guardrails (Optional)

The configuration includes commented guardrail settings that you can uncomment and configure:

```yaml
guardrails:
  - guardrail_name: "presidio-pre-guard"
    litellm_params:
      guardrail: presidio # supported values: "aporia", "bedrock", "lakera", "presidio"
      mode: "pre_call"
      output_parse_pii: True
```

## 📝 License

This project is distributed under the MIT License. See `LICENSE` file for more information.

## 🙏 Acknowledgements

- [Open WebUI](https://github.com/open-webui/open-webui)
- [LiteLLM](https://github.com/BerriAI/litellm)
- All the amazing AI model providers that make this possible
- chrispeng
