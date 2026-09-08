#!/bin/bash

# SCRIPT AUTOMATICO PARA LINUX MINT - INYECTAR HOUDINI EN BLISS OS
# Este script hace TODO automaticamente para que lo entienda la IA
# Solo necesitas: Linux Mint, houdini_7.1.1a_y.49564.zip, y ADB

set -e  # Detener si hay error

echo "================================================"
echo "  HOUDINI INJECTOR - Linux Mint + Bliss OS"
echo "  Automatico para IA"
echo "================================================"
echo ""

# VARIABLES
WORKDIR="$HOME/houdini_work"
HOUDINI_ZIP="houdini_7.1.1a_y.49564.zip"  # Cambiar si tienes otro nombre
MODULE_DIR="magisk_houdini_module"
FINAL_ZIP="houdini_magisk_FINAL.zip"

echo "[PASO 1] Crear directorio de trabajo..."
mkdir -p "$WORKDIR"
cd "$WORKDIR"
echo "✓ OK: Trabajando en $WORKDIR"
echo ""

echo "[PASO 2] Buscar archivo Houdini..."
if [ ! -f "$HOUDINI_ZIP" ]; then
    echo "❌ ERROR: No encontre $HOUDINI_ZIP"
    echo "   Coloca el archivo en: $WORKDIR/"
    echo "   O cambia la variable HOUDINI_ZIP en este script"
    exit 1
fi
echo "✓ OK: Encontre $HOUDINI_ZIP"
echo ""

echo "[PASO 3] Extraer archivo Houdini..."
rm -rf houdini_extracted
unzip -q "$HOUDINI_ZIP" -d houdini_extracted
echo "✓ OK: Extraído"
echo ""

echo "[PASO 4] Verificar archivos críticos..."
if [ ! -f "houdini_extracted/system/lib/arm/libhoudini.so" ]; then
    echo "❌ ERROR: No encontre libhoudini.so 32-bit"
    exit 1
fi
if [ ! -f "houdini_extracted/system/lib64/arm64/libhoudini.so" ]; then
    echo "❌ ERROR: No encontre libhoudini.so 64-bit"
    exit 1
fi
echo "✓ OK: Ambos archivos libhoudini.so existen"
echo "   - /system/lib/arm/libhoudini.so: $(ls -lh houdini_extracted/system/lib/arm/libhoudini.so | awk '{print $5}')"
echo "   - /system/lib64/arm64/libhoudini.so: $(ls -lh houdini_extracted/system/lib64/arm64/libhoudini.so | awk '{print $5}')"
echo ""

echo "[PASO 5] Descargar módulo Magisk base desde GitHub..."
rm -rf "$MODULE_DIR"
git clone -q https://github.com/mauriciogsv/Houdini-Magisk-Android14-x86.git "$MODULE_DIR" 2>/dev/null || {
    echo "⚠️ WARNING: No pude clonar por git, descargando ZIP..."
    wget -q https://github.com/mauriciogsv/Houdini-Magisk-Android14-x86/archive/refs/heads/main.zip -O module_base.zip
    unzip -q module_base.zip
    mv Houdini-Magisk-Android14-x86-main "$MODULE_DIR"
}
echo "✓ OK: Módulo descargado"
echo ""

echo "[PASO 6] Copiar carpeta system/ de Houdini al módulo..."
rm -rf "$MODULE_DIR/system"
cp -r houdini_extracted/system "$MODULE_DIR/"
echo "✓ OK: Carpeta system/ copiada"
echo ""

echo "[PASO 7] Verificar estructura del módulo..."
echo "Estructura esperada:"
echo "$MODULE_DIR/"
echo "├─ module.prop"
echo "├─ system.prop"
echo "├─ service.sh"
echo "├─ customize.sh"
echo "├─ install.sh"
echo "├─ system/"
echo "│  ├─ lib/arm/libhoudini.so"
echo "│  └─ lib64/arm64/libhoudini.so"
echo ""

