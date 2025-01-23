# Ruta del archivo de log
$logFilePath = "C:\Users\USUARIO\Desktop\Logs\SpoolerLog.txt"

# Crear el directorio si no existe
if (-not (Test-Path -Path (Split-Path -Path $logFilePath))) {
    New-Item -ItemType Directory -Path (Split-Path -Path $logFilePath) -Force
}

# Función para escribir en el log
function Write-Log {
    param (
        [string]$Message
    )
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $entry = "$timestamp - $Message"
    try {
        Add-Content -Path $logFilePath -Value $entry
    } catch {
        Write-Host "Error al escribir en el log: $_"
    }
}

# Validar y registrar el origen del evento solo si no existe
if (-not [System.Diagnostics.EventLog]::SourceExists("SpoolerScript")) {
    try {
        New-EventLog -LogName "Application" -Source "SpoolerScript"
    } catch {
        Write-Log "No se pudo registrar el origen en el Visor de Eventos: $_"
    }
}

# Intentar reiniciar el servicio Spooler y limpiar la cola de impresión
try {
    # Detener el servicio Spooler
    Stop-Service -Name "Spooler" -Force -ErrorAction Stop
    Write-Log "Servicio Spooler detenido."

    # Limpiar la cola de impresión
    Remove-Item -Path "C:\Windows\System32\spool\PRINTERS\*" -Recurse -Force -ErrorAction Stop
    Write-Log "Cola de impresión limpiada."

    # Iniciar el servicio Spooler
    Start-Service -Name "Spooler" -ErrorAction Stop
    Write-Log "Servicio Spooler iniciado correctamente."

    # Registrar éxito en el evento
    Write-EventLog -LogName "Application" -Source "SpoolerScript" -EventId 1000 -EntryType Information -Message "El servicio Spooler se reinició correctamente."

} catch {
    # Registrar el error en el log y en el Visor de Eventos
    Write-Log "Error al reiniciar el servicio Spooler: $_"
    try {
        Write-EventLog -LogName "Application" -Source "SpoolerScript" -EventId 1001 -EntryType Error -Message "Error al reiniciar el servicio Spooler: $_"
    } catch {
        Write-Log "No se pudo registrar el error en el Visor de Eventos: $_"
    }
}
