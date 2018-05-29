
module.exports = ({init,position}) => 
  init.hookIn position.before, ({config, util: {isArray}}) =>
    if (locale = config.locale)? and isArray(locale)
      config.locale = {available: locale}

  init.hookIn (router) =>
    if (locale = router.config.locale)?
      {
        cache:{save, select}, 
        respond, 
        position
      } = router
      {available, query, url: localePos} = locale

      save.locale = perm: true
      select.push (arr, req) =>
        loc = req.locale
        arr.filter (el) => el.locale == loc
      
      getValid = (lang) =>
        if lang?
          for av in available
            return av if av.startsWith lang
          if ~(i = lang.indexOf("-"))
            lang = lang.slice 0, i
            for av in available
              return av if av.startsWith lang
        return false

      prepare = []
      tester = []
      if query?
        tester.push (req) => getValid(req.getQuery(query))
      if localePos?
        prepare.push (req) =>
          splitted = req.url.split("/")
          req.urlLocale = splitted.splice(localePos,1)[0]
          req.url = splitted.join("/")
        tester.push (req) => getValid(req.urlLocale)
      tester.push (req) =>
        for lang in req.getAccepted "accept-language"
          return selected if (selected = getValid(lang))

      if prepare.length > 0
        respond.hookIn position.init, (req) =>
          for fn in prepare
            fn(req)
      respond.hookIn position.init, (req) =>
        selected = null
        Object.defineProperty req, "locale", get: =>
          return selected if selected
          for fn in tester
            break if (selected = fn(req))
          selected ?= available[0]
          req.head.contentLanguage = selected
          return selected

module.exports.configSchema = require("./configSchema")