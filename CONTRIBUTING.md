# Guia de Contribuição — ᴘᴛ

Obrigado por querer contribuir com o projeto! Este documento reúne o que você precisa para configurar o ambiente, propor
mudanças e manter o padrão do projeto.


## Fluxo de trabalho

1. Crie uma branch descritiva a partir da `main`:
   ```sh
   git checkout -b feat/nome-da-mudanca
   ```
   Prefixos sugeridos: `feat/`, `fix/`, `docs/`, `refactor/`, `test/`.
2. Faça suas alterações em commits pequenos e coesos.
3. **Rode `make test` antes de cada commit** — nenhuma mudança deve quebrar a
   suite existente.
4. Abra um Pull Request contra a branch `main`, descrevendo **o que** mudou e
   **por quê**.

   # Contributing Guide — ᴇɴ

Thanks for your interest in contributing to the project! This document covers how to set up your environment, propose
changes and keep the project's conventions.

## Workflow

1. Create a descriptive branch off `main`:
   ```sh
   git checkout -b feat/change-name
   ```
   Suggested prefixes: `feat/`, `fix/`, `docs/`, `refactor/`, `test/`.
2. Make your changes in small, focused commits.
3. **Run `make test` before every commit** — no change should break the
   existing suite.
4. Open a Pull Request against `main`, describing **what** changed and
   **why**.

by caiothevisual