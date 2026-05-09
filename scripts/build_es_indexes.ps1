# Extract spell/monster/item names from split files to generate indexes
$ErrorActionPreference = "Stop"
$root = Resolve-Path "$PSScriptRoot\..\src_es"

function Write-File($path, [string]$content) {
    $utf8NoBom = New-Object System.Text.UTF8Encoding($false)
    [System.IO.File]::WriteAllText("$root\$path", $content, $utf8NoBom)
    Write-Host "  Wrote: $path"
}

# ============================================
# SPELL INDEX
# ============================================
Write-Host "=== Generating spell index ==="
$spellFiles = Get-ChildItem "$root\Conjuros\Conjuros_*.md" | Sort-Object Name
$spells = New-Object System.Collections.ArrayList

foreach ($f in $spellFiles) {
    $lines = [System.IO.File]::ReadAllLines($f.FullName, [System.Text.Encoding]::UTF8)
    for ($i = 0; $i -lt $lines.Count - 1; $i++) {
        $line = $lines[$i].Trim()
        # Spell header: #{1,4} **Name**
        if ($line -match '^#{1,4} \*\*(.+?)\*\*$') {
            $spellName = $Matches[1].Trim()
            # Skip subsection headers
            if ($spellName -in @('Atributos','Acciones','Reacciones','Acciones adicionales','Descripciones de conjuros','Conjuros','Corcel sobrenatural','Espiritu dracónico','Objeto animado','Capas prismaticas')) { continue }
            if ($spellName -like 'Corcel*' -or $spellName -like 'Espiritu*' -or $spellName -like 'Objeto*' -or $spellName -like 'Capas*' -or $spellName -like 'Resultado*' -or $spellName -like 'Mosca*') { continue }
            
            # Find the school/level/classes line (skip blank lines)
            $infoIdx = $i + 1
            while ($infoIdx -lt $lines.Count -and $lines[$infoIdx].Trim() -eq "") { $infoIdx++ }
            if ($infoIdx -lt $lines.Count) {
                $infoLine = $lines[$infoIdx].Trim()
                # Match: "Transmutacion de nivel 2 (bardo, hechicero, mago)" or "*Abjuracion de nivel 2 (druida, explorador)*"
                if ($infoLine -match '^\*?(.+?) de nivel (\S+) \((.+?)\)\*?$') {
                    $school = $Matches[1]
                    $level = $Matches[2]
                    $classes = $Matches[3].TrimEnd('*')
                    if ($level -eq 'truco') { $level = 'Truco' }
                    [void]$spells.Add(@{
                        Name = $spellName
                        Level = $level
                        School = $school
                        Classes = $classes
                        File = $f.Name
                    })
                }
            }
        }
    }
}

$sb = New-Object System.Text.StringBuilder
[void]$sb.AppendLine("# Indice de Conjuros")
[void]$sb.AppendLine("")
[void]$sb.AppendLine("Este indice lista todos los conjuros del SRD 5.2.1. Usalo para encontrar en que archivo esta la descripcion completa de cada conjuro.")
[void]$sb.AppendLine("")
[void]$sb.AppendLine("## Busqueda rapida (alfabetica)")
[void]$sb.AppendLine("")
[void]$sb.AppendLine("| Conjuro | Nivel | Escuela | Clases | Archivo |")
[void]$sb.AppendLine("|---------|-------|---------|--------|---------|")

$spellsSorted = $spells | Sort-Object Name
foreach ($s in $spellsSorted) {
    [void]$sb.AppendLine("| $($s.Name) | $($s.Level) | $($s.School) | $($s.Classes) | $($s.File) |")
}

[void]$sb.AppendLine("")
[void]$sb.AppendLine("## Referencia")
[void]$sb.AppendLine("- [Reglas de lanzamiento de conjuros](ReglasConjuros.md)")
[void]$sb.AppendLine("- [Indice maestro](../00_INDEX.md)")

Write-File "Conjuros\_conjuro_index.md" $sb.ToString()
Write-Host "  $($spellsSorted.Count) conjuros indexados"

