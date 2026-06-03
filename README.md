# Generador de Presupuestos de Obra

Aplicacion web estatica para crear presupuestos automaticos de construccion.
Funciona con HTML, CSS y JavaScript puro en un solo archivo principal: `index.html`.

## Estado del proyecto

- El archivo principal se llama `index.html`.
- No requiere servidor backend.
- No usa frameworks ni librerias externas.
- No usa rutas absolutas del equipo local.
- El CSS y JavaScript estan incluidos dentro de `index.html`, por lo que no hay rutas externas que configurar.
- Esta listo para publicarse como sitio estatico en Netlify, GitHub Pages o Vercel.

## Como abrirlo localmente

1. Abre la carpeta del proyecto.
2. Haz doble clic en `index.html`.
3. La aplicacion se abrira en el navegador.

Tambien puedes usar la extension Live Server de VS Code, aunque no es obligatorio.

## Publicar en Netlify

1. Entra a [Netlify](https://www.netlify.com/).
2. Crea una cuenta o inicia sesion.
3. Arrastra la carpeta del proyecto al panel de Netlify.
4. Netlify detectara el sitio como estatico.
5. No necesitas comando de build.
6. No necesitas carpeta de publicacion especial: usa la raiz del proyecto.

El sitio quedara disponible mediante un link publico de Netlify.

## Publicar en GitHub Pages

1. Crea un repositorio en GitHub.
2. Sube el archivo `index.html` y este `README.md`.
3. En GitHub, entra a `Settings`.
4. Abre la seccion `Pages`.
5. En `Build and deployment`, selecciona la rama principal, normalmente `main`.
6. Selecciona la carpeta raiz `/`.
7. Guarda los cambios.

GitHub Pages publicara el sitio en una URL similar a:

```text
https://tu-usuario.github.io/nombre-del-repositorio/
```

## Publicar en Vercel

1. Entra a [Vercel](https://vercel.com/).
2. Crea una cuenta o inicia sesion.
3. Importa el repositorio desde GitHub, GitLab o Bitbucket.
4. Vercel detectara que es un sitio estatico.
5. No configures comando de build.
6. Deja la carpeta de salida vacia o como raiz del proyecto, segun la interfaz.
7. Publica el proyecto.

Vercel entregara un link publico para abrir la aplicacion desde cualquier dispositivo.

## Importante sobre localStorage

La aplicacion guarda los presupuestos usando `localStorage`.

Esto significa que los presupuestos guardados solo quedan almacenados en el navegador y dispositivo donde se crearon. Por ejemplo:

- Si guardas un presupuesto en Chrome desde tu PC, quedara en ese Chrome de esa PC.
- Si abres el mismo link desde un celular, no veras automaticamente los presupuestos guardados en la PC.
- Si borras los datos del navegador, tambien puedes perder los presupuestos guardados localmente.

El link publico permite abrir la aplicacion desde cualquier dispositivo, pero no sincroniza los presupuestos entre dispositivos.

## Futura mejora: guardar presupuestos online

Para que los presupuestos puedan abrirse desde cualquier PC o celular con la misma cuenta, se puede migrar el guardado desde `localStorage` a Supabase.

Una posible implementacion seria:

1. Crear un proyecto en Supabase.
2. Crear autenticacion de usuarios con email y contrasena.
3. Crear una tabla `presupuestos` con campos como:
   - `id`
   - `user_id`
   - `cliente`
   - `proyecto`
   - `ubicacion`
   - `fecha`
   - `numero`
   - `items`
   - `totales`
   - `observaciones`
   - `created_at`
   - `updated_at`
4. Guardar `items` y `totales` como datos JSON.
5. Reemplazar las funciones actuales de guardado:
   - `saveBudget()`
   - `loadBudget()`
   - `deleteBudget()`
6. En vez de leer y escribir en `localStorage`, usar la API de Supabase.
7. Filtrar los presupuestos por `user_id` para que cada usuario vea solo sus propios datos.
8. Mantener `localStorage` como respaldo opcional para trabajo offline.

Con esa mejora, el usuario podria iniciar sesion y ver sus presupuestos desde cualquier dispositivo conectado a internet.

## Recomendacion antes de publicar

Antes de subir el proyecto, verifica que la carpeta contenga al menos:

```text
index.html
README.md
```

No es necesario instalar dependencias ni ejecutar comandos de build.
