<#
.SYNOPSIS
    Generates sub-index markdown files from extracted JSON data.
#>

$ErrorActionPreference = "Stop"
$srcRoot = Resolve-Path "$PSScriptRoot\..\src"

#====================================================
# Helper: build a line safely and append to StringBuilder
#====================================================
function Append-TableLine($sb, [string]$line) {
    [void]$sb.AppendLine($line)
}

#====================================================
# SPELL INDEX
#====================================================
function Write-SpellIndex {
    $spells = Get-Content "$PSScriptRoot\..\spells.json" -Raw -Encoding UTF8 | ConvertFrom-Json

    $sb = New-Object System.Text.StringBuilder
    Append-TableLine $sb "# Spell Index"
    Append-TableLine $sb ""
    Append-TableLine $sb "This index lists every spell in the 5.2.1 SRD. Use it to find which alphabet file contains a spell's full description."
    Append-TableLine $sb ""
    Append-TableLine $sb "## Quick Lookup (Alphabetical)"
    Append-TableLine $sb ""
    Append-TableLine $sb "| Spell | Level | School | Classes | File |"
    Append-TableLine $sb "|-------|-------|--------|---------|------|"

    foreach ($s in $spells) {
        $line = "| $($s.name) | $($s.level) | $($s.school) | $($s.classes) | $($s.file) |"
        Append-TableLine $sb $line
    }

    # By Level
    Append-TableLine $sb ""
    Append-TableLine $sb "## By Level"
    $levels = @("Cantrip") + (1..9 | ForEach-Object { "$_" })

    foreach ($level in $levels) {
        $title = if ($level -eq "Cantrip") { "Cantrip" } else { "Level $level" }
        Append-TableLine $sb ""
        Append-TableLine $sb "### $title"
        Append-TableLine $sb ""
        Append-TableLine $sb "| Spell | School | Classes | File |"
        Append-TableLine $sb "|-------|--------|---------|------|"

        $filtered = $spells | Where-Object { $_.level -eq $level }
        foreach ($s in $filtered) {
            $line = "| $($s.name) | $($s.school) | $($s.classes) | $($s.file) |"
            Append-TableLine $sb $line
        }
    }

    # By School
    $schools = $spells | Select-Object -ExpandProperty school -Unique | Sort-Object
    Append-TableLine $sb ""
    Append-TableLine $sb "## By School"

    foreach ($sch in $schools) {
        Append-TableLine $sb ""
        Append-TableLine $sb "### $sch"
        Append-TableLine $sb ""
        Append-TableLine $sb "| Spell | Level | Classes | File |"
        Append-TableLine $sb "|-------|-------|---------|------|"

        $filtered = $spells | Where-Object { $_.school -eq $sch }
        foreach ($s in $filtered) {
            $line = "| $($s.name) | $($s.level) | $($s.classes) | $($s.file) |"
            Append-TableLine $sb $line
        }
    }

    Append-TableLine $sb ""
    Append-TableLine $sb "## Reference"
    Append-TableLine $sb "- [Spellcasting Rules](Spells_Rules.md)"
    Append-TableLine $sb "- [Master Index](../00_INDEX.md)"

    $sb.ToString() | Out-File -FilePath "$srcRoot\Spells\_spell_index.md" -Encoding UTF8 -NoNewline
    Write-Host "Wrote src\Spells\_spell_index.md ($($spells.Count) spells)"
}

