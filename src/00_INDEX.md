# D&D 5.2.1 SRD — Master Reference Index

This index maps every chapter and content file in the SRD. Use it to find which file contains the rules, monsters, spells, or items you need.

## Chapter Map

| Ch | Title | File | What's Inside |
|----|-------|------|---------------|
| 00 | Legal | [00_Legal.md](00_Legal.md) | CC-BY-4.0 license terms and attribution |
| 01 | Playing the Game | [01_PlayingTheGame.md](01_PlayingTheGame.md) | Core gameplay: d20 tests, advantage/disadvantage, ability scores, proficiency, actions, social interaction, exploration, combat, damage & healing |
| 02 | Character Creation | [02_CharacterCreation.md](02_CharacterCreation.md) | Step-by-step character building, class overview table, level advancement, starting at higher levels, multiclassing rules, trinkets |
| 03 | Classes | [03_Classes/00_Classes.md](03_Classes/00_Classes.md) | All 12 character classes with features, subclasses, and spell lists. → See class index |
| 04 | Character Origins | [04_CharacterOrigins.md](04_CharacterOrigins.md) | Backgrounds (Acolyte, Criminal, Sage, Soldier), character species (Dwarf, Elf, Halfling, Human, Dragonborn, Gnome, Tiefling, Orc) |
| 05 | Feats | [05_Feats.md](05_Feats.md) | Feat rules and all feats organized by category: Origin, General, Fighting Style, Epic Boon |
| 06 | Equipment | [06_Equipment.md](06_Equipment.md) | Coinage, weapons, armor, tools, adventuring gear, mounts & vehicles, lifestyle expenses, hirelings, spellcasting foci, magic item categories, crafting rules |
| 07 | Spells (Rules) | [Spells/Spells_Rules.md](Spells/Spells_Rules.md) | Spellcasting rules: gaining spells, casting spells, components, durations, schools, ritual casting |
| 07 | Spells (A–Z) | [Spells/_spell_index.md](Spells/_spell_index.md) | All spell descriptions split alphabetically across letter files (A through U-Z). → See spell index |
| 08 | Rules Glossary | [08_RulesGlossary.md](08_RulesGlossary.md) | Alphabetical glossary of every rules term: actions, conditions, damage types, senses, movement, and more |
| 09 | Gameplay Toolbox | [09_GameplayToolbox.md](09_GameplayToolbox.md) | GM tools: travel pace, creating backgrounds, curses & magical contagions, environmental effects, fear & mental stress, poison, traps, combat encounter building |
| 10 | Magic Items (Rules) | [MagicItems/MagicItems_Rules.md](MagicItems/MagicItems_Rules.md) | Magic item rules: categories, rarity, attunement, wearing & wielding, activation, crafting, sentient items |
| 10 | Magic Items (A–Z) | [MagicItems/_item_index.md](MagicItems/_item_index.md) | All magic item descriptions split alphabetically across letter files (A through W). → See item index |
| 11 | Monsters (Rules) | [11_Monsters.md](11_Monsters.md) | Monster rules: stat block anatomy, creature types, alignment, descriptive tags, gear, NPC stat blocks |
| 12 | Monsters (A–Z) | [Monsters/_monster_index.md](Monsters/_monster_index.md) | All monster stat blocks split alphabetically across letter files (A through Z). → See monster index |
| 13 | Animals | [13_Animals.md](13_Animals.md) | Beast stat blocks: allosaurus through wolf. → Also listed in monster index |

## Key Sections by Chapter

### 01 — Playing the Game
`Rhythm of Play` → `The Six Abilities` → `D20 Tests` → `Proficiency` → `Actions` → `Social Interaction` → `Exploration` → `Combat` → `Damage and Healing`

### 02 — Character Creation
`Choose a Character Sheet` → `Create Your Character` (steps 1-5) → `Level Advancement` → `Starting at Higher Levels` → `Multiclassing` → `Trinkets`

### 04 — Character Origins
`Character Backgrounds` → `Soldier` (sample background) → `Character Species` (all species traits)

### 05 — Feats
`Parts of a Feat` → `Origin Feats` → `General Feats` → `Fighting Style Feats` → `Epic Boons`

### 06 — Equipment
`Coins` → `Weapons` → `Armor` → `Tools` → `Adventuring Gear` → `Mounts and Vehicles` → `Lifestyle Expenses` → `Hirelings` → `Spellcasting` → `Magic Items` → `Crafting`

### 08 — Rules Glossary
`Glossary Conventions` → `Rules Definitions` (A–Z)

### 09 — Gameplay Toolbox
`Travel Pace` → `Creating a Background` → `Curses and Magical Contagions` → `Environmental Effects` → `Fear and Mental Stress` → `Poison` → `Traps` → `Combat Encounters`

## File Organization

```
src/
├── 00_INDEX.md              ← YOU ARE HERE
├── 00_Legal.md
├── 01_PlayingTheGame.md
├── 02_CharacterCreation.md
├── 03_Classes/
│   ├── 00_Classes.md        ← Class index
│   ├── 01_Barbarian.md
│   ├── ...                   (02–12)
│   └── 12_Wizard.md
├── 04_CharacterOrigins.md
├── 05_Feats.md
├── 06_Equipment.md
├── 08_RulesGlossary.md
├── 09_GameplayToolbox.md
├── 11_Monsters.md            ← Monster rules
├── 13_Animals.md
├── Spells/
│   ├── _spell_index.md       ← Spell index
│   ├── Spells_Rules.md
│   ├── Spells_A.md
│   └── ...
├── MagicItems/
│   ├── _item_index.md        ← Item index
│   ├── MagicItems_Rules.md
│   ├── MagicItems_A.md
│   └── ...
└── Monsters/
    ├── _monster_index.md     ← Monster index
    ├── Monsters_A.md
    └── ...
```
