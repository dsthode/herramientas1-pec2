---
title: Memoria de desarrollo de la PEC2
author: Damián Serrano Thode
date: 16/04/2021
lang: es
geometry: "a4paper,left=2.5cm,right=2.5cm,top=2.5cm,bottom=2.5cm"
mainfont: arev
fontsize: 12pt
linestretch: 1.5
toc_depth: 2
urlcolor: cyan
toccolor: black
linkcolor: black
numbersections: true
header-includes:
   - \usepackage{arev}
---

# Proceso de desarrollo

## Gestión de las imágenes

Para el desarrollo de la práctica he comenzado volviendo a descargar las imágenes originales, ya que a partir de cada una de ellas se van a generar varias versiones de las mismas:

* Cuatro versiones de cada fotografía en distintos tamaños: 200px, 400px, 600px y 800px. De este modo esta disponible una imagen con el tamaño adecuado para los distintos tamaños de pantalla.

* Las fotografías anteriores son todas en versión JPEG, ya que se trata de fotografías de comida con distintas tonalidades y cambios de color. Por lo tanto, de cada una de ellas se generó además una versión en WebP. Los formatos PNG o GIF no aplican ya que las imágenes no tienen zonas continuas de color y podrían ocupar más que las originales.

* Además, de las imágenes principales se sacaron versiones en las que se recortó la imagen en altura, para poder hacer la dirección de arte en ciertas páginas.

Posteriormente utilicé un programa de diseño vectorial (Inkscape) para realizar el logo de la página. Éste está hecho en formato SVG, y contiene el logo redondo y el texto en tres colores. Lo hice en dos formatos distintos: uno en horizontal y otro en vertical con el logo redondo al lado del texto a tres líneas, de este modo los puedo usar para hacer dirección de arte con la cabecera según el formato de la pantalla.

Y por último, extraje las estrellas del logo circular para usarlas en la animación de la página de presentación.

## Generación de las imágenes en distintos tamaños

Para la generación de las imágenes en los distintos tamaños indicados anterioremente (200px, 400px, 600px, 800px), instalé el módulo ```responsive-images-resizer```, el cual configuré para generar las imágenes en estos cuatro tamaños. La generación de las imágenes se hace de forma asíncrona, de modo que fueron generadas una vez y se guardan en el repositorio de código.

