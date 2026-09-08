# INSTRUCCIONES PASO A PASO PARA LINUX MINT
# (Manual - Si no quieres usar script automático)

## REQUISITOS

```bash
sudo apt update
sudo apt install git wget unzip android-tools-adb -y
```

## PASO 1: Crear carpeta de trabajo

```bash
mkdir -p ~/houdini_v145_build
cd ~/houdini_v145_build
echo "✓ Carpeta creada"
```

## PASO 2: Descargar Houdini v145 (para Android 14)

```bash
echo "Descargando Houdini v145 (ChromeOS Brya)..."
echo "(Esto tarda 2-3 minutos)..."

wget https://github.com/Rprop/libhoudini/releases/download/v145_brya/houdini.tar.gz -O houdini_v145.tar.gz

echo "✓ Descargado"
ls -lh houdini_v145.tar.gz
```

## PASO 3: Extraer archivo

```bash
echo "Extrayendo..."
tar -xzf houdini_v145.tar.gz
echo "✓ Extraído"
```

## PASO 4: Verificar archivos críticos

```bash
echo "Verificando Houdini 32-bit..."
ls -lh system/lib/arm/libhoudini.so
echo "✓ Existe"

echo "Verificando Houdini 64-bit..."
ls -lh system/lib64/arm64/libhoudini.so
echo "✓ Existe"
```

**IMPORTANTE:** Ambos archivos DEBEN existir. Si falta alguno, descargaste mal.

## PASO 5: Descargar módulo Magisk base

```bash
echo "Descargando módulo Magisk base..."
git clone https://github.com/mauriciogsv/Houdini-Magisk-Android14-x86.git magisk_houdini_module

echo "✓ Descargado"
ls magisk_houdini_module/module.prop
```

## PASO 6: Copiar Houdini v145 al módulo

```bash
echo "Preparando módulo..."
rm -rf magisk_houdini_module/system
cp -r system magisk_houdini_module/

echo "✓ Copiado"
ls -la magisk_houdini_module/system/lib/arm/libhoudini.so
ls -la magisk_houdini_module/system/lib64/arm64/libhoudini.so
```

## PASO 7: Crear ZIP del módulo

**IMPORTANTE: Estructura DIRECTA (sin carpeta dentro)**

```bash
echo "Creando ZIP..."
cd magisk_houdini_module

zip -r -q ../houdini_v145_FINAL.zip \
  module.prop \
  system.prop \
  service.sh \
  customize.sh \
  install.sh \
  system/

cd ..

echo "✓ ZIP creado"
```

## PASO 8: Verificar ZIP

```bash
echo "Verificando tamaño..."
ls -lh houdini_v145_FINAL.zip
# Debe ser 60-80 MB

echo "Verificando estructura..."
unzip -l houdini_v145_FINAL.zip | head -20
# IMPORTANTE: Debe mostrar archivos DIRECTAMENTE
# Si muestra "Houdini-Magisk-Android14-x86/" o similar carpeta = ERROR
```

## PASO 9: Conectar Bliss OS por ADB

```bash
echo "Conectando a Bliss OS..."
adb devices
# Debe mostrar: <device_id>  device

# Si no aparece:
# 1. Conecta Bliss OS via USB
# 2. En Bliss OS: Settings > Developer Options > USB Debugging ON
# 3. Intenta de nuevo: adb devices
```

## PASO 10: Transferir ZIP a Bliss OS

```bash
echo "Habilitando acceso root..."
adb root
sleep 1

echo "Enviando ZIP a Bliss OS..."
adb push houdini_v145_FINAL.zip /sdcard/Download/

echo "✓ Transferido"
echo "Verificando en Bliss OS..."
adb shell ls -lh /sdcard/Download/houdini_v145_FINAL.zip
```

## PASO 11: Instalar en Magisk (EN BLISS OS)

1. Abre **Magisk Manager** (icono M)
2. Presiona **"+"** (Install from Storage)
3. Navega a: **/sdcard/Download/houdini_v145_FINAL.zip**
4. Selecciona y presiona **INSTALL**
5. Espera a que termine (verás SUCCESS)
6. Presiona **RESTART** o reinicia manualmente

## PASO 12: Verificar instalación (EN BLISS OS)

Abre Terminal en Bliss OS y ejecuta:

```bash
# 1. Verificar Native Bridge 32-bit
getprop ro.enable.native.bridge.exec
# Debe mostrar: 1

# 2. Verificar Native Bridge 64-bit
getprop ro.enable.native.bridge.exec64
# Debe mostrar: 1

# 3. Verificar módulo activo
magisk module list
# Debe listar: houdini_android14_x86

# 4. Verificar Houdini 32-bit
ls -lh /system/lib/arm/libhoudini.so
# Debe existir

# 5. Verificar Houdini 64-bit
ls -lh /system/lib64/arm64/libhoudini.so
# Debe existir
```

**Si TODO muestra valores correctos = ✓ ÉXITO**

## PASO 13: Probar apps

1. Abre **Play Store**
2. Descarga e instala: **Netflix**, **TikTok**, **Microsoft Edge**
3. Abre cada una
4. **Si no congelan = ✓ FUNCIONA PERFECTO**

---

## TROUBLESHOOTING

### ZIP no se crea (vacío)

```bash
# Verifica que carpeta system existe
ls -la magisk_houdini_module/system/

# Si no existe, repite paso 6
```

### Bliss OS no se conecta por ADB

```bash
# En Bliss OS:
# Settings > Developer Options > USB Debugging ON

# En Linux:
adb kill-server
adb start-server
adb devices
```

### WiFi no funciona después de instalar

1. Abre **Magisk Manager** en Bliss OS
2. Ve a **Modules**
3. **Presiona 3 segundos** en "houdini_android14_x86"
4. Selecciona **Disable**
5. **REINICIA**

El módulo se desactiva pero sigue instalado. Sistema vuelve a normal.

### Netflix/TikTok siguen congelando

1. Verifica que instaló correctamente:
   ```bash
   ls -lh /system/lib/arm/libhoudini.so
   ls -lh /system/lib64/arm64/libhoudini.so
   ```

2. Si no existen: repite instalación de Magisk

3. Si existen pero sigue congelando: descarga versiones antiguas de apps desde APKMirror

---

## CHECKLIST FINAL

- [ ] Houdini v145 descargado (60+ MB)
- [ ] Archivos libhoudini.so extraídos (2 ubicaciones)
- [ ] Módulo Magisk descargado
- [ ] Houdini copiado al módulo
- [ ] ZIP creado (60-80 MB)
- [ ] ZIP tiene estructura CORRECTA (sin carpeta dentro)
- [ ] Bliss OS conectado por ADB
- [ ] ZIP transferido a /sdcard/Download/
- [ ] Magisk instaló correctamente
- [ ] Dispositivo reinició
- [ ] Verificación muestra valores correctos
- [ ] Netflix/TikTok/Edge funcionan sin congelar

---

**¡LISTO! Si TODO está bien = ✓ ÉXITO** 🚀
