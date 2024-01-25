# Déterminer le type d'appareil
$computerSystem = Get-WmiObject -Class Win32_ComputerSystem
if ($computerSystem.Model -like "*Virtual*") {
    $type = "VRT"
} elseif ($computerSystem.PCSystemType -eq 1) {
    $type = "DSK"
} else {
    $type = "LAP"
}

# Déterminer l'emplacement
$response = Invoke-RestMethod -Uri 'http://ip-api.com/json/'
if ($response.regionName -eq "Quebec") {
    $location = "QC"
} elseif ($response.regionName -eq "British Columbia") {
    $location = "BC"
} elseif ($response.regionName -eq "Ontario") {
    $location = "ON"
} elseif ($response.countryCode -eq "US") {
    $location = "US"
} elseif ($response.countryCode -eq "EU") {
    $location = "EU"
} else {
    $location = "XX"
}

# Obtenir le numéro de série de l'ordinateur
$serialNumber = (Get-WmiObject -Class Win32_BIOS).SerialNumber

# Supprimer les tirets du numéro de série
$serialNumber = $serialNumber -replace "-", ""

# Utiliser les 4 derniers caractères du numéro de série comme ID de l'ordinateur
$id = $serialNumber.Substring($serialNumber.Length - 5)

# Générer le nom de l'ordinateur
$computerName = $type + $location + $id

# Afficher le nom de l'ordinateur
Write-Output $computerName

# Changer le nom de l'ordinateur
Rename-Computer -NewName $computerName -Restart
