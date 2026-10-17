# Super Liquid Soccer — Mejoras v2.2

> **v2.2 — FIX CRÍTICO DE PASES + GRÁFICOS REALES**: pases que se quedaban
> sueltos arreglados de raíz, escala del pasto corregida, sombreado por píxel
> y sombras 4096 activadas de verdad (antes `ProjectSettings` en runtime no
> tenía efecto — ahora el `project.binary` del PCK va parcheado).

## v2.2 — Qué se arregló y mejoró

### 1. FIX del sistema de pases (el bug "le pico y suelto la pelota")
- **Causa raíz**: si pulsabas pase **sin dirección de aim**, `_findPass`
  no encontraba candidato (score 0 > 0 nunca) y el balón se pasaba con
  `velocity` (~0) → la pelota quedaba suelta. El chip hacía un despeje
  plano hacia puerta.
- **Arreglado**:
  - `_getAimDir()` (Player.gd): aim unificado teclado+joystick+touch; sin
    input usa el **frente del jugador** → el pase SIEMPRE tiene dirección.
  - `_findPass` (Team.gd) reescrito: **siempre devuelve el mejor compañero**
    (alineación + progresión al ataque + penalización por marcado +
    preferencia de distancia media). El balón ya no se suelta nunca.
  - `_passBall` (SmartBall.gd): pase de seguridad raso controlado al frente.
  - **Cambio de control inmediato al receptor** (estilo FC): al pasar,
    controlas directo al que recibe.
  - `chipPass`: cono relajado (0.55→0.3), arco balístico realista (la
    distancia manda la potencia) y fallback de globo al espacio apuntado
    (antes: patada plana a puerta).
  - `thruPass`: si no hay receptor obvio, filtrado al espacio apuntado
    (antes no pasaba nada).

### 2. Textura del pasto — escala corregida
- El tile de pasto2 cubría **medio campo** (1024px) → pasto gigante.
- Ahora: base de `pasto.jpeg` espejada a 512px (rejilla sutil) + **300
  parches suaves** de `pasto2` con feathering + ruido multi-octava +
  suavizado TV (detalle de briznas a escala de cámara) + 16 franjas de
  corte sutiles + líneas blancas originales nítidas + desgaste en áreas.

### 3. Gráficos — de verdad esta vez
- `project.binary` parcheado IN-PLACE en el PCK: `force_vertex_shading` OFF
  (**iluminación por píxel**), Burley/Blinn-GGX, sombras direccionales
  **2048→4096**, atlas de sombras **256→2048**.
- Luz del estadio: bias 0.35→0.08 (sombras pegadas), normal_bias 1.5,
  **specular 0.3** (brillos en balón/jugadores), color cálido neutro.
- Entornos: **tonemap filmic**, glow sutil (bloom umbral 0.92), contraste
  1.09 / saturación 1.14.

### 4. Controles (teclado)
`WASD` mover · `M` pase · `L` chip/globo · `I` filtrado · `J` tiro (cargar) ·
`O` tenso/raso · `Q` sprint · `E` raso · `P`/`U` cambiar jugador

---

# Historial v2.1 (estilo FC)

Este update añade la textura `pasto2.png` del usuario, mecánicas de juego estilo
FC (regates, tiros finura, tiros picados, pases inteligentes), rediseño del radar,
mejoras en los modelos de jugadores y corrección de varios bugs.

## 1. Textura de pasto (pasto2.png)

- Mosaico 2048×1450 construido desde `pasto2.png` con **tiles rotados/espejados
  aleatoriamente** y micro-variación de brillo por tile (rompe la repetición).
- Franjas de corte + líneas blancas extraídas de la textura original.
- Upscale con máscara de nitidez y saturación +10%.
- Formato `.stex` (GDST + WebP + 12 mipmaps) compatible con Godot 3.5.1.

## 2. Mecánicas estilo FC

