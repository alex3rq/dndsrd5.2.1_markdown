# Splits SP_SRD_CC_v5.2.1.md into src_es/ mirroring the English src/ structure
# NOTE: This script avoids accented characters in source code due to encoding issues.
$ErrorActionPreference = "Stop"

$root = Resolve-Path "$PSScriptRoot\.."
$srcFile = "$root\SP_SRD_CC_v5.2.1.md"
$destDir = "$root\src_es"

# Read the whole file as UTF-8
$lines = [System.IO.File]::ReadAllLines($srcFile, [System.Text.Encoding]::UTF8)

# Ensure destination directories exist
$dirs = @(
    "$destDir",
    "$destDir\03_Clases",
    "$destDir\Conjuros",
    "$destDir\ObjetosMagicos",
    "$destDir\Monstruos"
)
foreach ($d in $dirs) {
    if (-not (Test-Path $d)) {
        New-Item -ItemType Directory -Path $d -Force | Out-Null
    }
}

function Write-File($path, [string[]]$content) {
    $utf8NoBom = New-Object System.Text.UTF8Encoding($false)
    $fullPath = "$destDir\$path"
    [System.IO.File]::WriteAllLines($fullPath, $content, $utf8NoBom)
    Write-Host "  Wrote: src_es\$path ($($content.Count) lines)"
}

function Get-Lines($start, $end) {
    return $lines[($start - 1)..($end - 1)]
}

function Get-FirstLetter($name) {
    $n = $name.Trim('*', ' ', '#')
    if ($n.Length -eq 0) { return "" }
    $c = [int]$n[0]
    # Map accented uppercase letters to base ASCII
    if ($c -eq 0x00C1) { return "A" }  # A-with-acute
    if ($c -eq 0x00C9) { return "E" }  # E-with-acute
    if ($c -eq 0x00CD) { return "I" }  # I-with-acute
    if ($c -eq 0x00D3) { return "O" }  # O-with-acute
    if ($c -eq 0x00DA) { return "U" }  # U-with-acute
    if ($c -ge 65 -and $c -le 90) { return ([char]$c).ToString() }
    if ($c -ge 97 -and $c -le 122) { return ([char]($c - 32)).ToString() }
    return ""
}

Write-Host "=== Fase 1: Archivos de reglas principales ==="

# 00_Legal.md - lines 1-9
Write-File "00_Legal.md" (Get-Lines 1 9)

# 01_ComoJugar.md - lines 382-1211
Write-File "01_ComoJugar.md" (Get-Lines 382 1211)

# 02_CreacionDePersonajes.md - lines 1212-1844
Write-File "02_CreacionDePersonajes.md" (Get-Lines 1212 1844)

# 03_Clases/ - lines 1845-5753 (split by class headers)
Write-Host "=== Fase 2: Clases ==="
$classLines = Get-Lines 1845 5753

# Class header positions are at KNOWN lines relative to classLines (0-indexed):
# Line 1845 = index 0 ("Clases"), 1847 = index 2 (Barbaro), etc.
# Since we can't match accented names, use exact known positions
$classStarts = @(2, 199, 560, 1060, 1417, 1858, 2124, 2287, 2744, 3200, 3417, 3712)
$classFiles = @(
    "01_Barbaro.md", "02_Bardo.md", "03_Brujo.md", "04_Clerigo.md",
    "05_Druida.md", "06_Explorador.md", "07_Guerrero.md", "08_Hechicero.md",
    "09_Mago.md", "10_Monje.md", "11_Paladin.md", "12_Picaro.md"
)

for ($k = 0; $k -lt $classStarts.Count; $k++) {
    $start = $classStarts[$k]
    $end = if ($k -lt $classStarts.Count - 1) { $classStarts[$k+1] - 1 } else { $classLines.Count - 1 }
    $content = $classLines[$start..$end]
    Write-File "03_Clases\$($classFiles[$k])" $content
}

# 04_OrigenesDePersonaje.md - lines 5754-6081
Write-File "04_OrigenesDePersonaje.md" (Get-Lines 5754 6081)

# 05_Dotes.md - lines 6082-6265
Write-File "05_Dotes.md" (Get-Lines 6082 6265)

