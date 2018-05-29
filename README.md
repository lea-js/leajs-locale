# leajs-locale

Plugin of [leajs](https://github.com/lea-js/leajs-server).

Simplifies handling locale header.

## leajs.config

```js
module.exports = {

  // …

  // Locale options, can be used as a shortcut for 'locale.available'
  locale: null, // [Object, Array]

  // Available languages, first languages is fallback
  locale.available: null, // Array

  // Query property to overwrite browser language
  locale.query: null, // String

  // Position in url to look for used language
  locale.url: null, // Number

  // …

}
```

## Example

```js
module.exports = {

  // …

  locale: {
    available: ["en","de"],
    query: "lang", // will allow ?lang=en
    url: "1" // will parse /de/someurl
  }
  
  // …

}
```

## License
Copyright (c) 2018 Paul Pflugradt
Licensed under the MIT license.