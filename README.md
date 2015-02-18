# D3.js - animated U.S. states border map

This is a step-by-step tutorial on making an animated map of the changing borders of U.S. states through history, using [D3.js](http://d3js.org/). This tutorial was made for [Maptime Amsterdam](http://maptime-ams.github.io/)'s [fourth Meetup](http://www.meetup.com/Maptime-AMS/events/220184135/), on February 18th, 2015.

To complete this tutorial, you need two things:

- __A modern browser__, like Firefox, Safari, Chrome, or a recent version of Internet Explorer. I like Chrome, because it's a faster when it comes to SVG rendering and animation..
- A good text editor, for example [Sublime Text](http://www.sublimetext.com/), [Textmate](http://macromates.com/) or [Notepad++](http://notepad-plus-plus.org/).

### D3.js

In this tutorial, we'll use [D3.js](http://d3js.org/) to convert [GeoJSON files](http://geojson.org/) to SVG, and draw and animate them in the browser. D3.js is an extremely powerful data manipulation and visualization library, written in JavaScript. From d3js.org:

> D3.js is a JavaScript library for manipulating documents based on data. D3 helps you bring data to life using HTML, SVG, and CSS. D3’s emphasis on web standards gives you the full capabilities of modern browsers without tying yourself to a proprietary framework, combining powerful visualization components and a data-driven approach to DOM manipulation.

D3 is _hard_ for beginners. This tutorial will guide you through the process of making a map using D3, it will point you to useful tools and techniques and it will give you an overview of D3's mapping possibilities, but there is no way you can learn D3 in one night. Luckily, D3's documentation is very good, there are many online tutorials and examples available to help you. It's recommended that you'll have a look at some of the links below before you start with the tutorial.

- [D3 documentation](https://github.com/mbostock/d3/wiki)
- [D3 tutorials](https://github.com/mbostock/d3/wiki/Tutorials)
- [Mike Bostock's examples](http://bl.ocks.org/mbostock)
- [Scott Murray's D3 tutorials](http://alignedleft.com/tutorials/d3)

There's also a lot of information available about making maps with D3:

- [Mike Bostock's map tutorial](http://bost.ocks.org/mike/map/)
- [Jason Davies' maps and visualizations](http://www.jasondavies.com/)
- [Maptime Seattle's Mapping with D3.js](http://maptimesea.github.io/2015/01/07/d3-mapping.html)
- [Maptime Boston's D3 tutorial](http://maptimeboston.github.io/d3-maptime/)
- [Ian Johnson's tutorials](http://enjalot.github.io/intro-d3/maptime/)

## Let's get started!

We'll start by cloning or downloading the [`animated-borders-d3js` repository](https://github.com/maptime-ams/animated-borders-d3js) from GitHub. If you have Git installed, simply go to your terminal and type:

    git clone https://github.com/maptime-ams/animated-borders-d3js.git

(If you have GitHub's [Mac](https://mac.github.com/) or [Windows](https://windows.github.com) client installed, you can also easily click the _Clone in Desktop_ button!)

If you don't have Git installed, you should install Git. It's easy. On your Mac, just install [Homebrew](http://brew.sh/) and then type `brew install git`. For installation on Windows, see [git-scm.com](http://git-scm.com/book/en/v2/Getting-Started-Installing-Git#Installing-on-Windows) for more information. And if you're using Linux, you'll probably already have Git installed (and don't need any explaining anyway).

- __I don't want to install Git!__
- You don't have to! You can also just download this tutorial as a [ZIP file](https://github.com/maptime-ams/animated-borders-d3js/archive/gh-pages.zip)!

If you've cloned the repository, browse to the tutorial's directory to get started. If you've downloaded the ZIP file, unzip it, and do the same.

## Step 0: Data

D3.js is all about data. In this tutorial, we'll use geo-spatial files containing U.S. state boundaries from the [National Historical Geographic Information System](https://www.nhgis.org/):

> The National Historical Geographic Information System (NHGIS) provides, free of charge, aggregate census data and GIS-compatible boundary files for the United States between 1790 and 2013.

After 1910, the borders of the states did not change much anymore, so we'll use data from 1790 to 1910.

### Download and convert NHGIS data yourself

_You don't have to download and convert NHGIS data, this tutorial comes with all the data you need. Just skip this section!_

To download and convert the data needed for this tutorial yourself, follow these steps:

1. Get Shapefiles with state data, per year
  - You can use [the NHGIS Data Finder](https://data2.nhgis.org/main) to select the data you need,
  - Or simply download [`animated-borders-d3js.zip`](https://dl.dropboxusercontent.com/u/12905316/maptime/4/animated-borders-d3js.zip) from Maptime Amsterdam's Dropbox
2. Move/copy the zipped Shapefiles to the data directory (the files should be named `nhgis0001_shapefile_tl2000_us_state_XXXX.zip`)
3. Convert the Shapefiles to [TopoJSON](https://github.com/mbostock/topojson/wiki)!

To do this, you need to install [shp2json](https://github.com/substack/shp2json) and TopoJSON, and you need [Node.js](http://nodejs.org/).

    brew install node
    npm install -g shp2json
    npm install -g topojson

Afterwards, you can convert a Shapefile to TopoJSON by running shp2json and piping its output to TopoJSON:

    shp2json <shapefile> | topojson -p STATENAM -s 1e-6

Or, run `shp2topojson.sh`, a convenient script that comes with this tutorial:

    cd scripts
    ./shp2topojson.sh

### Use data in tutorial's data directory

Done! But you should have a look at the [TopoJSON](https://github.com/mbostock/topojson/wiki) files in the `data` directory, either with your text editor, or [on GitHub](data/1840.json) (GitHub lets you even view GeoJSON files!).

## Step 1: Empty website

Browse to the tutorial's directory. This directory should contain four subdirectories (`data`, `scripts`, `static`, `tutorial`), and one file (`README.md`). In this directory, next to `README.md`, create a new, empty file named `index.html`. This HTML file will contain the website with animated map. Let's start with some very simple HTML, pasting this in `index.html`, and saving the file:

```html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
</head>
<body>
</body>
</html>
```

Great! You've made a website! Now, we can view this website in the browser, by double clicking on the HTML file. _But this is not enough!_ Our HTML file will load external JSON (the state boundaries), and most browsers will not allow doing this using the `file://` protocol (which is what your browser will use then viewing local files).

__We need a web server!__ On Mac or Linux, use the terminal to go to the tutorial's directory, and type:

    python -m SimpleHTTPServer

Done! Your newly created HTML page should now be available on [http://localhost:8000/](http://localhost:8000/)!

On Windows, you could try to install [Fenix](http://fenixwebserver.com/).

__After this step, your map should look like this:__

- [Source code](tutorial/1/index.html)
- [View in browser](http://maptime-ams.github.io/animated-borders-d3js/tutorial/1)
- Screenshot (nice & empty!):

[![](tutorial/1/screenshot.png)](http://maptime-ams.github.io/animated-borders-d3js/tutorial/1)

## Step 2: Title and header

In side your page's `<head>` tag, add a title:

```
<title>Maptime AMS #4: Geopolitics, Borders &amp; D3.js!</title>
```

The above will give the page a title, which is displayed in your browser's tabs. We want more! We __________

```html
<h1>United States in <span id="year">1790</span></h1>
```

__After this step, your map should look like this:__

- [Source code](tutorial/2/index.html)
- [View in browser](http://maptime-ams.github.io/animated-borders-d3js/tutorial/2)
- Screenshot:

[![](tutorial/2/screenshot.png)](http://maptime-ams.github.io/animated-borders-d3js/tutorial/2)

## Step 3: A map! With D3.js!





```html
<script src="http://d3js.org/d3.v3.min.js" charset="utf-8"></script>
<script src="http://d3js.org/topojson.v1.min.js"></script>
```


```html
<style>
  * {
    margin: 0;
    padding: 0;
  }

  svg {
    position: absolute;
    width: 100%;
    height: 100%;
  }
</style>
```



```html
<svg>
  <g id="states"></g>
</svg>
```


uitleggen d3.select
projection
https://github.com/mbostock/d3/wiki/Geo-Projections#albersUsa


.json
objects.stdin

```html
<script>
  var svgStates = d3.select("svg #states");

  var projection = d3.geo.albersUsa();

  var path = d3.geo.path()
      .projection(projection);

  d3.json("data/states.json", function(error, topologies) {

    var state = topojson.feature(topologies[0], topologies[0].objects.stdin);

    svgStates.selectAll("path")
        .data(state.features)
        .enter()
      .append("path")
        .attr("d", path);
  });
</script>
```




__After this step, your map should look like this:__

- [Source code](tutorial/3/index.html)
- [View in browser](http://maptime-ams.github.io/animated-borders-d3js/tutorial/3)
- Screenshot:

[![](tutorial/3/screenshot.png)](http://maptime-ams.github.io/animated-borders-d3js/tutorial/3)

## Step 4: Scale & position map in browser's center



remove:

```js
var projection = d3.geo.albersUsa();
```

update
```js
var width = window.innerWidth,
  height = window.innerHeight;
var projection = d3.geo.albersUsa()
  .translate([width / 2, height / 2]);
```



__After this step, your map should look like this:__

- [Source code](tutorial/4/index.html)
- [View in browser](http://maptime-ams.github.io/animated-borders-d3js/tutorial/4)
- Screenshot:

[![](tutorial/4/screenshot.png)](http://maptime-ams.github.io/animated-borders-d3js/tutorial/4)

## Step 5: Load all states for all years (1790 - 1910)


replace

```js
var svgStates = d3.select("svg #states");
```

with

```js
var svgStates = d3.select("svg #states"),
    states = {}
    startYear = 1790,
    currentYear = startYear;
```

replace

```js
var state = topojson.feature(topologies[0], topologies[0].objects.stdin);
```

with

```js
for (var i = 0; i < topologies.length; i++) {
  states[startYear + i * 10] = topojson.feature(topologies[i], topologies[i].objects.stdin);
}
```



replace

```js
.data(state.features)
```

with

```js
.data(states[currentYear].features)
```





__After this step, your map should look like this:__

- [Source code](tutorial/5/index.html)
- [View in browser](http://maptime-ams.github.io/animated-borders-d3js/tutorial/5)
- Screenshot:

[![](tutorial/5/screenshot.png)](http://maptime-ams.github.io/animated-borders-d3js/tutorial/5)

## Step 6: `update()` function

This is a boring step, but we need this later. In this step, we'll encapsulate the code that gets the GeoJSON objects for the current year (`states[currentYear].features`) and appends them as SVG paths to the HTML document in a new function, called `update()`. We'll add animation
code later, and we need the animation to redraw and update the map every ten years.

After defining the function, we'll run it directly, to make sure the map gets drawn for the first time (for the year `currentYear`).

Remove the following lines from your HTML file:

```js
svgStates.selectAll("path")
   .data(states[currentYear].features)
   .enter()
 .append("path")
   .attr("d", path);
```

And replace them with the following:

```
function update() {
  svgStates.selectAll("path")
      .data(states[currentYear].features)
      .enter()
    .append("path")
      .attr("d", path);
}

update();
```

__After this step, your map should look like this:__

- [Source code](tutorial/6/index.html)
- [View in browser](http://maptime-ams.github.io/animated-borders-d3js/tutorial/6)
- Screenshot:

[![](tutorial/6/screenshot.png)](http://maptime-ams.github.io/animated-borders-d3js/tutorial/6)

## Step 7: SVG style for US states


```css
path {
  stroke: #666;
  fill: none;
  fill-opacity: 0.6;
  stroke-width: 1px;
  stroke-linecap: round;
  stroke-linejoin: round;
}
```



__After this step, your map should look like this:__

- [Source code](tutorial/7/index.html)
- [View in browser](http://maptime-ams.github.io/animated-borders-d3js/tutorial/7)
- Screenshot:

[![](tutorial/7/screenshot.png)](http://maptime-ams.github.io/animated-borders-d3js/tutorial/7)

## Step 8: Dashed USA coastline


```css
#boundary path {
  stroke-dasharray: 3, 5;
}
```

```html
<g id="boundary"></g>
```


```js
svgBoundary = d3.select("svg #boundary"),
```


```js
d3.json("data/usa.json", function(error, boundary) {
 svgBoundary.selectAll("path")
     .data(boundary.features)
     .enter()
   .append("path")
     .attr("d", path)
});
```

__After this step, your map should look like this:__

- [Source code](tutorial/8/index.html)
- [View in browser](http://maptime-ams.github.io/animated-borders-d3js/tutorial/8)
- Screenshot:

[![](tutorial/8/screenshot.png)](http://maptime-ams.github.io/animated-borders-d3js/tutorial/8)

## Step 9: Nice font, and a Maptime logo

```css
@font-face {
  font-family: 'Bree Serif';
  src: url("static/BreeSerif-Regular.otf");
  font-weight: 800;
  font-style: italic;
}

h1 {
  position: absolute;
  left: 20px;
  top: 20px;
  font-family: 'Bree Serif';
  font-size: 35px;
}

#maptime {
  position: absolute;
  right: 20px;
  top: 20px;
}
```


```html
<img id="maptime" src="static/maptime.png" />
```

__After this step, your map should look like this:__

- [Source code](tutorial/9/index.html)
- [View in browser](http://maptime-ams.github.io/animated-borders-d3js/tutorial/9)
- Screenshot:

[![](tutorial/9/screenshot.png)](http://maptime-ams.github.io/animated-borders-d3js/tutorial/9)

## Step 10: Colors, colors, colors!

https://github.com/mbostock/d3/wiki/Ordinal-Scales
http://colorbrewer2.org/


```html
<script src="static/colors.js"></script>
```




add this (make sure to remove the semicolon on previous line)

```js
.style("fill", function(d, i) {
  var name = d.properties.STATENAM.replace(" Territory", "");
  return colors[name];
});
```


__After this step, your map should look like this:__

- [Source code](tutorial/10/index.html)
- [View in browser](http://maptime-ams.github.io/animated-borders-d3js/tutorial/10)
- Screenshot:

[![](tutorial/10/screenshot.png)](http://maptime-ams.github.io/animated-borders-d3js/tutorial/10)

## Step 11: State name tooltips


add this (make sure to remove the semicolon on previous line)

```js
.append("svg:title")
  .text(function(d) { return d.properties.STATENAM; });
```

__After this step, your map should look like this:__

- [Source code](tutorial/11/index.html)
- [View in browser](http://maptime-ams.github.io/animated-borders-d3js/tutorial/11)
- Screenshot:

[![](tutorial/11/screenshot.png)](http://maptime-ams.github.io/animated-borders-d3js/tutorial/11)

## Step 12: Time slider

https://github.com/tmcw/chroniton



```html
<script src="static/chroniton.js"></script>
<link href="static/chroniton.css" rel="stylesheet">
```


```css
#slider {
  position: absolute;
  left: 50%;
  margin-left: -300px;
  bottom: 20px;
  width: 600px;
  height: 50px;
}
```


```html
<div id="slider">
</div>
```


```js
d3.select("#slider")
    .call(
      chroniton()
        .domain([new Date(startYear, 1, 1), new Date(startYear + (topologies.length - 1) * 10, 1, 1)])
        .labelFormat(function(date) {
          return Math.ceil((date.getFullYear()) / 10) * 10;
        })
        .width(600)
    );
```







__After this step, your map should look like this:__

- [Source code](tutorial/12/index.html)
- [View in browser](http://maptime-ams.github.io/animated-borders-d3js/tutorial/12)
- Screenshot:

[![](tutorial/12/screenshot.png)](http://maptime-ams.github.io/animated-borders-d3js/tutorial/12)

## Step 13: Animation!

Chroniton has [playback functionality](https://github.com/tmcw/chroniton#playback) which we'll use to update the map when the slider "enters" a new decade. Add the following lines somewhere in the function chain after `chroniton()`, for example after `.width(600)`:

```js
.on('change', function(date) {
  var newYear = Math.ceil((date.getFullYear()) / 10) * 10;
  if (newYear != currentYear) {
    currentYear = newYear;
    svgStates.selectAll("path").remove();
    update();
  }
})
.playButton(true)
.playbackRate(0.2)
.loop(true)
```

Chroniton will emit a `change` event each time the slider's position changes (either triggered by the animation, or by the user). Each time this happens, a function is called with the slider's current date as a parameter:

```js
function(date) {
  var newYear = Math.ceil((date.getFullYear()) / 10) * 10;
  if (newYear != currentYear) {
    currentYear = newYear;
    svgStates.selectAll("path").remove();
    update();
  }
}
```

In this function, we'll check whether the slider's date is in a different decade then `currentYear`. If this is the case, we'll remove all SVG paths from `svgStates` (and thereby clearing the map) and we'll update and redraw the map afterwards.

Finally, add the following line somewhere In the `update()` function. Now, the span element in the heading (`<span id="year">1790</span>`) will get updated when the map changes.

```js
d3.select("#year").html(currentYear);
```

__After this step, you're done! And your map should look like this:__

- [Source code](tutorial/13/index.html)
- [View in browser](http://maptime-ams.github.io/animated-borders-d3js/tutorial/13)
- Screenshot:

[![](tutorial/13/screenshot.png)](http://maptime-ams.github.io/animated-borders-d3js/tutorial/13)

## Step 14: Done!

Congratulations, you've made a map with D3.js! Now, go and make another one! Or, make this one a bit better. Some ideas:

- Nicer colors. You could make older or more Eastern states darker, for example.
- Resize the map when the [browser resizes](https://developer.mozilla.org/en-US/docs/Web/API/Window.onresize).
- Use JavaScript to make better functioning state name tooltips.
- Add cities and places. [Natural Earth](http://www.naturalearthdata.com/downloads/10m-cultural-vectors/10m-populated-places/) has some great open data sets available, and you could try to use [Turf](http://turfjs.org/static/docs/)'s [`turf.inside`](http://turfjs.org/static/docs/module-turf_inside.html) function to only display cities in visible states.
- Tell stories! Highlight certain periods and locations, and tell viewers what happened on those moments in time.
