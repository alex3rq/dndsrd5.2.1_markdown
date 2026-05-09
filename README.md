# D&D 5.2.1 SRD en Markdown

**186 archivos · 2 idiomas · Licencia CC-BY-4.0**

> **English:** [README_EN – English version](README_EN.md)

El *System Reference Document 5.2.1* de Dungeons & Dragons convertido a Markdown. Todo el contenido oficial de reglas gratuitas de Wizards of the Coast, en un formato portátil, legible por humanos y máquinas.

---

## Contenido

| Capítulo | Archivo(s) | Descripción |
|---|---|---|
| 01 — Playing the Game | `01_PlayingTheGame.md` | Reglas base: d20 tests, combate, daño, curación, exploración |
| 02 — Character Creation | `02_CharacterCreation.md` | Creación de personajes, multiclase, nivelación |
| 03 — Classes | `03_Classes/` (13 archivos) | Las 12 clases con subclases completas |
| 04 — Character Origins | `04_CharacterOrigins.md` | Trasfondos y especies de personaje |
| 05 — Feats | `05_Feats.md` | Dotes de origen, generales, de estilo de combate y épicas |
| 06 — Equipment | `06_Equipment.md` | Armas, armaduras, equipo, monturas, objetos mágicos |
| 07 — Spells | `Spells/` (18 archivos) | Reglas de conjuros + todos los conjuros de la A a la Z |
| 08 — Rules Glossary | `08_RulesGlossary.md` | Glosario completo de términos de reglas |
| 09 — Gameplay Toolbox | `09_GameplayToolbox.md` | Herramientas para el DM: trampas, venenos, encuentros |
| 10 — Magic Items | `MagicItems/` (16 archivos) | Reglas + todos los objetos mágicos de la A a la Z |
| 11 — Monsters (Rules) | `11_Monsters.md` | Reglas de monstruos y anatomía de bloques de estadísticas |
| 12 — Monsters (A–Z) | `Monsters/` (28 archivos) | Todos los monstruos de la A a la Z |
| 13 — Animals | `13_Animals.md` | Bestias (también listadas en el índice de monstruos) |

## Navegación

Cada sección tiene un **índice maestro** que facilita encontrar lo que buscas:

- **General:** `src/00_INDEX.md` — mapa completo del proyecto
- **Conjuros:** `src/Spells/_spell_index.md` — búsqueda por nombre, nivel, escuela y clase
- **Monstruos:** `src/Monsters/_monster_index.md` — búsqueda por nombre, CR, tipo y tamaño
- **Objetos mágicos:** `src/MagicItems/_item_index.md` — búsqueda por nombre, rareza y categoría
- **Clases:** `src/03_Classes/00_Classes.md` — tabla con todas las clases y sus subclases

## Español

El proyecto incluye una traducción completa al español en `src_es/`, con la misma estructura:

| src/ (English) | src_es/ (Español) |
|---|---|
| `Spells/` | `Conjuros/` |
| `Monsters/` | `Monstruos/` |
| `MagicItems/` | `ObjetosMagicos/` |
| `03_Classes/` | `03_Clases/` (archivos con nombres traducidos) |

El índice maestro en español está en `src_es/00_INDEX.md`.

## Uso

Este repositorio es útil para:

- **DM y jugadores** que quieran consultar reglas sin conexión
- **Herramientas y aplicaciones** que necesiten datos de D&D 5.2.1
- **Procesamiento con LLM** y otras herramientas de IA, gracias al formato Markdown limpio
- **Fork y personalización** del SRD para campañas o reglas de la casa

## Créditos

Este trabajo incluye material del *System Reference Document 5.2.1* ("SRD 5.2.1") de Wizards of the Coast LLC, disponible en [dndbeyond.com/srd](https://www.dndbeyond.com/srd).

La conversión inicial se realizó con [marker](https://github.com/VikParuchuri/marker) y se refinó manualmente. Los bloques de monstruos se tomaron del repositorio [Lazy GM Tools](https://github.com/mshea/lazy_gm_tools) de Mike Shea ([slyflourish.com](https://slyflourish.com/)).

## Licencia

SRD 5.2 © 2024 Wizards of the Coast LLC — licenciado bajo **CC-BY-4.0**.

Este repositorio se distribuye bajo los mismos términos. Consulta [License.md](License.md) para el texto completo de la licencia.