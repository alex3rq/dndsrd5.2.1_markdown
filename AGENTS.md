# AGENTS.md

When asked about D&D 5.2.1 SRD content, follow this lookup order:

**Detect language first:** If the query is in Spanish, use `src_es/`. If in English, use `src/`. If unsure, check both.

## English (`src/`)

1. **Master Index** — Read `src/00_INDEX.md` for a complete map of all chapters, what each file contains, and which sub-index to consult next.

2. **Sub-Indexes** — For specific lookups, use these files (they sort first in their folders):
   - `src/Spells/_spell_index.md` — All spells with name, level, school, class lists, and source file. Includes lookup tables by level and by school.
   - `src/Monsters/_monster_index.md` — All monsters with name, CR, type, size, and source file. Includes lookup tables by CR and by type. Also covers Animals (Beasts) from `13_Animals.md`.
   - `src/MagicItems/_item_index.md` — All magic items with name, category, rarity, attunement, and source file. Includes lookup tables by rarity and by category.
   - `src/03_Classes/00_Classes.md` — All 12 character classes with primary ability, hit die, source file, and subclass included.

3. **Source Files** — Once you identify the correct file from an index, read that file for full content (descriptions, stat blocks, spell details, etc.).

All files are in `src/`. Alphabet files split large collections (Spells, Monsters, Magic Items) to fit context windows.

## Spanish (`src_es/`)

1. **Master Index** — Read `src_es/00_INDEX.md` for a complete map of all chapters in Spanish, what each file contains, and which sub-index to consult next.

2. **Sub-Indexes** — For specific lookups, use these files:
   - `src_es/Conjuros/_conjuro_index.md` — All spells (conjuros) with name, level, school, class lists, and source file.
   - `src_es/Monstruos/_monstruo_index.md` — All monsters (monstruos) with name, type, and source file. Also covers Animals (Animales) from `13_Animales.md`.
   - `src_es/ObjetosMagicos/_objeto_index.md` — All magic items (objetos magicos) with name, category/rarity, and source file.
   - `src_es/03_Clases/00_Clases.md` — All 12 character classes with primary ability, hit die, source file, and subclass included.

3. **Source Files** — Once you identify the correct file from an index, read that file for full content.

All files are in `src_es/`. Directory structure mirrors `src/` with Spanish names:

| src/ (English) | src_es/ (Spanish) |
|---|---|
| `Spells/` | `Conjuros/` |
| `Monsters/` | `Monstruos/` |
| `MagicItems/` | `ObjetosMagicos/` |
| `03_Classes/` | `03_Clases/` |

Class file mapping:

| English | Spanish |
|---|---|
| `01_Barbarian.md` | `01_Barbaro.md` |
| `02_Bard.md` | `02_Bardo.md` |
| `03_Cleric.md` | `04_Clerigo.md` |
| `04_Druid.md` | `05_Druida.md` |
| `05_Fighter.md` | `07_Guerrero.md` |
| `06_Monk.md` | `10_Monje.md` |
| `07_Paladin.md` | `11_Paladin.md` |
| `08_Ranger.md` | `06_Explorador.md` |
| `09_Rogue.md` | `12_Picaro.md` |
| `10_Sorcerer.md` | `08_Hechicero.md` |
| `11_Warlock.md` | `03_Brujo.md` |
| `12_Wizard.md` | `09_Mago.md` |
