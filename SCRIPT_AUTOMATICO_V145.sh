#!/bin/bash

# ===============================================================================
# HOUDINI v145 ANDROID 14 x86_64 - SCRIPT AUTOMÁTICO
# Para Linux Mint - Inyecta Houdini en Bliss OS via ADB
# ===============================================================================

set -e

echo ""
echo "═══════════════════════════════════════════════════════════════════════════════"
echo "  HOUDINI v145 PARA ANDROID 14 x86_64 - INYECTOR AUTOMÁTICO"
echo "  Linux Mint → Bliss OS"
echo "═══════════════════════════════════════════════════════════════════════════════"
echo ""

# Variables
WORKDIR="$HOME/houdini_v145_build"
MODULE_DIR="magisk_houdini_module"
FINAL_ZIP="houdini_v145_android14_FINAL.zip"

echo "[1/10] Crear directorio de trabajo..."
mkdir -p "$WORKDIR"
cd "$WORKDIR"
echo "✓ Directorio: $WORKDIR"
echo ""

echo "[2/10] Descargar Houdini v145 (ChromeOS Brya - Android 14)..."
echo "    Esto tarda 2-3 minutos..."
wget -q --show-progress https://github.com/Rprop/libhoudini/releases/download/v145_brya/houdini.tar.gz -O houdini_v145.tar.gz 2>&1 || wget -q https://github.com/Rprop/libhoudini/releases/download/v145_brya/houdini.tar.gz -O houdini_v145.tar.gz
echo "✓ Descargado"
echo ""

echo "[3/10] Extraer Houdini v145..."
tar -xzf houdini_v145.tar.gz
echo "✓ Extraído"
echo ""

echo "[4/10] Verificar archivos críticos..."
if [ ! -f "system/lib/arm/libhoudini.so" ]; then
    echo "✗ ERROR: No encontré system/lib/arm/libhoudini.so"
    exit 1
fi
if [ ! -f "system/lib64/arm64/libhoudini.so" ]; then
    echo "✗ ERROR: No encontré system/lib64/arm64/libhoudini.so"
    exit 1
fi
echo "✓ Houdini 32-bit: $(ls -lh system/lib/arm/libhoudini.so | awk '{print $5}')"
echo "✓ Houdini 64-bit: $(ls -lh system/lib64/arm64/libhoudini.so | awk '{print $5}')"
echo ""

echo "[5/10] Descargar módulo Magisk base desde GitHub..."
if [ ! -d "$MODULE_DIR" ]; then
    git clone -q https://github.com/mauriciogsv/Houdini-Magisk-Android14-x86.git "$MODULE_DIR" 2>/dev/null || {
        echo "⚠️  No pude clonar por git, descargando ZIP..."
        wget -q https://github.com/mauriciogsv/Houdini-Magisk-Android14-x86/archive/refs/heads/main.zip -O module.zip
        unzip -q module.zip
        mv Houdini-Magisk-Android14-x86-main "$MODULE_DIR"
    }
fi
echo "✓ Módulo descargado"
echo ""

echo "[6/10] Copiar Houdini v145 al módulo Magisk..."
rm -rf "$MODULE_DIR/system"
cp -r system "$MODULE_DIR/"
echo "✓ Copiado"
echo ""

echo "[7/10] Verificar estructura del módulo..."
if [ ! -f "$MODULE_DIR/module.prop" ]; then echo "✗ ERROR: Falta module.prop"; exit 1; fi
if [ ! -f "$MODULE_DIR/system.prop" ]; then echo "✗ ERROR: Falta system.prop"; exit 1; fi
if [ ! -f "$MODULE_DIR/service.sh" ]; then echo "✗ ERROR: Falta service.sh"; exit 1; fi
if [ ! -f "$MODULE_DIR/customize.sh" ]; then echo "✗ ERROR: Falta customize.sh"; exit 1; fi
if [ ! -f "$MODULE_DIR/install.sh" ]; then echo "✗ ERROR: Falta install.sh"; exit 1; fi
if [ ! -f "$MODULE_DIR/system/lib/arm/libhoudini.so" ]; then echo "✗ ERROR: Falta Houdini 32-bit"; exit 1; fi
if [ ! -f "$MODULE_DIR/system/lib64/arm64/libhoudini.so" ]; then echo "✗ ERROR: Falta Houdini 64-bit"; exit 1; fi
echo "✓ Estructura correcta"
echo ""