#====================================================
# ITEM INDEX
#====================================================
function Write-ItemIndex {
    $items = Get-Content "$PSScriptRoot\..\magic_items.json" -Raw -Encoding UTF8 | ConvertFrom-Json

    $sb = New-Object System.Text.StringBuilder
    Append-TableLine $sb "# Magic Item Index"
    Append-TableLine $sb ""
    Append-TableLine $sb "This index lists every magic item in the 5.2.1 SRD. Use it to find which alphabet file contains an item's full description."
    Append-TableLine $sb ""
    Append-TableLine $sb "## Quick Lookup (Alphabetical)"
    Append-TableLine $sb ""
    Append-TableLine $sb "| Item | Category | Rarity | Attune | File |"
    Append-TableLine $sb "|------|----------|--------|--------|------|"

    foreach ($it in $items) {
        $att = if ($it.attunement) { "Yes" } else { "No" }
        $line = "| $($it.name) | $($it.category) | $($it.rarity) | $att | $($it.file) |"
        Append-TableLine $sb $line
    }

    # By Rarity
    $rarityOrder = @("Common", "Uncommon", "Rare", "Very Rare", "Legendary", "Artifact")
    Append-TableLine $sb ""
    Append-TableLine $sb "## By Rarity"

    foreach ($rar in $rarityOrder) {
        $filtered = $items | Where-Object { $_.rarity -eq $rar }
        if ($filtered.Count -eq 0) { continue }
        Append-TableLine $sb ""
        Append-TableLine $sb "### $rar"
        Append-TableLine $sb ""
        Append-TableLine $sb "| Item | Category | Attune | File |"
        Append-TableLine $sb "|------|----------|--------|------|"
        foreach ($it in $filtered) {
            $att = if ($it.attunement) { "Yes" } else { "No" }
            $line = "| $($it.name) | $($it.category) | $att | $($it.file) |"
            Append-TableLine $sb $line
        }
    }

    # By Category
    $categories = $items | Select-Object -ExpandProperty category -Unique | Sort-Object
    Append-TableLine $sb ""
    Append-TableLine $sb "## By Category"

    foreach ($cat in $categories) {
        $filtered = $items | Where-Object { $_.category -eq $cat }
        Append-TableLine $sb ""
        Append-TableLine $sb "### $cat"
        Append-TableLine $sb ""
        Append-TableLine $sb "| Item | Rarity | Attune | File |"
        Append-TableLine $sb "|------|--------|--------|------|"
        foreach ($it in $filtered) {
            $att = if ($it.attunement) { "Yes" } else { "No" }
            $line = "| $($it.name) | $($it.rarity) | $att | $($it.file) |"
            Append-TableLine $sb $line
        }
    }

    Append-TableLine $sb ""
    Append-TableLine $sb "## Reference"
    Append-TableLine $sb "- [Magic Item Rules](MagicItems_Rules.md)"
    Append-TableLine $sb "- [Master Index](../00_INDEX.md)"

    $sb.ToString() | Out-File -FilePath "$srcRoot\MagicItems\_item_index.md" -Encoding UTF8 -NoNewline
    Write-Host "Wrote src\MagicItems\_item_index.md ($($items.Count) items)"
}

