# Stage 1: Builder
FROM python:3.11-buster AS builder
WORKDIR /app

# Upgrade pip and install Poetry
RUN pip install --upgrade pip && pip install poetry

# Copy dependency files and install dependencies with Poetry
COPY pyproject.toml poetry.lock ./
RUN poetry config virtualenvs.create false \
 && poetry install --no-root --no-interaction --no-ansi

# Copy the rest of the application code
COPY . /app

# Stage 2: Final Application
FROM python:3.11-buster AS app
WORKDIR /app

# Copy built code from the builder stage
COPY --from=builder /app /app

# Expose FastAPI port
EXPOSE 8000

# Set the entrypoint and command to run the application
ENTRYPOINT ["./entrypoint.sh"]
CMD ["uvicorn", "cc_compose.server:app", "--reload", "--host", "0.0.0.0", "--port", "8000"]