# 06_Equipo.md - lines 6266-7410
Write-File "06_Equipo.md" (Get-Lines 6266 7410)

# 08_GlosarioDeReglas.md - lines 13503-14624
Write-File "08_GlosarioDeReglas.md" (Get-Lines 13503 14624)

# 09_HerramientasDelJuego.md - lines 14625-15307
Write-File "09_HerramientasDelJuego.md" (Get-Lines 14625 15307)

# 11_Monstruos.md (rules only) - lines 18552-18819
Write-File "11_Monstruos.md" (Get-Lines 18552 18819)

# 13_Animales.md - lines 27857 to end
Write-File "13_Animales.md" (Get-Lines 27857 $lines.Count)

# =====================================================
# Fase 3: Conjuros (Spells)
# =====================================================
Write-Host "=== Fase 3: Conjuros ==="

# Spells rules: lines 7411-7597
Write-File "Conjuros\ReglasConjuros.md" (Get-Lines 7411 7597)

# Spell descriptions: lines 7598-13502
$spellLines = Get-Lines 7598 13502

# Sub-section words to skip (not spell names)
$skipWords = @(
    'Atributos','Acciones','Reacciones','Acciones adicionales',
    'Conjuros','Componentes','Escuela','Listas','Tiempo',
    'Descripciones','Tiradas','Corcel','Objeto','Avatar',
    'Capas','Mosca','Esqueleto','Zombi','Guerrero',
    'Resultado','Definiciones','Espíritu'
)

# Parse spells into letter buckets
$spellBuckets = @{}
$currentLetter = ""
for ($i = 0; $i -lt $spellLines.Count; $i++) {
    $line = $spellLines[$i]
    # Match spell header: #{1,4} **Name** or ### Name
    if ($line -match '^#{1,4} \*\*([^*]+?)\*\*$') {
        $name = $Matches[1].Trim()
        if ($name -notin $skipWords) {
            $L = Get-FirstLetter $name
            if ($L) { $currentLetter = $L }
        }
    } elseif ($line -match '^#{1,3} ([A-Za-z\xC0-\xFF].+)$') {
        $name = $Matches[1].Trim()
        if ($name -notin $skipWords) {
            $L = Get-FirstLetter $name
            if ($L) { $currentLetter = $L }
        }
    }
    
    if ($currentLetter) {
        if (-not $spellBuckets.ContainsKey($currentLetter)) {
            $spellBuckets[$currentLetter] = New-Object System.Collections.ArrayList
        }
        [void]$spellBuckets[$currentLetter].Add($line)
    }
}

# Map letters to output files (same grouping as English src)
$spellFileMap = @{
    'A'="Conjuros_A.md"; 'B'="Conjuros_B.md"; 'C'="Conjuros_C.md"
    'D'="Conjuros_D.md"; 'E'="Conjuros_E.md"; 'F'="Conjuros_F.md"
    'G'="Conjuros_G.md"; 'H'="Conjuros_H.md"; 'I'="Conjuros_I.md"
    'J'="Conjuros_JKL.md"; 'K'="Conjuros_JKL.md"; 'L'="Conjuros_JKL.md"
    'M'="Conjuros_MN.md"; 'N'="Conjuros_MN.md"; 'O'="Conjuros_O.md"
    'P'="Conjuros_P.md"; 'R'="Conjuros_R.md"; 'S'="Conjuros_S.md"
    'T'="Conjuros_T.md"
    'U'="Conjuros_U-Z.md"; 'V'="Conjuros_U-Z.md"; 'Z'="Conjuros_U-Z.md"
}

$groupedSpells = @{}
foreach ($letter in $spellBuckets.Keys) {
    $f = $spellFileMap[$letter]
    if (-not $f) { Write-Host "  WARNING: No spell file for letter $letter"; continue }
    if (-not $groupedSpells.ContainsKey($f)) { $groupedSpells[$f] = New-Object System.Collections.ArrayList }
    foreach ($l in $spellBuckets[$letter]) { [void]$groupedSpells[$f].Add($l) }
}
foreach ($f in ($groupedSpells.Keys | Sort-Object)) {
    Write-File "Conjuros\$f" ($groupedSpells[$f].ToArray())
}

