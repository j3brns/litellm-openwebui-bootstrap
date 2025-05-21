# Use the provided base image
FROM ghcr.io/berriai/litellm-database:main-latest

# Set the working directory to /app
WORKDIR /app

# Create a non-root user and group
RUN groupadd -r litellm_group && useradd -r -g litellm_group -d /home/litellm_user -s /sbin/nologin litellm_user

# Create /app directory if it doesn't exist and set ownership
RUN mkdir -p /app && chown -R litellm_user:litellm_group /app

# Copy the configuration file into the container at /app
COPY --chown=litellm_user:litellm_group config.yml .

# Expose the necessary port
EXPOSE 4000/tcp

# Switch to the non-root user
USER litellm_user

# The default CMD includes --detailed_debug for development.
# For production, it is recommended to use the command without --detailed_debug:
# CMD ["--port", "4000", "--config", "config.yml"]

# Override the CMD instruction with your desired command and arguments
# WARNING: FOR PROD DO NOT USE `--detailed_debug` it slows down response times, instead use the following CMD
# CMD ["--port", "4000", "--config", "config.yml"]

CMD ["--port", "4000", "--config", "config.yml", "--detailed_debug"]