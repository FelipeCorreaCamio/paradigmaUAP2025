# Guía: Cómo Hacer Múltiples Pull Requests

## Introducción

Una pregunta muy común al trabajar con Git y GitHub es: **"¿Cómo hago otro pull request cuando ya hice un pull request antes?"**

Esta guía explica las diferentes estrategias para manejar múltiples pull requests de manera efectiva, con ejemplos prácticos para el repositorio `paradigmaUAP2025`.

---

## Conceptos Fundamentales

### ¿Qué es un Pull Request?

Un Pull Request (PR) es una solicitud para fusionar cambios de una rama de desarrollo hacia otra rama (generalmente `main` o `master`). Cada PR representa un conjunto de cambios relacionados que forman una unidad lógica de trabajo.

### Principios Clave

1. **Un PR = Una funcionalidad/tarea específica**
2. **Cada PR debe ser independiente cuando sea posible**
3. **Las ramas deben tener nombres descriptivos**
4. **Los commits deben ser claros y específicos**

---

## Estrategias para Múltiples Pull Requests

### Estrategia 1: Pull Requests Secuenciales (Recomendado para principiantes)

Esta estrategia crea pull requests uno después del otro, esperando que el anterior sea aprobado y fusionado antes de crear el siguiente.

#### Flujo de Trabajo:

```bash
# 1. Asegurarse de estar en la rama main actualizada
git checkout main
git pull origin main

# 2. Crear una nueva rama para el primer PR
git checkout -b feature/ejercicio1-reservas
# Hacer cambios para el ejercicio 1
git add .
git commit -m "Implementar sistema de reservas para biblioteca"
git push origin feature/ejercicio1-reservas
# Crear PR en GitHub

# 3. Una vez que el PR anterior sea aprobado y fusionado:
git checkout main
git pull origin main  # Obtener los cambios fusionados

# 4. Crear una nueva rama para el segundo PR
git checkout -b feature/ejercicio1-multas
# Hacer cambios para las multas
git add .
git commit -m "Agregar cálculo de multas por libros vencidos"
git push origin feature/ejercicio1-multas
# Crear segundo PR en GitHub
```

#### Ventajas:
- ✅ Simple y fácil de entender
- ✅ Evita conflictos complejos
- ✅ Cada PR se basa en código ya aprobado

#### Desventajas:
- ❌ Más lento si necesitas trabajar en paralelo
- ❌ Dependes de la aprobación del PR anterior

### Estrategia 2: Pull Requests Paralelos (Para desarrolladores intermedios)

Esta estrategia permite trabajar en múltiples funcionalidades simultáneamente, creando varios PRs al mismo tiempo.

#### Flujo de Trabajo:

```bash
# 1. Asegurarse de estar en main actualizada
git checkout main
git pull origin main

# 2. Crear primera rama
git checkout -b feature/sistema-reservas
# Trabajar en reservas...
git add .
git commit -m "Implementar sistema de reservas"
git push origin feature/sistema-reservas

# 3. Volver a main y crear segunda rama
git checkout main
git checkout -b feature/politicas-prestamo
# Trabajar en políticas...
git add .
git commit -m "Implementar políticas flexibles de préstamo"
git push origin feature/politicas-prestamo

# 4. Crear una tercera rama independiente
git checkout main
git checkout -b feature/tipos-socio
# Trabajar en tipos de socio...
git add .
git commit -m "Agregar SocioVIP y SocioRegular"
git push origin feature/tipos-socio
```

#### Ventajas:
- ✅ Permite trabajo en paralelo
- ✅ Más productivo
- ✅ Funcionalidades independientes pueden desarrollarse sin esperas

#### Desventajas:
- ❌ Puede generar conflictos si las ramas tocan los mismos archivos
- ❌ Requiere más coordinación
- ❌ Más complejo de manejar

### Estrategia 3: Pull Requests Dependientes (Para desarrolladores avanzados)

Cuando una funcionalidad depende de otra que aún no ha sido fusionada.

#### Flujo de Trabajo:

```bash
# 1. Crear primera rama (base)
git checkout main
git checkout -b feature/base-autor
# Implementar clase Autor
git add .
git commit -m "Agregar clase Autor básica"
git push origin feature/base-autor
# Crear PR para esta rama

# 2. Crear segunda rama basada en la primera
git checkout feature/base-autor  # ¡Importante! No desde main
git checkout -b feature/gestion-autores
# Implementar gestión completa de autores
git add .
git commit -m "Implementar gestión completa de autores"
git push origin feature/gestion-autores
# Crear PR hacia feature/base-autor (no hacia main)

# 3. Una vez que el primer PR sea fusionado:
git checkout main
git pull origin main
git checkout feature/gestion-autores
git rebase main  # Actualizar la rama
git push --force-with-lease origin feature/gestion-autores
# Cambiar el target del PR hacia main en GitHub
```

---

## Ejemplos Prácticos para paradigmaUAP2025

### Ejemplo 1: Implementar todas las tareas del Ejercicio 1