# =====================================================
# Fase 4: Objetos Magicos (Magic Items)
# =====================================================
Write-Host "=== Fase 4: Objetos Magicos ==="

# Magic item rules: lines 15308-15629
Write-File "ObjetosMagicos\ReglasObjetosMagicos.md" (Get-Lines 15308 15629)

# Magic items A-Z: lines 15630-18551
$itemLines = Get-Lines 15630 18551

$itemSkipWords = @(
    'Atributos','Acciones','Reacciones','Acciones adicionales',
    'Características','Caracteristicas','Alineamiento','Comunicacion',
    'Sentidos','Proposito','Conflicto','Categorias','Objetos',
    'Rareza','Valor','Activar','Siguiente','Resistencia','Fabricar',
    'Competencia','Herramientas','Tiempo','Pergaminos','Avatar',
    'Objeto','Pergamino','Categor','Pasajeros','Tripulacion',
    'Velocidad','Reparacion','Umbral','Sillas','Barda','Monturas',
    'Arreos','Deplorable','Miserable','Pobre','Modesto','Comodo',
    'Lujoso','Aristocratico','Comida','Asalariados','Lanzamiento',
    'Identificar','Sintonizacion','Vestir','Materias','Elaborar',
    'Requisitos','Trucos','Trabajo','Ayudantes','Puntuaciones',
    'Capacidad','Consumo','Elegir','Ejemplos','Fiebre','Plaga',
    'Efectos','Descanso','Aguas','Hielo','Precipitaciones','Miedo',
    'Comprar','Recoger','Venenos','Aceite','Aguijon','Esencia',
    'Lagrimas','Letargo','Malicia','Moco','Ponzona','Sangre',
    'Suero','Tintura','Vapores','Veneno','Trampas','Partes',
    'Encuentros','Dificultad','Paso','Muchas','Ajustes','Criaturas',
    'Numero','Rasgos','Solucion','Estatua','Pozo','Red','Roca','Techo'
)

$itemBuckets = @{}
$currentLetter = ""
for ($i = 0; $i -lt $itemLines.Count; $i++) {
    $line = $itemLines[$i]
    # Match item header: #{1,4} **Name** or ### Name or #### Name
    if ($line -match '^#{1,4} \*\*([^*]+?)\*\*$') {
        $name = $Matches[1].Trim()
        if ($name -notin $itemSkipWords -and $name -notmatch '^Objeto') {
            $L = Get-FirstLetter $name
            if ($L) { $currentLetter = $L }
        }
    } elseif ($line -match '^#{1,4} ([A-Za-z\xC0-\xFF][A-Za-z\xC0-\xFF \-]+?)$') {
        $name = $Matches[1].Trim()
        if ($name -notin $itemSkipWords -and $name -notmatch '^(Objeto|Caracter|Alineam|Comunic|Sentido|Propos|Conflic|Categor|Rareza|Valor|Activar|Siguiente|Resist|Fabric|Compete|Herrami|Tiempo|Pergam|Montur|Pasaj|Tripul|Veloc|Repar|Umbral|Silla|Barda|Arreo|Deplor|Miser|Pobre|Modest|Comod|Lujos|Aristo|Comida|Asalar|Lanzam|Identif|Sinton|Vestir|Materi|Elabo|Requi|Truco|Traba|Ayuda|Puntua|Capaci|Consu|Elegi|Ejemp|Fiebr|Plaga|Efect|Desca|Aguas|Hielo|Precip|Miedo|Compr|Recog|Veneno|Lagri|Letar|Malic|Ponzo|Sangr|Suer|Tintu|Vapor|Tramp|Parte|Encuen|Dific|Mucha|Ajust|Criat|Numer|Rasgo|Soluc|Estatu|Roca|Techo)') {
            $L = Get-FirstLetter $name
            if ($L) { $currentLetter = $L }
        }
    }
    
    if ($currentLetter) {
        if (-not $itemBuckets.ContainsKey($currentLetter)) {
            $itemBuckets[$currentLetter] = New-Object System.Collections.ArrayList
        }
        [void]$itemBuckets[$currentLetter].Add($line)
    }
}