echo "Verificando archivos..."
if [ ! -f "$MODULE_DIR/module.prop" ]; then echo "❌ FALTA: module.prop"; exit 1; fi
if [ ! -f "$MODULE_DIR/system.prop" ]; then echo "❌ FALTA: system.prop"; exit 1; fi
if [ ! -f "$MODULE_DIR/service.sh" ]; then echo "❌ FALTA: service.sh"; exit 1; fi
if [ ! -f "$MODULE_DIR/customize.sh" ]; then echo "❌ FALTA: customize.sh"; exit 1; fi
if [ ! -f "$MODULE_DIR/install.sh" ]; then echo "❌ FALTA: install.sh"; exit 1; fi
if [ ! -f "$MODULE_DIR/system/lib/arm/libhoudini.so" ]; then echo "❌ FALTA: system/lib/arm/libhoudini.so"; exit 1; fi
if [ ! -f "$MODULE_DIR/system/lib64/arm64/libhoudini.so" ]; then echo "❌ FALTA: system/lib64/arm64/libhoudini.so"; exit 1; fi
echo "✓ OK: Todos los archivos están en su lugar"
echo ""

echo "[PASO 8] Crear ZIP del módulo (ESTRUCTURA CORRECTA)..."
cd "$MODULE_DIR"
rm -f "../$FINAL_ZIP"
zip -r -q "../$FINAL_ZIP" module.prop system.prop service.sh customize.sh install.sh system/
cd ..
echo "✓ OK: ZIP creado"
echo ""

echo "[PASO 9] Verificar tamaño y contenido del ZIP..."
ZIP_SIZE=$(ls -lh "$FINAL_ZIP" | awk '{print $5}')
echo "Tamaño del ZIP: $ZIP_SIZE"
if [ "$ZIP_SIZE" = "0" ]; then
    echo "❌ ERROR: ZIP está vacío"
    exit 1
fi

echo ""
echo "Verificando estructura del ZIP (debe mostrar archivos DIRECTAMENTE):"
echo "Primeras líneas del ZIP:"
unzip -l "$FINAL_ZIP" | head -15
echo ""

echo "[PASO 10] Transferir ZIP a Bliss OS via ADB..."
echo ""
echo "Verificando conexión ADB..."
if ! command -v adb &> /dev/null; then
    echo "❌ ERROR: ADB no está instalado"
    echo "   Instala: sudo apt install android-tools-adb"
    exit 1
fi

echo "Esperando dispositivo Bliss OS conectado..."
adb wait-for-device > /dev/null 2>&1 || true

if ! adb devices | grep -q "device$"; then
    echo "⚠️ WARNING: No se detectó dispositivo ADB"
    echo "   Conecta Bliss OS via USB o VirtualBox"
    echo "   Habilita depuración USB en Bliss OS"
    echo ""
    echo "El ZIP está listo en: $WORKDIR/$FINAL_ZIP"
    echo "Transfierelo manualmente:"
    echo "  1. Va USB o archivo
    echo "  2. Coloca en /sdcard/Download/ en Bliss OS"
    echo "  3. Abre Magisk Manager
    echo "  4. Presiona '+' > Instala el ZIP"
    exit 0
fi

echo "✓ OK: Dispositivo detectado"
echo ""

adb root > /dev/null 2>&1 || true
sleep 1

echo "Enviando ZIP a Bliss OS..."
adb push "$FINAL_ZIP" /sdcard/Download/ > /dev/null
echo "✓ OK: ZIP transferido"
echo ""

echo "Verificando que llegó..."
adb shell ls -lh /sdcard/Download/$FINAL_ZIP
echo ""

echo "================================================"
echo "  ✅ TODO LISTO"
echo "================================================"
echo ""
echo "PROXIMOS PASOS EN BLISS OS:"
echo ""
echo "1. Abre Magisk Manager (icono M)"
echo "2. Presiona el botón '+' (Install from Storage)"
echo "3. Navega a: /sdcard/Download/$FINAL_ZIP"
echo "4. Selecciona y presiona INSTALL"
echo "5. Espera a que termine"
echo "6. PRESIONA RESTART o reinicia manualmente"
echo ""
echo "DESPUES DE REINICIAR, verifica en Terminal:"
echo "  getprop ro.enable.native.bridge.exec"
echo "  (Debe mostrar: 1)"
echo ""
echo "El ZIP también está guardado en:"
echo "  $WORKDIR/$FINAL_ZIP"
echo ""
echo "Puedes compartir este ZIP con otros para:"
echo "  - Instalar en otra PC con Bliss OS"
echo "  - Backup por si falla"
echo ""
