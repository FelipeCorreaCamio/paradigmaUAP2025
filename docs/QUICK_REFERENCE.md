# 🚀 Guía Rápida: Múltiples Pull Requests

## 📋 Comandos Esenciales

### Crear Nuevo PR (Estrategia Secuencial)
```bash
git checkout main
git pull origin main
git checkout -b feature/nueva-funcionalidad
# Hacer cambios...
git add .
git commit -m "Descripción clara de cambios"
git push origin feature/nueva-funcionalidad
# Crear PR en GitHub
```

### Crear Múltiples PRs (Estrategia Paralela)
```bash
# PR 1
git checkout main
git checkout -b ejercicio1/tarea1
# Cambios para tarea 1...
git add . && git commit -m "Tarea 1" && git push origin ejercicio1/tarea1

# PR 2
git checkout main
git checkout -b ejercicio1/tarea2
# Cambios para tarea 2...
git add . && git commit -m "Tarea 2" && git push origin ejercicio1/tarea2
```

### Actualizar Rama con Cambios de Main
```bash
git checkout main
git pull origin main
git checkout mi-rama
git rebase main
git push --force-with-lease origin mi-rama
```

### Limpiar Después de PR Fusionado
```bash
git checkout main
git pull origin main
git branch -d rama-fusionada
git push origin --delete rama-fusionada
```

## 🎯 Nomenclatura de Ramas

| Tipo | Formato | Ejemplo |
|------|---------|---------|
| Nueva funcionalidad | `feature/descripcion` | `feature/sistema-reservas` |
| Ejercicio específico | `ejercicio#/tarea#-nombre` | `ejercicio1/tarea1-reservas` |
| Corrección de bug | `bugfix/descripcion` | `bugfix/calculo-multas` |
| Documentación | `docs/descripcion` | `docs/guia-pull-requests` |
| Refactoring | `refactor/descripcion` | `refactor/aplicar-solid` |

## 📝 Template de Commit

```bash
git commit -m "Tipo: Descripción breve

- Detalle específico 1
- Detalle específico 2
- Detalle específico 3"
```

**Ejemplos:**
```bash
git commit -m "Implementar sistema de reservas

- Agregar clase Reserva con cola FIFO
- Modificar Biblioteca para gestionar reservas
- Agregar notificaciones automáticas"
```

## 🔄 Estrategias por Escenario

### ✅ Para Principiantes: SECUENCIAL
- Un PR a la vez
- Esperar aprobación antes del siguiente
- Menos conflictos

### ⚡ Para Intermedios: PARALELO
- Múltiples PRs simultáneos
- Funcionalidades independientes
- Más productivo

### 🔗 Para Avanzados: DEPENDIENTE
- Un PR depende de otro
- Crear rama desde rama (no desde main)
- Gestión compleja de rebases

## 🚨 Problemas Comunes

### "No puedo hacer push"
```bash
git pull origin mi-rama
git push origin mi-rama
```

### "Mi rama está desactualizada"
```bash
git checkout main
git pull origin main
git checkout mi-rama
git rebase main
git push --force-with-lease origin mi-rama
```

### "Tengo conflictos"
```bash
# Durante rebase
git rebase main
# Resolver conflictos en archivos
git add archivos-resueltos
git rebase --continue
```

### "Quiero empezar de nuevo"
```bash
git checkout main
git branch -D rama-antigua
git push origin --delete rama-antigua
git checkout -b nueva-rama
```

## ✅ Checklist Pre-PR

- [ ] `git rebase main` realizado
- [ ] Commits con mensajes descriptivos
- [ ] Solo cambios relevantes incluidos
- [ ] Código probado localmente
- [ ] Descripción de PR completa
- [ ] Tamaño manejable (<500 líneas)

## 📊 Comandos de Estado

```bash
git status                    # Estado actual
git branch -a                 # Todas las ramas
git log --oneline -10         # Últimos commits
git diff                      # Cambios no confirmados
git diff --cached             # Cambios en staging
git log --graph --oneline     # Historial visual
```

## 🎓 Para paradigmaUAP2025

### Ejercicio 1 - Biblioteca
```bash
git checkout main
git checkout -b ejercicio1/tarea1-reservas     # Sistema de reservas
git checkout main
git checkout -b ejercicio1/tarea2-multas       # Cálculo de multas
git checkout main
git checkout -b ejercicio1/tarea3-autores      # Gestión de autores
```

### Ejercicio 2 - Tipos y Políticas
```bash
git checkout main
git checkout -b ejercicio2/tipos-socios        # Jerarquía de socios
git checkout main
git checkout -b ejercicio2/politicas-prestamo  # Patrón Strategy
```

### Ejercicio 3 - Sistema RPG
```bash
git checkout main
git checkout -b ejercicio3/sistema-rpg         # Implementación completa
```

## 📚 Recursos Rápidos

- **Guía Completa**: `docs/GIT_MULTIPLE_PULL_REQUESTS.md`
- **Ejemplos Prácticos**: `docs/EJEMPLO_PRACTICO_EJERCICIOS.md`
- **Demo Script**: `./docs/demo_multiple_prs.sh`

## 🎯 Flujo Típico del Día

```bash
# 1. Empezar el día
git checkout main && git pull origin main

# 2. Ver estado de ramas
git branch -a

# 3. Trabajar en nueva funcionalidad
git checkout -b feature/nueva-tarea
# ... hacer cambios ...
git add . && git commit -m "Implementar nueva tarea"
git push origin feature/nueva-tarea

# 4. Crear PR en GitHub

# 5. Continuar con otra tarea
git checkout main
git checkout -b feature/otra-tarea
# ... repetir proceso ...
```

---

💡 **Tip**: Guarda este archivo como referencia y úsalo cuando necesites recordar comandos específicos.