$itemFileMap = @{}
'A','B','C','D','E','F','G','H','I','J','L','M','N','O','P','Q','R','S','T','U','V','W','Y' | ForEach-Object {
    $itemFileMap[$_] = "ObjetosMagicos_$_.md"
}

$groupedItems = @{}
foreach ($letter in $itemBuckets.Keys) {
    $f = $itemFileMap[$letter]
    if (-not $f) { Write-Host "  WARNING: No item file for letter $letter"; continue }
    if (-not $groupedItems.ContainsKey($f)) { $groupedItems[$f] = New-Object System.Collections.ArrayList }
    foreach ($l in $itemBuckets[$letter]) { [void]$groupedItems[$f].Add($l) }
}
foreach ($f in ($groupedItems.Keys | Sort-Object)) {
    Write-File "ObjetosMagicos\$f" ($groupedItems[$f].ToArray())
}

# =====================================================
# Fase 5: Monstruos (Monsters)
# =====================================================
Write-Host "=== Fase 5: Monstruos ==="

# Monster descriptions A-Z: lines 18820-27856
$monsterLines = Get-Lines 18820 27856

$monsterSkipWords = @(
    'Atributos','Acciones','Reacciones','Acciones adicionales',
    'Acciones legendarias','Descripcion','Partes','Tamano',
    'Tipo','Etiquetas','Alineamiento','Clase','Iniciativa','Puntos',
    'Velocidad','Puntuaciones','Habilidades','Resistencias','Inmunidades',
    'Equipo','Municion','Sentidos','Idiomas','Telepatia','Valor',
    'Bonificador','Accion adicional','Uso limitado','Ataque multiple',
    'Dragones azules','Dragones blancos','Dragones de bronce',
    'Dragones de cobre','Dragones de oro','Dragones de oropel',
    'Dragones de plata','Dragones negros','Dragones rojos',
    'Dragones verdes','Esfinges','Esqueletos','Goblins',
    'Guardias','Guerreros','Hobgoblins','Hongos','Magos',
    'Mephits','Momias','Objetos animados','Osgos',
    'Pendencieros','Piratas','Plantas despertadas',
    'Sacerdotes','Sectarios','Vampiros','Zombis',
    'Bandidos','Cubo gelatinoso','Guardian escudo'
)

$monsterBuckets = @{}
$currentLetter = ""
for ($i = 0; $i -lt $monsterLines.Count; $i++) {
    $line = $monsterLines[$i]
    if ($line -match '^# \*\*([^*]+?)\*\*$') {
        $name = $Matches[1].Trim()
        if ($name -notin $monsterSkipWords -and $name -notmatch '^Dragones') {
            $L = Get-FirstLetter $name
            if ($L) { $currentLetter = $L }
        }
    }
    
    if ($currentLetter) {
        if (-not $monsterBuckets.ContainsKey($currentLetter)) {
            $monsterBuckets[$currentLetter] = New-Object System.Collections.ArrayList
        }
        [void]$monsterBuckets[$currentLetter].Add($line)
    }
}

$monsterFileMap = @{}
'A','B','C','D','E','F','G','H','I','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z' | ForEach-Object {
    $monsterFileMap[$_] = "Monstruos_$_.md"
}

$groupedMonsters = @{}
foreach ($letter in $monsterBuckets.Keys) {
    $f = $monsterFileMap[$letter]
    if (-not $f) { Write-Host "  WARNING: No monster file for letter $letter"; continue }
    if (-not $groupedMonsters.ContainsKey($f)) { $groupedMonsters[$f] = New-Object System.Collections.ArrayList }
    foreach ($l in $monsterBuckets[$letter]) { [void]$groupedMonsters[$f].Add($l) }
}
foreach ($f in ($groupedMonsters.Keys | Sort-Object)) {
    Write-File "Monstruos\$f" ($groupedMonsters[$f].ToArray())
}

Write-Host ""
Write-Host "=== Split complete! ==="
Write-Host "Output directory: src_es\"
