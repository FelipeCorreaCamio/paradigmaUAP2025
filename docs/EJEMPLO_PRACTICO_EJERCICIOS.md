# Ejemplo Práctico: Aplicando Múltiples PRs a paradigmaUAP2025

Este archivo demuestra cómo aplicar las estrategias de múltiples pull requests a los ejercicios reales del repositorio.

## Escenario: Completar todas las tareas del Ejercicio 1

Basándose en `objetos/ejercicios/ejercicio1/Ejercicio 1.md`, tenemos 5 tareas para implementar:

1. Sistema de Reservas
2. Cálculo de Multas  
3. Gestión de Autores
4. Eventos y Notificaciones
5. Historial de Lectura y Recomendaciones

### Estrategia Recomendada: Paralela con algunas dependencias

```bash
# Estado inicial - estar en main actualizado
git checkout main
git pull origin main

# Tarea 1: Sistema de Reservas (Independiente)
git checkout -b ejercicio1/tarea1-reservas
# Implementar:
# - Clase Reserva
# - Modificar Biblioteca para manejar cola de reservas
# - Agregar notificaciones de disponibilidad
git add .
git commit -m "Implementar sistema de reservas para libros prestados

- Agregar clase Reserva con cola FIFO
- Modificar Biblioteca.prestarLibro() para manejar reservas
- Agregar Biblioteca.reservarLibro() y notificarDisponibilidad()
- Los socios pueden reservar libros ya prestados
- Notificación automática cuando libro esté disponible"
git push origin ejercicio1/tarea1-reservas

# Tarea 2: Cálculo de Multas (Independiente)
git checkout main
git checkout -b ejercicio1/tarea2-multas
# Implementar:
# - Clase Multa
# - Modificar Socio para rastrear multas
# - Validación en préstamos
git add .
git commit -m "Implementar sistema de multas por libros vencidos

- Agregar clase Multa con cálculo de $50 por día
- Modificar Socio para trackear multas pendientes
- Prevenir nuevos préstamos si hay multas sin pagar
- Agregar método Socio.pagarMulta() y calcularMulta()"
git push origin ejercicio1/tarea2-multas

# Tarea 3: Gestión de Autores (Independiente - refactoring)
git checkout main
git checkout -b ejercicio1/tarea3-autores
# Implementar:
# - Clase Autor
# - Refactorizar Libro para usar Autor en lugar de string
# - Métodos de búsqueda por autor
git add .
git commit -m "Implementar gestión de autores con clase dedicada

- Agregar clase Autor (nombre, biografía, añoNacimiento)
- Refactorizar Libro.autor de string a objeto Autor
- Agregar Biblioteca.buscarLibrosPorAutor()
- Agregar Biblioteca.agregarAutor() y getAutores()
- Mantener compatibilidad con código existente"
git push origin ejercicio1/tarea3-autores
```

### Continuando con tareas dependientes:

```bash
# Tarea 4: Eventos (Depende de Tarea 3 para autores)
git checkout ejercicio1/tarea3-autores  # Base en rama de autores
git checkout -b ejercicio1/tarea4-eventos
# Implementar:
# - Clase EventoBiblioteca
# - Sistema de notificaciones
# - Integración con autores para charlas
git add .
git commit -m "Implementar sistema de eventos y notificaciones

- Agregar clase EventoBiblioteca (clubes, charlas, etc.)
- Sistema de notificaciones para socios
- Eventos pueden incluir autores específicos
- Notificaciones por libros vencidos y eventos próximos"
git push origin ejercicio1/tarea4-eventos

# Tarea 5: Historial (Depende de todas las anteriores)
# Esperar a que tareas 1-3 sean fusionadas, luego:
git checkout main
git pull origin main  # Obtener todas las funcionalidades fusionadas
git checkout -b ejercicio1/tarea5-historial
# Implementar historial completo
git add .
git commit -m "Implementar historial de lectura y recomendaciones

- Agregar Socio.historialLectura[]
- Implementar algoritmo de recomendaciones
- Basado en autores y títulos similares del historial
- Integración con sistema de eventos para recomendar charlas"
git push origin ejercicio1/tarea5-historial
```

## Escenario: Ejercicio 2 - Tipos de Socios y Políticas

Basándose en `objetos/ejercicios/ejercicio2/Ejercicio 2.md`:

### Estrategia: Dependiente con base común

