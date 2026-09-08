# VERIFICAR INSTALACIÓN - COMANDOS

## DESPUÉS DE INSTALAR EL MÓDULO MAGISK EN BLISS OS

Abre Terminal en Bliss OS y ejecuta estos comandos:

### 1. Verificar Native Bridge habilitado (32-bit)

```bash
getprop ro.enable.native.bridge.exec
```

**RESULTADO ESPERADO:** `1`

**SI MUESTRA 0 O VACÍO:** Módulo no se instaló correctamente

---

### 2. Verificar Native Bridge habilitado (64-bit)

```bash
getprop ro.enable.native.bridge.exec64
```

**RESULTADO ESPERADO:** `1`

**SI MUESTRA 0 O VACÍO:** Módulo no se instaló correctamente

---

### 3. Verificar módulo Magisk activo

```bash
magisk module list
```

**RESULTADO ESPERADO:** Lista que incluya `houdini_android14_x86`

**EJEMPLO:**
```
houdini_android14_x86
```

**SI NO APARECE:** Módulo no se instaló

---

### 4. Verificar Houdini 32-bit instalado

```bash
ls -lh /system/lib/arm/libhoudini.so
```

**RESULTADO ESPERADO:** Muestra archivo con tamaño (ej: 5.2M)

**EJEMPLO:**
```
-rw-r--r-- 1 root root 5.2M ... /system/lib/arm/libhoudini.so
```

**SI MUESTRA "No such file or directory":** Houdini no se copió

---

### 5. Verificar Houdini 64-bit instalado

```bash
ls -lh /system/lib64/arm64/libhoudini.so
```

**RESULTADO ESPERADO:** Muestra archivo con tamaño (ej: 8.3M)

**EJEMPLO:**
```
-rw-r--r-- 1 root root 8.3M ... /system/lib64/arm64/libhoudini.so
```

**SI MUESTRA "No such file or directory":** Houdini no se copió

---

### 6. Verificar propiedades de ISA (Instruction Set Architecture)

```bash
getprop ro.dalvik.vm.isa.arm
```

**RESULTADO ESPERADO:** `x86`

---

### 7. Verificar propiedades de ISA 64-bit

```bash
getprop ro.dalvik.vm.isa.arm64
```

**RESULTADO ESPERADO:** `x86_64`

---

### 8. Verificar Native Bridge configurado

```bash
getprop ro.dalvik.vm.native.bridge
```

**RESULTADO ESPERADO:** `libhoudini.so`

---

## SCRIPT DE VERIFICACIÓN COMPLETA (TODO EN UNO)

Copia y ejecuta esto en Terminal de Bliss OS:

```bash
echo "═════════════════════════════════════════════════════════"
echo "  VERIFICACIÓN HOUDINI v145 - Android 14 x86_64"
echo "═════════════════════════════════════════════════════════"
echo ""

echo "1. Native Bridge 32-bit:"
getprop ro.enable.native.bridge.exec
echo ""

echo "2. Native Bridge 64-bit:"
getprop ro.enable.native.bridge.exec64
echo ""

echo "3. ISA ARM 32-bit:"
getprop ro.dalvik.vm.isa.arm
echo ""

echo "4. ISA ARM 64-bit:"
getprop ro.dalvik.vm.isa.arm64
echo ""

echo "5. Native Bridge configurado:"
getprop ro.dalvik.vm.native.bridge
echo ""

echo "6. Módulo Magisk:"
magisk module list || echo "Magisk no encontrado"
echo ""

echo "7. Houdini 32-bit:"
ls -lh /system/lib/arm/libhoudini.so 2>&1 | awk '{print $5}' || echo "No existe"
echo ""

echo "8. Houdini 64-bit:"
ls -lh /system/lib64/arm64/libhoudini.so 2>&1 | awk '{print $5}' || echo "No existe"
echo ""

echo "═════════════════════════════════════════════════════════"
echo "  RESULTADO:"
echo "═════════════════════════════════════════════════════════"

# Verificación automática
RESULT_32=$(getprop ro.enable.native.bridge.exec)
RESULT_64=$(getprop ro.enable.native.bridge.exec64)

if [ "$RESULT_32" = "1" ] && [ "$RESULT_64" = "1" ]; then
    echo "✓ HOUDINI INSTALADO CORRECTAMENTE"
    echo "✓ Netflix, TikTok, Edge deberían funcionar"
else
    echo "✗ ERROR EN INSTALACIÓN"
    echo "✗ ro.enable.native.bridge.exec = $RESULT_32"
    echo "✗ ro.enable.native.bridge.exec64 = $RESULT_64"
fi
echo ""
```

---

## SI ALGO FALLA

### Error: Todos los valores están 0 o vacíos

**Causa:** Módulo no se instaló

**Solución:**
1. Abre Magisk Manager
2. Ve a Modules
3. Intenta reinstalar el ZIP
4. Reinicia después de instalar

### Error: Houdini no existe en /system

**Causa:** ZIP no se extrajo correctamente en Magisk

**Solución:**
1. Deshabilita el módulo en Magisk
2. Reinicia
3. Intenta instalar de nuevo
4. Asegúrate que ZIP tiene 60+ MB

### Error: WiFi no funciona

**Causa:** Módulo causó conflicto con red

**Solución:**
1. Magisk Manager > Modules
2. Presiona 3 segundos en "houdini_android14_x86"
3. Selecciona "Disable"
4. Reinicia
5. WiFi debería funcionar de nuevo

---

## ✓ SI TODO ESTÁ BIEN

Todos los valores son correctos:
- ✓ Native Bridge = 1 (ambos)
- ✓ ISA = x86 y x86_64
- ✓ Módulo aparece en lista
- ✓ Houdini existe en ambas ubicaciones

**AHORA PRUEBA:**
1. Abre Netflix
2. Abre TikTok
3. Abre Microsoft Edge

**Si cargan sin congelar = ✓ ÉXITO TOTAL**

---

**¡FELICIDADES! 🎉**
