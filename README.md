# Script para Reiniciar el Servicio de Impresión y Limpiar la Cola de Impresión

Este script en PowerShell está diseñado para:
- Detener el servicio de impresión (Spooler).
- Limpiar la cola de impresión eliminando los archivos temporales generados por Windows.
- Reiniciar el servicio de impresión para resolver errores relacionados.
- Registrar eventos de éxito o errores en un archivo de log y en el Visor de Eventos de Windows.

## Requisitos Previos
1. **Permitir la ejecución de scripts:** Asegúrate de habilitar la ejecución de scripts de PowerShell ejecutando el siguiente comando como administrador:
   ```powershell
   Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
   ```
2. **Permisos de administrador:** El script requiere privilegios administrativos para detener y reiniciar el servicio de impresión.

## Archivos Generados
- **Log de eventos:** Los eventos del script se registran en el archivo:
  ```
  C:\Users\USUARIO\Desktop\Logs\SpoolerLog.txt
  ```

## ¿Cómo funciona el script?
1. **Detención del servicio de impresión:** Detiene el servicio de impresión `Spooler`.
2. **Limpieza de la cola de impresión:** Elimina los archivos pendientes en la carpeta:
   ```
   C:\Windows\System32\spool\PRINTERS\
   ```
   Estos archivos temporales incluyen:
   - **`.spl`:** Contienen los datos del documento a imprimir.
   - **`.shd`:** Contienen información de control, como el usuario que envió el trabajo y las opciones de impresión.
3. **Reinicio del servicio:** Vuelve a iniciar el servicio `Spooler` para aceptar nuevos trabajos de impresión.
4. **Registro de eventos:**
   - **Eventos exitosos** se registran como informativos en el Visor de Eventos de Windows.
   - **Errores** se registran como eventos de error y también se guardan en el archivo de log.

## Importante
- **Limpieza de la cola:** Este proceso elimina todos los trabajos pendientes en la cola de impresión. Esto puede solucionar errores, pero significa que cualquier trabajo en espera se perderá y no podrá recuperarse.
- **Privilegios:** Asegúrate de ejecutar el script con permisos de administrador para que funcione correctamente.

## Uso
1. Guarda el script en un archivo con extensión `.ps1` (por ejemplo, `ReiniciarColaImpresion.ps1`).
2. Ejecuta el script desde PowerShell:
   ```powershell
   .\ReiniciarColaImpresion.ps1
   ```

## Registro de Eventos
El script utiliza el origen `SpoolerScript` en el Visor de Eventos de Windows (LogName: Application):
- **Event ID 1000:** Indica que el servicio se reinició correctamente.
- **Event ID 1001:** Indica un error al intentar reiniciar el servicio o limpiar la cola.

## Contribuciones
Si deseas contribuir con mejoras o reportar problemas, puedes hacerlo a través de un repositorio en GitHub.

---

Este script está diseñado para facilitar la solución de problemas comunes relacionados con la impresión en sistemas Windows.
