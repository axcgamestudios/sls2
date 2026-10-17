# Super Liquid Soccer — Mejoras v2.0

Este update moderniza los gráficos, la física del balón y la interfaz del juego,
además de usar `pasto.jpeg` como textura realista del campo.

## 1. Textura de pasto realista

- Se generó una textura compuesta a partir de `pasto.jpeg` (1024×1024):
  mosaico espejado a 2048×1450, franjas de corte sutiles (como el campo original)
  y las líneas blancas del campo extraídas de la textura original.
- Formato `.stex` (GDST + WebP + 12 mipmaps) compatible con Godot 3.5.1.
- Reemplaza `.import/field2knew.png-46ca539b10c11454cb64d2df71915be9.stex`.
- La zona fuera del campo se oscurece levemente para dar profundidad.

## 2. Gráficos, luces y sombras

| Elemento | Antes | Ahora |
|---|---|---|
| Sombreado | `force_vertex_shading = true` | Desactivado (iluminación por píxel) |
| Atlas de sombras | 1024 px (viewport) | 4096 px, 4 cuadrantes |
| Direccional (partido) | bias 1.0, splits sin blending | bias 0.35, normal bias 0.8, blend de splits |
| Sombras por defecto | OFF | ON (con migración de config para usuarios existentes) |
| Tonemap / ambiente | exposure 0.75 | 0.95 + ajustes (brillo 1.04, contraste 1.07, saturación 1.12) |
| Glow | bloom 1.0 | bloom 0.7, fuerza 0.6 |
| Material del campo | vertex lighting, sin sombreado | Lambert por píxel, roughness 1.0 |
| Entorno del campo | marrón | verde césped |

## 3. Física realista del balón

- **Rebote**: 0.15 → 0.55 (un balón real rebota ~0.6 en césped).
- **Fricción**: 0.5 → 0.7.
- **Amortiguación lineal**: 0.2 → 0.08; **angular**: 2.2 → 0.8.
- **Resistencia aerodinámica cuadrática** (`F = -k·|v|·v`) en `_physics_process`.
- **Fricción de rodadura** cuando el balón rueda por el suelo.
- **Decay del efecto (curl/Magnus) independiente del framerate**
  (`pow(0.994, delta·60)` en vez de `*= 0.995` por frame).

## 4. Interfaz

- **Tema global (UI.tres)**: botones dorados con relleno, estados hover/pressed
  con sombras, foco brillante, selección dorada en listas.
- **HUD**: panel translúcido redondeado con borde dorado detrás del marcador;
  tipografía del marcador con contorno para legibilidad.
- **Menú**: fondo con degradado, versión 2.0.0.
- **Pantalla de carga (index.html)**: título "Super Liquid Soccer", barra de
  progreso dorada redondeada, fondo verde con degradado radial, spinner dorado.
- Título de la pestaña: `blueskywrld` → `Super Liquid Soccer`.

## 5. Estructura del repo

- `index.pck` — paquete del juego re-generado (scripts recompilados).
- `sources/` — **scripts GDScript descompilados y legibles** (espejo de `res://`),
  con las modificaciones aplicadas. Útiles para editar el juego en el editor
  de Godot 3.5.1 y volver a exportar.
- `pasto.jpeg` — textura original de pasto (fuente de la nueva textura).

## Herramientas usadas (pipeline de modificación)

1. Extracción del PCK (formato v1 de Godot 3.5.1).
2. Decompilación del bytecode `.gdc` (v13: tokens de longitud variable,
   identificadores XOR 0xB6 — formato stock del motor) → GDScript.
3. Edición de scripts/escenas/materiales.
4. Recompilación con Godot 3.5.1 headless (`--export-pack`).
5. Re-empaquetado del PCK (TOC + MD5 verificados).