```bash
# Tarea 1: Sistema de Reservas
git checkout main
git pull origin main
git checkout -b ejercicio1/tarea1-reservas

# Editar archivos para implementar reservas
# objetos/ejercicios/ejercicio1/clases/Biblioteca.ts
# objetos/ejercicios/ejercicio1/clases/Reserva.ts

git add .
git commit -m "Implementar sistema de reservas para libros prestados

- Agregar clase Reserva para manejar cola de reservas
- Modificar Biblioteca para gestionar reservas
- Agregar notificaciones cuando libro esté disponible"

git push origin ejercicio1/tarea1-reservas
# Crear PR en GitHub

# Tarea 2: Cálculo de Multas (en paralelo)
git checkout main
git checkout -b ejercicio1/tarea2-multas

# Implementar multas
git add .
git commit -m "Implementar cálculo de multas por libros vencidos

- Agregar clase Multa con cálculo de $50 por día
- Modificar Socio para rastrear multas pendientes
- Prevenir nuevos préstamos con multas pendientes"

git push origin ejercicio1/tarea2-multas
# Crear segundo PR en GitHub
```

### Ejemplo 2: Implementar Ejercicio 2 - Múltiples tipos de socios

```bash
# Crear rama base para jerarquía de socios
git checkout main
git checkout -b ejercicio2/tipos-socios-base

# Implementar clases base
git add .
git commit -m "Crear jerarquía de tipos de socios

- Agregar clase base Usuario
- Implementar SocioRegular, SocioVIP, Empleado, Visitante
- Definir permisos y límites para cada tipo"

git push origin ejercicio2/tipos-socios-base

# Crear rama para políticas de préstamo (dependiente)
git checkout ejercicio2/tipos-socios-base
git checkout -b ejercicio2/politicas-prestamo

# Implementar políticas
git add .
git commit -m "Implementar políticas de préstamo con patrón Strategy

- Agregar PoliticaEstricta, PoliticaFlexible
- Implementar PoliticaEstudiante y PoliticaDocente
- Permitir cambio dinámico de políticas"

git push origin ejercicio2/politicas-prestamo
```

---

## Comandos Git Esenciales

### Comandos para Gestión de Ramas

```bash
# Ver todas las ramas (locales y remotas)
git branch -a

# Crear y cambiar a nueva rama
git checkout -b nombre-rama

# Cambiar entre ramas
git checkout nombre-rama

# Eliminar rama local
git branch -d nombre-rama

# Eliminar rama remota
git push origin --delete nombre-rama

# Actualizar rama desde main
git checkout main
git pull origin main
git checkout mi-rama
git rebase main
```

### Comandos para Sincronización

```bash
# Obtener últimos cambios del repositorio remoto
git fetch origin

# Actualizar rama main local
git checkout main
git pull origin main

# Ver el estado actual
git status

# Ver diferencias
git diff

# Ver historial de commits
git log --oneline -10
```

---

## Mejores Prácticas

### 1. Nomenclatura de Ramas

Usa nombres descriptivos que indiquen:
- **Tipo**: `feature/`, `bugfix/`, `hotfix/`, `docs/`
- **Contexto**: `ejercicio1/`, `ejercicio2/`, `solid/`
- **Descripción**: breve descripción de lo que hace

**Ejemplos:**
```
feature/ejercicio1-reservas
feature/ejercicio2-tipos-socios
bugfix/corregir-calculo-multas
docs/guia-pull-requests
refactor/aplicar-solid-biblioteca
```

### 2. Commits Descriptivos

```bash
# ❌ Mal
git commit -m "fix"
git commit -m "cambios"

# ✅ Bien
git commit -m "Implementar sistema de reservas para biblioteca"
git commit -m "Corregir cálculo de días de retraso en multas"
git commit -m "Refactorizar Biblioteca para aplicar principio SRP"
```

### 3. Mantener PRs Pequeños y Enfocados

- **Un PR = Una funcionalidad**
- Máximo 300-500 líneas de código
- Cambios relacionados lógicamente
- Fácil de revisar y entender

### 4. Actualizar Ramas Regularmente

```bash
# Antes de hacer push, actualizar desde main
git checkout main
git pull origin main
git checkout mi-rama
git rebase main
git push --force-with-lease origin mi-rama
```

---

## Resolviendo Conflictos

### Conflictos de Merge

```bash
# Si hay conflictos durante rebase
git rebase main
# Resolver conflictos en archivos marcados
git add archivos-resueltos
git rebase --continue

# Si necesitas abortar el rebase
git rebase --abort
```

### Ejemplo de Resolución de Conflicto

```typescript
// En Biblioteca.ts - conflicto típico
<<<<<<< HEAD
public prestarLibro(socio: Socio, isbn: string): boolean {
    // Tu implementación
}
=======
public prestarLibro(socio: Socio, libro: Libro): boolean {
    // Implementación del main
}
>>>>>>> main

// Resolución combinando ambas versiones
public prestarLibro(socio: Socio, isbn: string): boolean {
    const libro = this.buscarLibroPorISBN(isbn);
    if (!libro) return false;
    // Resto de la implementación...
}
```

---