# ============================================
# MONSTER INDEX
# ============================================
Write-Host "=== Generating monster index ==="
$monsterFiles = Get-ChildItem "$root\Monstruos\Monstruos_*.md" | Sort-Object Name
$monsters = New-Object System.Collections.ArrayList
$monsterSkip = @('Atributos','Acciones','Reacciones','Acciones adicionales','Acciones legendarias',
    'Dragones azules','Dragones blancos','Dragones de bronce','Dragones de cobre','Dragones de oro',
    'Dragones de oropel','Dragones de plata','Dragones negros','Dragones rojos','Dragones verdes',
    'Esfinges','Esqueletos','Goblins','Guardias','Guerreros','Hobgoblins','Hongos','Magos',
    'Mephits','Momias','Objetos animados','Osgos','Pendencieros','Piratas','Plantas despertadas',
    'Sacerdotes','Sectarios','Vampiros','Zombis','Bandidos','Ataque multiple')

foreach ($f in $monsterFiles) {
    $lines = [System.IO.File]::ReadAllLines($f.FullName, [System.Text.Encoding]::UTF8)
    $prevWasName = $false
    $prevName = ""
    for ($i = 0; $i -lt $lines.Count - 1; $i++) {
        $line = $lines[$i].Trim()
        # Monster header: # **Name**
        if ($line -match '^# \*\*(.+?)\*\*$') {
            $name = $Matches[1].Trim()
            if ($name -in $monsterSkip) { $prevWasName = $false; continue }
            if ($name -like 'Dragones*') { $prevWasName = $false; continue }
            
            # Check if this is a duplicate (monster names appear twice)
            if ($prevWasName -and $name -eq $prevName) {
                # Second occurrence - skip
                $prevWasName = $false
                continue
            }
            # Look ahead for type line
            $nextIdx = $i + 1
            while ($nextIdx -lt $lines.Count -and $lines[$nextIdx].Trim() -eq "") { $nextIdx++ }
            if ($nextIdx -lt $lines.Count) {
                $nextLine = $lines[$nextIdx].Trim()
                # Type line: *Aberracion Grande, legal malvada*
                if ($nextLine -match '^\*(.+?)\*$') {
                    $typeInfo = $Matches[1]
                    [void]$monsters.Add(@{ Name = $name; TypeInfo = $typeInfo; File = $f.Name })
                    $prevWasName = $true
                    $prevName = $name
                    continue
                }
            }
            $prevWasName = $true
            $prevName = $name
        } else {
            $prevWasName = $false
        }
    }
}

$sb2 = New-Object System.Text.StringBuilder
[void]$sb2.AppendLine("# Indice de Monstruos")
[void]$sb2.AppendLine("")
[void]$sb2.AppendLine("Este indice lista todos los monstruos y animales del SRD 5.2.1. Usalo para encontrar en que archivo esta el perfil completo de cada criatura.")
[void]$sb2.AppendLine("")
[void]$sb2.AppendLine("## Monstruos A-Z")
[void]$sb2.AppendLine("")
[void]$sb2.AppendLine("| Monstruo | Tipo | Archivo |")
[void]$sb2.AppendLine("|----------|------|---------|")

$monstersSorted = $monsters | Sort-Object Name
$seen = @{}
foreach ($m in $monstersSorted) {
    if (-not $seen.ContainsKey($m.Name)) {
        $seen[$m.Name] = $true
        [void]$sb2.AppendLine("| $($m.Name) | $($m.TypeInfo) | $($m.File) |")
    }
}

[void]$sb2.AppendLine("")
[void]$sb2.AppendLine("## Animales (Bestias)")
[void]$sb2.AppendLine("")
[void]$sb2.AppendLine("Estas criaturas aparecen en [13_Animales.md](../13_Animales.md).")
[void]$sb2.AppendLine("")
[void]$sb2.AppendLine("## Referencia")
[void]$sb2.AppendLine("- [Reglas de monstruos](../11_Monstruos.md)")
[void]$sb2.AppendLine("- [Indice maestro](../00_INDEX.md)")

Write-File "Monstruos\_monstruo_index.md" $sb2.ToString()
Write-Host "  $($seen.Count) monstruos indexados"

# ============================================
# MAGIC ITEM INDEX
# ============================================
Write-Host "=== Generating item index ==="
$itemFiles = Get-ChildItem "$root\ObjetosMagicos\ObjetosMagicos_*.md" | Sort-Object Name
$items = New-Object System.Collections.ArrayList

$itemSkip = @('Objetos magicos de la A a la Z','Atributos','Acciones','Reacciones','Acciones adicionales')

