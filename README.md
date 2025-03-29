# Bootstrap an Open LLM and AI Gateway for home or leisure
##  Open WebUI GUI with LiteLLM Bootstrapped as containers for Rpi :
### _Home Assistant HACS version on the way..._

![License](https://img.shields.io/badge/license-MIT-blue.svg)
![Docker](https://img.shields.io/badge/docker-powered-blue.svg)

A reasonably robust setup for running Open WebUI with LiteLLM as a backend proxy, providing access to state-of-the-art AI models through a user-friendly interface. This project uses Docker Compose to orchestrate the services seamlessly.

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
MASTER_KEY=your_master_key  # required
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
   git clone https://github.com/yourusername/openwebui-litellm-setup.git
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

| Service | Port | Description |
|---------|------|-------------|
| Open WebUI | 3000 | User interface for interacting with AI models |
| LiteLLM | 4000 | Backend proxy that handles requests to various AI providers |

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

## 🔒 Security Considerations

- Store API keys securely and never commit them to version control
- The `.env` file should be included in your `.gitignore`
- Consider using Docker secrets for production environments
- The `MASTER_KEY` protects access to your setup; use a strong, unique value
- Note that your `config.yml` references environment variables using the `os.environ/VARIABLE_NAME` syntax
- For improved security, consider implementing the optional guardrails functionality

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