| Mecánica | Control (teclado) | Efecto |
|---|---|---|
| **Elastico / stepover** | Doble toque rápido de `P` (sprint) con dirección | Toca el balón en diagonal + explosión de velocidad, animación scissor |
| **La croqueta** | `O` (R2) + dirección lateral | Desvío lateral rápido del balón con paso lateral |
| **Tiro fingido (fake shot)** | `J` cargando y luego `M` | Cancela el tiro, amago + aceleración |
| **Tiro picado (chip)** | `L` cerca del área orientado a puerta | Balón por elevación sobre el portero (arco balístico calculado) |
| **Tiro de finura** | `O` (raso) + aim lateral al soltar `J` | +55% de efecto lateral, −14% potencia (colocado) |
| **Pase tenso** | Mantener `O` al pasar con `M` | Pase raso y más rápido |

La **IA también regatea**: cuando un rival presiona a un jugador con agilidad alta,
hace elasticones para escapar (probabilidad según `pAgility`).

## 3. Sistema de pases / centros / tiros

- **Potencia de pase adaptativa a la distancia** (el balón llega en ~0.6 s en
  lugar de velocidad fija): `minPassSpeed` 65→30, `maxPassSpeed` 100→105.
- **Anticipación del receptor** mejorada (0.3 s de lead) y pases filtrados que
  adelantan la carrera del receptor 6 m al espacio.
- **Error angular de pase** proporcional a la distancia (pases largos menos
  precisos, como en la vida real).
- **Centros inteligentes**: se elige el mejor atacante en el área (cerca de
  portería, desmarcado, con mejor `pShoot`) y se adelanta su carrera 0.55 s,
  en vez de un punto aleatorio.
- Barra de potencia de tiro estable a cualquier framerate (`delta`-escalada).

## 4. UI

- **Radar estilo FC**: puntos de equipo más grandes y visibles, balón blanco
  destacado, **anillo dorado que marca al jugador controlado**, fondo oscuro
  semitransparente y opacidad subida (0.59→0.95).
- **Posesión en vivo**: estadística acumulada por equipo, mostrada como
  "Posesión 58% - 42%" en el descanso.
- **Panel de controles de pausa ampliado**: 13 filas con las nuevas mecánicas
  (switch `U`, tiro raso/finura `O`, regate `2xP`, tiro picado `L`), traducido
  a los 7 idiomas.
- Nombres de jugador controlado más legibles (más brillo, reposicionados).
- Versión visible: 2.1.0.

## 5. Modelos de jugadores

- Shader del jugador (embebido en `newPlayer.tres`): **rim light** de estadio,
  `SPECULAR` 0→0.35 (brillo atlético/piel sudada) y `ROUGHNESS` suavizado.

## 6. Bugs corregidos

- **Teclado sin `p1_low` ni `p1_switch`**: ahora `O` (R2) y `U`.
- **NaN en `_passBall`**: pasar sin dirección ya no lanza el balón al infinito
  (pase de seguridad hacia delante).
- **Leak del minimapa**: los puntos se duplicaban en cada partido (14, 28, 42…);
  ahora se liberan y limpian.
- **Color del minimapa off-by-one**: el dorsal 6 del equipo 1 se pintaba con el
  color rival.
- **ColorRect del radar tapaba el punto del balón** (z_index corregido).
- Carga de `shotcharge` dependiente del framerate.

## 7. Estructura del repo

- `index.pck` — paquete regenerado (scripts recompilados + recursos nuevos).
- `sources/` — scripts GDScript legibles con los cambios (espejo de `res://`).
- `pasto.jpeg`, `pasto2.png` — texturas de pasto (fuente).
- Herramientas del pipeline en el historial de commits previos (extractor,
  decompilador, empaquetador, verificador, generadores de textura).

## Pipeline (idéntico a v2.0)

1. Edición de scripts/recursos en el proyecto export.
2. Validación de sintaxis con Godot 3.5.1 headless (`--check-only`).
3. Compilación `--export-pack` → `.gdc`.
4. Re-empaquetado del PCK v1 (TOC + MD5 verificados).
5. Prueba end-to-end en navegador headless (sin errores de consola).
