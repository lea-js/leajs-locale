module.exports =
  locale: 
    types: [Object, Array]
    desc: "Locale options, can be used as a shortcut for 'locale.available'"
  locale$available:
    type: Array
    desc: "Available languages, first languages is fallback"
  locale$query:
    type: String
    desc: "Query property to overwrite browser language"
  locale$url:
    type: Number
    desc: "Position in url to look for used language"