foreach ($f in $itemFiles) {
    $lines = [System.IO.File]::ReadAllLines($f.FullName, [System.Text.Encoding]::UTF8)
    for ($i = 0; $i -lt $lines.Count - 1; $i++) {
        $line = $lines[$i].Trim()
        $itemName = $null
        if ($line -match '^#{1,4} \*\*(.+?)\*\*$') {
            $itemName = $Matches[1].Trim()
        } elseif ($line -match '^#{1,4} ([A-Z].+)$') {
            $candidate = $Matches[1].Trim()
            # Skip known sub-headers
            if ($candidate -notin $itemSkip -and $candidate -notmatch '^(Objetos|Objeto|Caracter|Alinea|Comunic|Sentido|Propos|Conflic|Categor|Rareza|Valor|Activar|Siguiente|Resist|Fabric|Compet|Herrami|Tiempo|Pergam|Montur|Pasaj|Tripul|Veloc|Repar|Umbral|Silla|Barda|Arreo|Deplor|Miser|Pobre|Modest|Comod|Lujos|Aristo|Comida|Asalar|Lanzam|Identif|Sinton|Vestir|Materi|Elabo|Requi|Truco|Traba|Ayuda|Puntua|Capaci|Consu|Elegi|Ejemp|Fiebr|Plaga|Efect|Desca|Aguas|Hielo|Precip|Miedo|Compr|Recog|Venen|Lagri|Letar|Malic|Ponzo|Sangr|Suer|Tintu|Vapor|Tramp|Parte|Encuen|Dific|Mucha|Ajust|Criat|Numer|Rasgo|Soluc|Estatu|Roca|Techo|Mosc|Avat)') {
                # Check next line for type/rarity info
                $nextIdx = $i + 1
                while ($nextIdx -lt $lines.Count -and $lines[$nextIdx].Trim() -eq "") { $nextIdx++ }
                if ($nextIdx -lt $lines.Count) {
                    $nextLine = $lines[$nextIdx].Trim()
                    # Next line should be something like: Objeto maravilloso, raro OR *Objeto maravilloso, raro*
                    if ($nextLine -match '^(\*?[A-Z].+(?:comun|infrecuente|raro|legendario).*\*?)$' -and $nextLine -notmatch '^(Mientras|Esta|Este|Puedes|El|Un)') {
                        $itemName = $candidate
                    }
                }
            }
        }
        
        if ($itemName) {
            # Get the info from next non-empty line
            $nextIdx = $i + 1
            while ($nextIdx -lt $lines.Count -and $lines[$nextIdx].Trim() -eq "") { $nextIdx++ }
            if ($nextIdx -lt $lines.Count) {
                $infoLine = $lines[$nextIdx].Trim().Trim('*')
                [void]$items.Add(@{ Name = $itemName; Info = $infoLine; File = $f.Name })
            }
        }
    }
}

$sb3 = New-Object System.Text.StringBuilder
[void]$sb3.AppendLine("# Indice de Objetos Magicos")
[void]$sb3.AppendLine("")
[void]$sb3.AppendLine("Este indice lista todos los objetos magicos del SRD 5.2.1. Usalo para encontrar en que archivo esta la descripcion completa de cada objeto.")
[void]$sb3.AppendLine("")
[void]$sb3.AppendLine("## Busqueda rapida (alfabetica)")
[void]$sb3.AppendLine("")
[void]$sb3.AppendLine("| Objeto | Categoria/Rareza | Archivo |")
[void]$sb3.AppendLine("|--------|-----------------|---------|")

$itemsSorted = $items | Sort-Object Name
$seenItems = @{}
foreach ($it in $itemsSorted) {
    if (-not $seenItems.ContainsKey($it.Name)) {
        $seenItems[$it.Name] = $true
        [void]$sb3.AppendLine("| $($it.Name) | $($it.Info) | $($it.File) |")
    }
}

[void]$sb3.AppendLine("")
[void]$sb3.AppendLine("## Referencia")
[void]$sb3.AppendLine("- [Reglas de objetos magicos](ReglasObjetosMagicos.md)")
[void]$sb3.AppendLine("- [Indice maestro](../00_INDEX.md)")

Write-File "ObjetosMagicos\_objeto_index.md" $sb3.ToString()
Write-Host "  $($seenItems.Count) objetos indexados"

Write-Host ""
Write-Host "=== Index generation complete! ==="