## Flujo de Trabajo Recomendado para paradigmaUAP2025

### Para Ejercicios Independientes

```bash
# Ejercicio 1
git checkout main
git checkout -b ejercicio1/implementacion-completa
# Trabajo...
git push origin ejercicio1/implementacion-completa

# Ejercicio 2
git checkout main
git checkout -b ejercicio2/tipos-y-politicas
# Trabajo...
git push origin ejercicio2/tipos-y-politicas

# Ejercicio 3
git checkout main
git checkout -b ejercicio3/sistema-rpg
# Trabajo...
git push origin ejercicio3/sistema-rpg
```

### Para Tareas Dentro del Mismo Ejercicio

```bash
# Ejercicio 1 - Tarea 1
git checkout main
git checkout -b ejercicio1/tarea1-reservas

# Ejercicio 1 - Tarea 2 (paralelo)
git checkout main
git checkout -b ejercicio1/tarea2-multas

# Ejercicio 1 - Tarea 3 (puede depender de Tarea 1)
git checkout ejercicio1/tarea1-reservas
git checkout -b ejercicio1/tarea3-autores
```

---

## Herramientas Útiles

### GitHub CLI (gh)

```bash
# Instalar GitHub CLI
# Ver: https://cli.github.com/

# Crear PR desde línea de comandos
gh pr create --title "Implementar sistema de reservas" --body "Descripción detallada"

# Ver PRs existentes
gh pr list

# Ver detalles de un PR
gh pr view 1
```

### VS Code Extensions

- **GitLens**: Mejor visualización de Git
- **GitHub Pull Requests**: Gestionar PRs desde VS Code
- **Git Graph**: Visualizar ramas gráficamente

---

## Checklist para Cada Pull Request

Antes de crear un PR, verifica:

- [ ] **Rama actualizada**: `git rebase main` realizado
- [ ] **Commits limpios**: Mensajes descriptivos y commits relacionados
- [ ] **Código funcional**: Probado localmente
- [ ] **Sin archivos innecesarios**: Solo cambios relevantes
- [ ] **Descripción clara**: Qué hace, por qué, cómo probar
- [ ] **Tamaño manejable**: No más de 500 líneas si es posible

### Template para Descripción de PR

```markdown
## Descripción
Breve descripción de los cambios realizados.

## Tipo de cambio
- [ ] Nueva funcionalidad
- [ ] Corrección de bug
- [ ] Refactorización
- [ ] Documentación

## Ejercicio/Tarea
- Ejercicio: [número]
- Tarea: [descripción]

## Cambios realizados
- Cambio 1
- Cambio 2
- Cambio 3

## Cómo probar
1. Paso 1
2. Paso 2
3. Resultado esperado

## Capturas de pantalla (si aplica)
[Agregar capturas si hay cambios visuales]
```

---

## Casos Especiales

### Trabajar en Fork vs Repositorio Original

Si trabajas en un fork:

```bash
# Configurar repositorio upstream
git remote add upstream https://github.com/usuario-original/paradigmaUAP2025.git

# Sincronizar con upstream
git fetch upstream
git checkout main
git merge upstream/main
git push origin main

# Crear rama desde main actualizado
git checkout -b feature/mi-funcionalidad
```

### Colaboración en Equipo

```bash
# Para colaborar en la misma rama
git checkout rama-compartida
git pull origin rama-compartida
# Hacer cambios
git add .
git commit -m "Mi contribución"
git pull origin rama-compartida  # Por si alguien más pusheo
git push origin rama-compartida
```

---

## Troubleshooting - Problemas Comunes

### "No puedo hacer push"

```bash
# Error: Updates were rejected
git pull origin mi-rama
# O si prefieres rebase:
git pull --rebase origin mi-rama
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

### "Quiero cancelar un PR y empezar de nuevo"

```bash
# Cerrar PR en GitHub
# Eliminar rama
git checkout main
git branch -D rama-antigua
git push origin --delete rama-antigua

# Empezar de nuevo
git checkout -b nueva-rama
```

---

## Conclusión

Crear múltiples pull requests es una habilidad esencial en el desarrollo colaborativo. Las estrategias principales son:

1. **Secuencial**: Para principiantes, un PR a la vez
2. **Paralelo**: Para trabajo independiente simultáneo
3. **Dependiente**: Para funcionalidades que se construyen una sobre otra

La clave está en:
- **Planificar** antes de empezar
- **Mantener** ramas actualizadas
- **Escribir** commits y descripciones claras
- **Revisar** antes de hacer push

Con práctica, podrás gestionar múltiples PRs eficientemente y colaborar mejor en proyectos de programación como los ejercicios de paradigmaUAP2025.

---

## Recursos Adicionales

- [Documentación oficial de Git](https://git-scm.com/doc)
- [GitHub Flow](https://guides.github.com/introduction/flow/)
- [Atlassian Git Tutorials](https://www.atlassian.com/git/tutorials)
- [Pro Git Book](https://git-scm.com/book)

---

**¿Tienes preguntas?** Abre un issue en el repositorio o consulta con tu instructor.