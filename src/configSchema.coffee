module.exports =
  polyfill:
    type: [String, Boolean]
    default: "document-register-element"
    desc: "Name of the custom elements polyfill to load"
  plugins:
    type: Array
    default: []
    desc: "Ceri plugins to load"