```bash
# Tarea base: Jerarquía de socios
git checkout main
git checkout -b ejercicio2/base-tipos-socios
# Crear jerarquía: Usuario -> SocioRegular, SocioVIP, Empleado, Visitante
git add .
git commit -m "Crear jerarquía de tipos de socios

- Agregar clase base Usuario
- Implementar SocioRegular (3 libros, período estándar)
- Implementar SocioVIP (5 libros, período extendido, sin multas)
- Implementar Empleado (acceso ilimitado, libros referencia)
- Implementar Visitante (solo consulta catálogo)"
git push origin ejercicio2/base-tipos-socios

# Tarea dependiente: Tipos de préstamo
git checkout ejercicio2/base-tipos-socios
git checkout -b ejercicio2/tipos-prestamo
# Implementar herencia de Prestamo
git add .
git commit -m "Implementar polimorfismo con tipos de préstamo

- Clase base abstracta Prestamo
- PrestamoRegular (14 días, multa estándar)
- PrestamoCorto (7 días, multa doble)
- PrestamoReferencia (solo consulta)
- PrestamoDigital (sin límite, sin multa)"
git push origin ejercicio2/tipos-prestamo

# Tarea dependiente: Políticas Strategy
git checkout ejercicio2/base-tipos-socios
git checkout -b ejercicio2/politicas-strategy
# Implementar patrón Strategy para políticas
# (Esta parte ya está implementada en el repo)
git add .
git commit -m "Implementar políticas de préstamo con patrón Strategy

- PoliticaEstricta (no préstamos con vencidos)
- PoliticaFlexible (período reducido con vencidos)
- PoliticaEstudiante (período extendido en exámenes)
- PoliticaDocente (larga duración, múltiples renovaciones)"
git push origin ejercicio2/politicas-strategy
```

## Gestión de PRs Múltiples

### Orden de Revisión Sugerido

1. **Primera Ola** (Independientes):
   - `ejercicio1/tarea1-reservas`
   - `ejercicio1/tarea2-multas`
   - `ejercicio2/base-tipos-socios`

2. **Segunda Ola** (Ligeramente dependientes):
   - `ejercicio1/tarea3-autores`
   - `ejercicio2/tipos-prestamo`
   - `ejercicio2/politicas-strategy`

3. **Tercera Ola** (Muy dependientes):
   - `ejercicio1/tarea4-eventos`
   - `ejercicio1/tarea5-historial`

### Comandos de Mantenimiento

```bash
# Ver estado de todas las ramas
git branch -a
git log --oneline --graph --all

# Actualizar rama con cambios de main
git checkout mi-rama
git rebase main
git push --force-with-lease origin mi-rama

# Limpiar ramas después de fusión
git checkout main
git pull origin main
git branch -d ejercicio1/tarea1-reservas
git push origin --delete ejercicio1/tarea1-reservas
```

## Checklist por Tarea

### Antes de crear cada PR:

- [ ] **Rama actualizada**: `git rebase main` completado
- [ ] **Tests funcionando**: Si hay tests, asegurar que pasen
- [ ] **Código limpio**: Sin console.log, código comentado, etc.
- [ ] **Commits atómicos**: Cada commit hace una cosa específica
- [ ] **Descripción clara**: Template de PR completado

### Template de Descripción para ejercicios:

```markdown
## Ejercicio 1 - Tarea X: [Nombre de la tarea]

### Descripción
Implementación de [funcionalidad] como parte del Ejercicio 1 del sistema de biblioteca.

### Cambios realizados
- [ ] Agregar clase [Clase] con métodos [métodos]
- [ ] Modificar [ClaseExistente] para [propósito]
- [ ] Agregar validaciones para [casos]
- [ ] Tests/ejemplos de uso

### Archivos modificados
- `objetos/ejercicios/ejercicio1/clases/[archivo].ts`
- `objetos/ejercicios/ejercicio1/index.ts` (si aplica)

### Cómo probar
1. Ejecutar `npm run test` (si hay tests)
2. O ejecutar ejemplo en `index.ts`
3. Verificar que [funcionalidad específica] funcione

### Notas
- Esta implementación sigue el principio [SOLID relevante]
- Compatible con implementación existente
- Preparado para integración con otras tareas
```

## Beneficios de este Enfoque

1. **Desarrollo Paralelo**: Múltiples tareas simultáneamente
2. **Revisiones Enfocadas**: Cada PR es una funcionalidad específica
3. **Rollback Granular**: Fácil deshacer cambios específicos
4. **Aprendizaje Incremental**: Cada tarea enseña conceptos específicos
5. **Portfolio**: Cada PR demuestra habilidades diferentes

## Integración Final

Una vez que todos los PRs sean fusionados:

```bash
git checkout main
git pull origin main
git checkout -b demo/integracion-completa

# Crear ejemplo que use todas las funcionalidades
# Demostrar reservas + multas + autores + eventos + historial trabajando juntos

git add .
git commit -m "Demo: Integración completa de todas las funcionalidades

- Ejemplo que demuestra reservas, multas, autores, eventos e historial
- Casos de uso realistas combinando múltiples funcionalidades
- Documentación de la API completa"
git push origin demo/integracion-completa
```

---

**Resultado**: En lugar de 1 PR gigante con todo, tienes 8-10 PRs específicos, cada uno fácil de revisar, entender y aprobar. Esto demuestra mejor comprensión de Git, trabajo colaborativo y desarrollo incremental.