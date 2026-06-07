# Generador de Presupuestos de Obra

Aplicacion web estatica para crear presupuestos automaticos de construccion.
Esta hecha con HTML, CSS y JavaScript puro en el archivo principal `index.html`.

Ahora incluye integracion con Supabase para:

- Crear cuenta con correo y contrasena.
- Iniciar y cerrar sesion.
- Guardar presupuestos online.
- Cargar presupuestos del usuario.
- Editar y volver a guardar presupuestos.
- Eliminar presupuestos online.
- Guardar partidas asociadas al presupuesto.
- Ordenar partidas por codigo, capitulo y categoria.
- Ver resumen de costos por capitulos.
- Crear y cargar APUs.
- Agregar partidas al presupuesto desde APUs.
- Migrar borradores locales desde `localStorage` a Supabase.

## Archivos del proyecto

```text
index.html
README.md
supabase-schema.sql
supabase-migration-capitulos-apus.sql
```

El proyecto sigue siendo compatible con GitHub Pages, Netlify y Vercel porque no requiere servidor propio ni build con Node.js.

## Seguridad importante

- No uses `service_role key` en el frontend.
- Usa solo la publishable key o anon key de Supabase.
- Las tablas privadas deben tener Row Level Security activo.
- Las politicas incluidas permiten que cada usuario vea, cree, edite y elimine solo sus propios datos.
- No dejes tablas privadas abiertas publicamente.

## Paso 1: crear proyecto en Supabase

1. Entra a [Supabase](https://supabase.com/).
2. Crea un nuevo proyecto.
3. Espera a que termine la creacion de la base de datos.

## Paso 2: crear tablas, RLS y politicas

1. En Supabase, abre tu proyecto.
2. En el menu lateral, entra a `SQL Editor`.
3. Crea una nueva consulta con `New query`.
4. Copia todo el contenido del archivo `supabase-schema.sql`.
5. Pegalo en el SQL Editor.
6. Ejecuta la consulta con `Run`.

Ese SQL crea:

- Tabla `budgets`.
- Tabla `budget_items`.
- Tabla `apus`.
- Tabla `schedule_tasks` para una etapa posterior.
- Indices.
- Triggers de `updated_at`.
- Row Level Security.
- Politicas de seguridad por usuario autenticado.

Si ya habias ejecutado una version anterior del SQL, ejecuta tambien `supabase-migration-capitulos-apus.sql`.
Esa migracion agrega:

- `budget_items.code`
- `budget_items.chapter`
- `apus.performance`

No modifica RLS ni abre tablas publicamente.

## Paso 3: activar Auth con correo y contrasena

1. En Supabase, entra a `Authentication`.
2. Abre `Providers`.
3. Verifica que `Email` este activado.
4. En `URL Configuration`, agrega la URL publicada de tu sitio cuando ya la tengas.

Para GitHub Pages, sera una URL similar a:

```text
https://tu-usuario.github.io/nombre-del-repositorio/
```

## Paso 4: copiar datos de Supabase al codigo

En Supabase:

1. Entra a `Project Settings`.
2. Abre `API`.
3. Copia `Project URL`.
4. Copia la publishable key o anon public key.

En `index.html`, busca esta seccion:

```js
const SUPABASE_CONFIG = {
  url: "https://TU-PROYECTO.supabase.co",
  key: "TU_SUPABASE_PUBLISHABLE_OR_ANON_KEY"
};
```

Reemplaza:

- `url` por tu Supabase URL.
- `key` por tu publishable key o anon key.

No pegues claves secretas ni `service_role key`.

## Paso 5: publicar en GitHub Pages

1. Crea un repositorio en GitHub.
2. Sube `index.html`, `README.md`, `supabase-schema.sql` y `supabase-migration-capitulos-apus.sql`.
3. En GitHub, entra a `Settings`.
4. Abre `Pages`.
5. Selecciona la rama principal, normalmente `main`.
6. Selecciona la carpeta raiz.
7. Guarda los cambios.

GitHub Pages publicara el sitio con un link publico.

## Publicar en Netlify

1. Entra a [Netlify](https://www.netlify.com/).
2. Arrastra la carpeta del proyecto al panel de Netlify.
3. No configures comando de build.
4. Usa la raiz del proyecto como carpeta publicada.

## Publicar en Vercel

1. Entra a [Vercel](https://vercel.com/).
2. Importa el repositorio.
3. No configures comando de build.
4. Publica el proyecto.

## Uso de localStorage

La aplicacion conserva `localStorage` solo como respaldo opcional para borradores locales.

Importante:

- Los borradores locales solo existen en el navegador y dispositivo donde se crearon.
- Si abres el sitio desde otro PC o celular, esos datos locales no apareceran automaticamente.
- Si borras datos del navegador, puedes perder esos presupuestos locales.

El sistema principal ahora es Supabase. Para mover datos antiguos al sistema online:

1. Inicia sesion.
2. Usa el boton `Migrar datos locales a Supabase`.
3. La app subira los borradores locales guardados en `localStorage` al usuario actual.

## Flujo recomendado

1. Crear cuenta.
2. Iniciar sesion.
3. Crear o cargar un presupuesto.
4. Usar `Guardar presupuesto`. Si hay sesion iniciada, este boton guarda en Supabase.
5. Usar `Cargar presupuestos online` desde otro dispositivo con la misma cuenta.

## Base de APUs

La seccion `Base de APUs` guarda analisis de precio unitario en Supabase.

Cada APU puede tener:

- Codigo.
- Nombre.
- Unidad.
- Costo de materiales.
- Costo de mano de obra.
- Costo de equipos.
- Costo de subcontratos.
- Porcentaje de perdidas.
- Rendimiento.
- Precio unitario final.

La app conserva categoria, descripcion y notas como datos complementarios del APU.

Luego puedes agregar un APU al presupuesto como una partida.

## Futura mejora: guardar presupuestos online

Esta mejora ya quedo iniciada con Supabase:

- `localStorage` queda como respaldo.
- `budgets` guarda los datos generales y totales.
- `budget_items` guarda las partidas.
- `apus` guarda la base personalizada de precios unitarios.
- `schedule_tasks` queda preparada para una carta Gantt o programacion de obra posterior.

Siguientes mejoras recomendadas:

- Agregar recuperacion de contrasena.
- Permitir editar y eliminar APUs desde la interfaz.
- Agregar perfiles de empresa.
- Agregar logo y datos tributarios por usuario.
- Agregar programacion de obra usando `schedule_tasks`.
- Exportar presupuestos a PDF con plantilla mas avanzada.