echo "[8/10] Crear ZIP del módulo (estructura DIRECTA)..."
cd "$MODULE_DIR"
rm -f "../$FINAL_ZIP"
zip -r -q "../$FINAL_ZIP" module.prop system.prop service.sh customize.sh install.sh system/
cd ..
echo "✓ ZIP creado"
echo ""

echo "[9/10] Verificar ZIP..."
ZIP_SIZE=$(ls -lh "$FINAL_ZIP" | awk '{print $5}')
echo "Tamaño: $ZIP_SIZE"
echo "Estructura (primeras líneas):"
unzip -l "$FINAL_ZIP" | head -12
echo ""

echo "[10/10] Transferir ZIP a Bliss OS via ADB..."
if ! command -v adb &> /dev/null; then
    echo "⚠️  ADB no está instalado"
    echo "Instala: sudo apt install android-tools-adb -y"
    echo ""
    echo "ZIP está listo en: $WORKDIR/$FINAL_ZIP"
    exit 0
fi

adb wait-for-device > /dev/null 2>&1 || true

if ! adb devices | grep -q "device$"; then
    echo "⚠️  No se detectó dispositivo ADB"
    echo "   Conecta Bliss OS via USB o VirtualBox"
    echo "   Habilita depuración USB en Bliss OS"
    echo ""
    echo "ZIP está listo en: $WORKDIR/$FINAL_ZIP"
    echo ""
    echo "Transfiere manualmente:"
    echo "  1. Copia el ZIP a USB"
    echo "  2. Pega en /sdcard/Download/ en Bliss OS"
    exit 0
fi

adb root > /dev/null 2>&1 || true
sleep 1

echo "Enviando a Bliss OS..."
adb push "$FINAL_ZIP" /sdcard/Download/ > /dev/null 2>&1
echo "✓ Transferido a Bliss OS"
echo ""

echo "Verificando en Bliss OS..."
adb shell ls -lh "/sdcard/Download/$FINAL_ZIP"
echo ""

echo "═══════════════════════════════════════════════════════════════════════════════"
echo "  ✓ ÉXITO - TODO LISTO EN BLISS OS"
echo "═══════════════════════════════════════════════════════════════════════════════"
echo ""
echo "ARCHIVO CREADO: $FINAL_ZIP"
echo "UBICACIÓN: $WORKDIR/"
echo "DESTINO EN BLISS OS: /sdcard/Download/"
echo ""
echo "PRÓXIMOS PASOS EN BLISS OS:"
echo ""
echo "1. Abre Magisk Manager (icono M)"
echo "2. Presiona botón '+' (Install from Storage)"
echo "3. Navega a: /sdcard/Download/$FINAL_ZIP"
echo "4. Selecciona y presiona INSTALL"
echo "5. Espera a que termine (verás SUCCESS en log)"
echo "6. Presiona RESTART o reinicia manualmente"
echo ""
echo "DESPUÉS DE REINICIAR, verifica en Terminal de Bliss OS:"
echo ""
echo "  getprop ro.enable.native.bridge.exec"
echo "  (Debe mostrar: 1)"
echo ""
echo "  getprop ro.enable.native.bridge.exec64"
echo "  (Debe mostrar: 1)"
echo ""
echo "  magisk module list"
echo "  (Debe mostrar: houdini_android14_x86)"
echo ""
echo "  ls -lh /system/lib/arm/libhoudini.so"
echo "  (Debe existir)"
echo ""
echo "Si TODO está correcto:"
echo "  ✓ Netflix funciona"
echo "  ✓ TikTok funciona"
echo "  ✓ Edge funciona"
echo ""
