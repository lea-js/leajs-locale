{test, prepare, Promise, getTestID} = require "snapy"
try
  Lea = require "leajs-server/src/lea"
catch
  Lea = require "leajs-server"
http = require "http"

require "../src/plugin"

port = => 8081 + getTestID()

request = (path = "/", headers = {}) =>
  filter: "headers,statusCode,-headers.date,-headers.last-modified,body"
  stream: "":"body"
  
  promise: new Promise (resolve, reject) =>
    http.get Object.assign({
      hostname: "localhost"
      port: port()
      agent: false
      headers: headers
      }, {path: path}), resolve
    .on "error", reject
  plain: true


prepare (state, cleanUp) =>
  lea = await Lea
    config: Object.assign (state or {}), {
      listen:
        port:port()
      disablePlugins: ["leajs-locale"]
      plugins: ["./src/plugin"]
      respond: (req) =>
        req.body = req.locale
      }
  cleanUp => lea.close()

test {locale:["en","de"]}, (snap) =>
  # default: en
  snap request("/")
  # header: de
  snap request("/", "accept-language": "de")

test {locale:{available: ["en","de"], url:1}}, (snap) =>
  # url: de
  snap request("/de")

test {locale:{available: ["en","de"], query:"lang"}}, (snap) =>
  # query: de
  snap request("/?lang=de")

