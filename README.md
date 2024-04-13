# Python Rye Template
A Project Template of Python with Rye

# Install

Please first install the latest Rye.
https://rye-up.com/guide/installation/

Then run the following command to install runtime libraries.

```bash
rye sync --no-dev --no-lock
```

# Develop

```bash
rye sync
```

This installs the following tools in addition to runtime libraries.

- ruff
- pyright
- pytest-cov

The settings of those linter and formatters are written in `pyproject.toml`

# VSCode Settings

```bash
cp vscode_templates .vscode
```

Then install/activate all extensions listed in `.vscode/extensions.json`

# Creating Console Script

```toml
[project.scripts]
app = "app.cli:main"
```

# Define Project Command

```toml
[tool.rye.scripts]
pyright_lint = "pyright ."
ruff_format = "ruff format ."
ruff_lint = "ruff check ."
ruff_fix = "ruff check --fix-only ."
test = "pytest tests --cov=app --cov-report=term --cov-report=xml"
format = { chain = ["ruff_fix", "ruff_format"] }
lint = { chain = ["ruff_lint", "pyright_lint"] }
check = { chain = ["format", "lint", "test"] }
```

# Build Docker Image

Please check the `Dockerfile` for how to use multi-stage build with Rye.