#====================================================
# MONSTER INDEX
#====================================================
function Write-MonsterIndex {
    $monsters = Get-Content "$PSScriptRoot\..\monsters.json" -Raw -Encoding UTF8 | ConvertFrom-Json

    $animals = @(
        @{name="Allosaurus";size="Large";type="Beast";tags="Dinosaur";cr="2";file="13_Animals.md"},
        @{name="Ankylosaurus";size="Huge";type="Beast";tags="Dinosaur";cr="3";file="13_Animals.md"},
        @{name="Ape";size="Medium";type="Beast";tags=$null;cr="1/2";file="13_Animals.md"},
        @{name="Archelon";size="Huge";type="Beast";tags="Dinosaur";cr="4";file="13_Animals.md"},
        @{name="Baboon";size="Small";type="Beast";tags=$null;cr="0";file="13_Animals.md"},
        @{name="Badger";size="Small";type="Beast";tags=$null;cr="0";file="13_Animals.md"},
        @{name="Bat";size="Small";type="Beast";tags=$null;cr="0";file="13_Animals.md"},
        @{name="Black Bear";size="Medium";type="Beast";tags=$null;cr="1/2";file="13_Animals.md"},
        @{name="Blood Hawk";size="Small";type="Beast";tags=$null;cr="1/8";file="13_Animals.md"},
        @{name="Boar";size="Medium";type="Beast";tags=$null;cr="1/4";file="13_Animals.md"},
        @{name="Brown Bear";size="Large";type="Beast";tags=$null;cr="1";file="13_Animals.md"},
        @{name="Camel";size="Large";type="Beast";tags=$null;cr="1/8";file="13_Animals.md"},
        @{name="Cat";size="Small";type="Beast";tags=$null;cr="0";file="13_Animals.md"},
        @{name="Constrictor Snake";size="Large";type="Beast";tags=$null;cr="1/4";file="13_Animals.md"},
        @{name="Crab";size="Small";type="Beast";tags=$null;cr="0";file="13_Animals.md"},
        @{name="Crocodile";size="Large";type="Beast";tags=$null;cr="1/2";file="13_Animals.md"},
        @{name="Deer";size="Medium";type="Beast";tags=$null;cr="0";file="13_Animals.md"},
        @{name="Dire Wolf";size="Large";type="Beast";tags=$null;cr="1";file="13_Animals.md"},
        @{name="Draft Horse";size="Large";type="Beast";tags=$null;cr="1/4";file="13_Animals.md"},
        @{name="Eagle";size="Small";type="Beast";tags=$null;cr="0";file="13_Animals.md"},
        @{name="Elephant";size="Huge";type="Beast";tags=$null;cr="4";file="13_Animals.md"},
        @{name="Elk";size="Large";type="Beast";tags=$null;cr="1/4";file="13_Animals.md"},
        @{name="Frog";size="Small";type="Beast";tags=$null;cr="0";file="13_Animals.md"},
        @{name="Giant Ape";size="Huge";type="Beast";tags=$null;cr="7";file="13_Animals.md"},
        @{name="Giant Badger";size="Medium";type="Beast";tags=$null;cr="1/4";file="13_Animals.md"},
        @{name="Giant Bat";size="Large";type="Beast";tags=$null;cr="1/4";file="13_Animals.md"},
        @{name="Giant Boar";size="Large";type="Beast";tags=$null;cr="2";file="13_Animals.md"},
        @{name="Giant Centipede";size="Small";type="Beast";tags=$null;cr="1/4";file="13_Animals.md"},
        @{name="Giant Constrictor Snake";size="Huge";type="Beast";tags=$null;cr="2";file="13_Animals.md"},
        @{name="Giant Crab";size="Medium";type="Beast";tags=$null;cr="1/8";file="13_Animals.md"},
        @{name="Giant Crocodile";size="Huge";type="Beast";tags=$null;cr="5";file="13_Animals.md"},
        @{name="Giant Fire Beetle";size="Small";type="Beast";tags=$null;cr="0";file="13_Animals.md"},
        @{name="Giant Frog";size="Medium";type="Beast";tags=$null;cr="1/4";file="13_Animals.md"},
        @{name="Giant Goat";size="Large";type="Beast";tags=$null;cr="1/2";file="13_Animals.md"},
        @{name="Giant Hyena";size="Large";type="Beast";tags=$null;cr="1";file="13_Animals.md"},
        @{name="Giant Lizard";size="Large";type="Beast";tags=$null;cr="1/4";file="13_Animals.md"},
        @{name="Giant Octopus";size="Large";type="Beast";tags=$null;cr="1";file="13_Animals.md"},
        @{name="Giant Rat";size="Small";type="Beast";tags=$null;cr="1/8";file="13_Animals.md"},
        @{name="Giant Scorpion";size="Large";type="Beast";tags=$null;cr="3";file="13_Animals.md"},
        @{name="Giant Seahorse";size="Large";type="Beast";tags=$null;cr="1/2";file="13_Animals.md"},
        @{name="Giant Shark";size="Huge";type="Beast";tags=$null;cr="5";file="13_Animals.md"},
        @{name="Giant Spider";size="Large";type="Beast";tags=$null;cr="1";file="13_Animals.md"},
        @{name="Giant Toad";size="Large";type="Beast";tags=$null;cr="1";file="13_Animals.md"},
        @{name="Giant Venomous Snake";size="Medium";type="Beast";tags=$null;cr="1/4";file="13_Animals.md"},
        @{name="Giant Wasp";size="Medium";type="Beast";tags=$null;cr="1/2";file="13_Animals.md"},
        @{name="Giant Weasel";size="Medium";type="Beast";tags=$null;cr="1/8";file="13_Animals.md"},
        @{name="Giant Wolf Spider";size="Medium";type="Beast";tags=$null;cr="1/4";file="13_Animals.md"},
        @{name="Goat";size="Medium";type="Beast";tags=$null;cr="0";file="13_Animals.md"},
        @{name="Hawk";size="Small";type="Beast";tags=$null;cr="0";file="13_Animals.md"},
        @{name="Hippopotamus";size="Large";type="Beast";tags=$null;cr="4";file="13_Animals.md"},
        @{name="Hunter Shark";size="Large";type="Beast";tags=$null;cr="2";file="13_Animals.md"},
        @{name="Hyena";size="Medium";type="Beast";tags=$null;cr="0";file="13_Animals.md"},
        @{name="Jackal";size="Small";type="Beast";tags=$null;cr="0";file="13_Animals.md"},
        @{name="Killer Whale";size="Huge";type="Beast";tags=$null;cr="3";file="13_Animals.md"},
        @{name="Lion";size="Large";type="Beast";tags=$null;cr="1";file="13_Animals.md"},
        @{name="Lizard";size="Small";type="Beast";tags=$null;cr="0";file="13_Animals.md"},
        @{name="Mammoth";size="Huge";type="Beast";tags=$null;cr="6";file="13_Animals.md"},
        @{name="Mastiff";size="Medium";type="Beast";tags=$null;cr="1/8";file="13_Animals.md"},
        @{name="Mule";size="Medium";type="Beast";tags=$null;cr="1/8";file="13_Animals.md"},
        @{name="Octopus";size="Small";type="Beast";tags=$null;cr="0";file="13_Animals.md"},
        @{name="Owl";size="Small";type="Beast";tags=$null;cr="0";file="13_Animals.md"},
        @{name="Panther";size="Medium";type="Beast";tags=$null;cr="1/4";file="13_Animals.md"},
        @{name="Piranha";size="Small";type="Beast";tags=$null;cr="0";file="13_Animals.md"},
        @{name="Plesiosaurus";size="Large";type="Beast";tags="Dinosaur";cr="2";file="13_Animals.md"},
        @{name="Polar Bear";size="Large";type="Beast";tags=$null;cr="2";file="13_Animals.md"},
        @{name="Pony";size="Medium";type="Beast";tags=$null;cr="1/8";file="13_Animals.md"},
        @{name="Pteranodon";size="Medium";type="Beast";tags="Dinosaur";cr="1/4";file="13_Animals.md"},
        @{name="Rat";size="Small";type="Beast";tags=$null;cr="0";file="13_Animals.md"},
        @{name="Raven";size="Small";type="Beast";tags=$null;cr="0";file="13_Animals.md"},
        @{name="Reef Shark";size="Medium";type="Beast";tags=$null;cr="1/2";file="13_Animals.md"},
        @{name="Rhinoceros";size="Large";type="Beast";tags=$null;cr="2";file="13_Animals.md"},
        @{name="Riding Horse";size="Large";type="Beast";tags=$null;cr="1/4";file="13_Animals.md"},
        @{name="Saber-Toothed Tiger";size="Large";type="Beast";tags=$null;cr="2";file="13_Animals.md"},
        @{name="Scorpion";size="Small";type="Beast";tags=$null;cr="0";file="13_Animals.md"},
        @{name="Seahorse";size="Small";type="Beast";tags=$null;cr="0";file="13_Animals.md"},
        @{name="Spider";size="Small";type="Beast";tags=$null;cr="0";file="13_Animals.md"},
        @{name="Swarm of Bats";size="Large";type="Beast";tags=$null;cr="1/4";file="13_Animals.md"},
        @{name="Swarm of Insects";size="Medium";type="Beast";tags=$null;cr="1/2";file="13_Animals.md"},
        @{name="Swarm of Piranhas";size="Medium";type="Beast";tags=$null;cr="1";file="13_Animals.md"},
        @{name="Swarm of Rats";size="Medium";type="Beast";tags=$null;cr="1/4";file="13_Animals.md"},
        @{name="Swarm of Ravens";size="Medium";type="Beast";tags=$null;cr="1/4";file="13_Animals.md"},
        @{name="Swarm of Venomous Snakes";size="Medium";type="Beast";tags=$null;cr="2";file="13_Animals.md"},
        @{name="Tiger";size="Large";type="Beast";tags=$null;cr="1";file="13_Animals.md"},
        @{name="Triceratops";size="Huge";type="Beast";tags="Dinosaur";cr="5";file="13_Animals.md"},
        @{name="Tyrannosaurus Rex";size="Huge";type="Beast";tags="Dinosaur";cr="8";file="13_Animals.md"},
        @{name="Venomous Snake";size="Small";type="Beast";tags=$null;cr="1/8";file="13_Animals.md"},
        @{name="Vulture";size="Medium";type="Beast";tags=$null;cr="0";file="13_Animals.md"},
        @{name="Warhorse";size="Large";type="Beast";tags=$null;cr="1/2";file="13_Animals.md"},
        @{name="Weasel";size="Small";type="Beast";tags=$null;cr="0";file="13_Animals.md"},
        @{name="Wolf";size="Medium";type="Beast";tags=$null;cr="1/4";file="13_Animals.md"}
    )

    $sb = New-Object System.Text.StringBuilder
    Append-TableLine $sb "# Monster Index"
    Append-TableLine $sb ""
    Append-TableLine $sb "This index lists every monster and animal in the 5.2.1 SRD. Use it to find which file contains a creature's full stat block."
    Append-TableLine $sb ""

    # Monsters A-Z
    Append-TableLine $sb "## Monsters A-Z"
    Append-TableLine $sb ""
    Append-TableLine $sb "| Monster | CR | Type | Size | File |"
    Append-TableLine $sb "|---------|----|------|------|------|"

    foreach ($m in $monsters) {
        $tagsStr = if ($m.tags) { " ($($m.tags))" } else { "" }
        $line = "| $($m.name) | $($m.cr) | $($m.type)$tagsStr | $($m.size) | $($m.file) |"
        Append-TableLine $sb $line
    }

    # Animals (Beasts)
    Append-TableLine $sb ""
    Append-TableLine $sb "## Animals (Beasts)"
    Append-TableLine $sb ""
    Append-TableLine $sb "These creatures appear in [13_Animals.md](../13_Animals.md). They have type Beast."
    Append-TableLine $sb ""
    Append-TableLine $sb "| Animal | CR | Tags | Size |"
    Append-TableLine $sb "|--------|----|------|------|"

    foreach ($a in $animals) {
        $tagsStr = if ($a.tags) { $a.tags } else { "-" }
        $line = "| $($a.name) | $($a.cr) | $tagsStr | $($a.size) |"
        Append-TableLine $sb $line
    }

    # Combine for CR and Type tables
    $allMonsters = @()
    foreach ($m in $monsters) {
        $obj = @{}
        $obj['name'] = $m.name
        $obj['cr'] = $m.cr
        $obj['type'] = $m.type
        $obj['tags'] = $m.tags
        $obj['size'] = $m.size
        $obj['file'] = $m.file
        $obj['isAnimal'] = $false
        $allMonsters += $obj
    }
    foreach ($a in $animals) {
        $obj = @{}
        $obj['name'] = $a.name
        $obj['cr'] = $a.cr
        $obj['type'] = "Beast"
        $obj['tags'] = $a.tags
        $obj['size'] = $a.size
        $obj['file'] = "13_Animals.md"
        $obj['isAnimal'] = $true
        $allMonsters += $obj
    }

    # Sorting helper: convert fractional CR to numeric
    function To-CrNumeric($cr) {
        if ($cr -match '^(\d+)/(\d+)$') {
            return [double]$Matches[1] / [double]$Matches[2]
        }
        return [double]$cr
    }

    $allMonsters = $allMonsters | Sort-Object { To-CrNumeric($_.cr) }, { $_.name }

    # By CR
    Append-TableLine $sb ""
    Append-TableLine $sb "## By Challenge Rating"
    Append-TableLine $sb ""
    Append-TableLine $sb "| Monster | CR | Type | Size | File |"
    Append-TableLine $sb "|---------|----|------|------|------|"

    foreach ($m in $allMonsters) {
        $tagsStr = if ($m.tags) { " ($($m.tags))" } else { "" }
        $line = "| $($m.name) | $($m.cr) | $($m.type)$tagsStr | $($m.size) | $($m.file) |"
        Append-TableLine $sb $line
    }

    # By Type
    $types = $allMonsters | ForEach-Object { $_.type } | Select-Object -Unique | Sort-Object
    Append-TableLine $sb ""
    Append-TableLine $sb "## By Type"

    foreach ($tp in $types) {
        $filtered = $allMonsters | Where-Object { $_.type -eq $tp } | Sort-Object { To-CrNumeric($_.cr) }
        Append-TableLine $sb ""
        Append-TableLine $sb "### $tp"
        Append-TableLine $sb ""
        Append-TableLine $sb "| Monster | CR | Tags | Size | File |"
        Append-TableLine $sb "|---------|----|------|------|------|"

        foreach ($m in $filtered) {
            $tagsStr = if ($m.tags) { $m.tags } else { "-" }
            $line = "| $($m.name) | $($m.cr) | $tagsStr | $($m.size) | $($m.file) |"
            Append-TableLine $sb $line
        }
    }

    Append-TableLine $sb ""
    Append-TableLine $sb "## Reference"
    Append-TableLine $sb "- [Monster Rules](../11_Monsters.md)"
    Append-TableLine $sb "- [Master Index](../00_INDEX.md)"

    $sb.ToString() | Out-File -FilePath "$srcRoot\Monsters\_monster_index.md" -Encoding UTF8 -NoNewline
    Write-Host "Wrote src\Monsters\_monster_index.md ($($monsters.Count) monsters + $($animals.Count) animals = $($allMonsters.Count) total)"
}

Write-SpellIndex
Write-ItemIndex
Write-MonsterIndex
Write-Host "All indexes generated successfully."