Para la generación de las imágenes tomé como base el ejemplo de configuración disponible en la [página web del módulo](https://www.npmjs.com/package/responsive-images-resizer) y lo modifiqué para generar los tamaños indicados, quedando el archivo ```resize-images.js``` de la siguiente forma para ser ejecutado manualmente con node:

```js
const resizer = require('responsive-images-resizer');
resizer('src/images/orig', 'src/images/build/', ['200', '400', '600', '800'])
  .then(() => {
    console.log('Done!');
  })
  .catch((err) => {
    console.log('err:', err);
  });
```

Un problema que he encontrado con este módulo es que en mi entorno de trabajo (Linux) estaba generando las imagenes mal, con las barras invertidas que separan los directorios en Windows incrustadas en el nombre. Buscando en los archivos fuente encontré que el problema era que el autor había usado este caracter directamente como separador en las carpetas en vez de usar la constante ```path.sep``` de Node, lo cual haría el código más portable.

Por lo tanto, tuve que modificar el archivo de fuente a mano, ya que aunque en el [repositorio de Github](https://github.com/AndriesK/responsive-images-resizer) se encuentra corregido en la versión de ```master```, no se ha generado ningún paquete en NPM que incluya esta corrección.

## Aplicación de la dirección de arte

Para esta práctica se pedia realizar dirección de arte en las páginas de detalle de cada una de las recetas.

Como he mencionado en el apartado anterior, de las imágenes principales de cada plato generé una versión recortada en la vertical en dos tamaños (para tablet y para escritorio), y de este modo, he usado la versión recortada de las imágenes en las vistas de ordenador de escritorio y tablet, y la versión completa en la vista de móvil.

Para la dirección de arte utilicé el elemento ```<picture>```, quedando el bloque de la siguiente forma:

```html
<picture class="receta-main-image">
   <source media="(max-width: 480px)" srcset="images/build/400/burger-400.jpg">
   <source media="(min-width: 481px) and (max-width:800px)" srcset="images/burger-receta-main-800.jpg">
   <source media="(min-width: 801px)" srcset="images/burger-receta-main-1000.jpg">
   <img alt="imagen de una hamburguesa preparada"
      src="images/build/200/burger-200.jpg">
</picture>
```

Además, también he aplicado dirección de arte a la cabecera de la página, de modo que cuando se visualiza en un dispositivo tablet u ordenador de escritorio el logo aparece en horizontal, y cuando se visualiza en un dispositivo móvil aparece el texto en tres líneas. Esta dirección de arte la hago igualmente con un elemento ```<picture>```, cambiando la imagen según el tamaño de la pantalla:

```html
<picture class="header-logo-image">
      <source type="image/svg+xml" media="(min-width:481px)" srcset="images/logo-con-texto-h.svg">
      <source type="image/svg+xml" media="(max-width:480px)" srcset="images/logo-con-texto-v.svg">
      <source type="image/png" media="(min-width:481px)" srcset="images/logo-con-texto-h.png">
      <source type="image/png" media="(max-width:480px)" srcset="images/logo-con-texto-v.png">
      <img src="images/logo-con-texto-h.png" alt="logo de la página">
</picture>
```

Como se puede observar también en el elemento, he usado una imagen en formato PNG para los dispositivos en los que no haya soporte para el logotipo en SVG.

## Aplicación de los formatos responsive

Para el formato responsive de las imágenes he usado el elemento ```<img>``` con los atributos ```srcset``` y ```sizes```. De este modo puedo aplicar una imagen de un tamaño adecuado a la pantalla en la que se está visualizando la página. Un ejemplo de uso de este elemento es el siguiente:

```html
<img 
      class="plato-image" 
      src="images/build/400/burger-400.jpg" 
      alt="imagen de una hamburguesa preparada" 
      srcset="images/build/200/burger-200.jpg 200w,
            images/build/400/burger-400.jpg 400w,
            images/build/600/burger-600.jpg 600w,
            images/build/800/burger-800.jpg 800w"
      sizes="(max-width:480px) 230px,
            (max-width:1024px) 590px,
            450px"
      />
```

Un detalle que me hizo perder tiempo fue que en las pruebas estaba usando el simulador de diseño adaptable del navegador y en las pruebas que estaba haciendo con un dispositivo móvil con pantalla de 360px me estaba descargando la versión de 800px de la imagen. Tras hacer varias pruebas me di cuenta de que la relación de *device to pixel ratio* (DPR) del disporitivo era 4, por lo que para el navegador implicaba una pantalla de 1440px, lo que explicaba por qué estaba descargando la imagen de 800px. Configuré un dispositivo nuevo con un DPR de 1 y un ancho de 240px y ya pude ver como se descargaba la versión de 200px de la imagen.

## Aplicación de las imágenes SVG

En la cabecera de la página, como he explicado anteriormente, estoy usando una imagen en formato SVG si este está soportado por el navegador (si no, usaría el formato PNG). E igualmente, en el pie he incluido el logo redondo en formato SVG y PNG.

En la página de presetación he embebido unos elementos SVG de unas estrellas para posteriormente animarlos usando CSS. En este caso les he aplicado una animación de rotación.

Un detalle sobre esta animación es que he tenido que aplicar la propiedad ```transform-origin: 12px 12px``` en el estilo de CSS, ya que el origen de coordenadas se encuentra en la esquina superior izquierda, para trasladarlo aproximadamente al centro de la imagen y que la rotación se haga corretamente.

## Aplicación de efectos de transición

Para los efectos de transición, he aplicado una animación de color en los enlaces de la cabecera y el pie. Cuando se desliza el ratón por encima de los enlaces éstos cambian de color blanco a color rojo. Lamentablemente esta transición no es posible visualizarla en las pantallas táctiles ya que carecen del efecto ```hover```.

## Aplicación de clip-path

Para aplicar ```clip-path``` he usado la página [CSS Clip path maker](https://bennettfeely.com/clippy/) para diseñar una estrella similar a la que se encuentra en el logo redondo, y he aplicado este trazo a las imágenes de la página de índice.

El efecto queda de la siguiente forma en el estilo CSS que se aplica a las imágenes:

```css
clip-path: polygon(50% 0%, 69% 26%, 98% 35%, 77% 58%, 79% 91%, 
                  50% 77%, 21% 91%, 24% 57%, 2% 35%, 30% 26%);
```

## Aplicación de favicon

Adicionalmente, he incluido un *favicon* en la página en dos formatos, en SVG y PNG, de modo que si el navegador no soporta el primero, mostraría el de formato PNG. El código para incluir el *favicon* en la página es el siguiente:

```html
<link rel="icon" type="image/svg+xml" href="images/logo.svg">
<link rel="icon" type="image/png" href="images/icon.png">
```

# Enlaces

La página web puede consultarse en la siguiente dirección: [https://pensive-raman-c3fbb8.netlify.app/](https://pensive-raman-c3fbb8.netlify.app/).

Y el repositorio donde está alojado el código fuente de la página es el siguiente: [https://github.com/dsthode/herramientas1-pec2](https://github.com/dsthode/herramientas1-pec2).
