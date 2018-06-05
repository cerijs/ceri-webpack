VirtualModulePlugin = require('virtual-module-webpack-plugin')
{resolve} = require "path"
readConf = require "read-conf"
fs = require "fs-extra"
module.exports = (options) =>
  options ?= {}
  options.name ?= "ceri.config"
  {config} = obj = await readConf 
    name: options.name
    folders: ["./build","./"]
    assign: options.config
    schema: resolve(__dirname, "./configSchema")
    concatArrays:true
    required: !options.config?
    base: fs: fs
    plugins:
      paths: [process.cwd(), resolve(__dirname,"..")]
  getLibPath = (filename) => resolve(__dirname,"../lib/#{filename}")
  if pf = config.polyfill
    code = """
      module.exports = new Promise(function(resolve){
        if (!window.customElements){
          require.ensure([], function(require){
            require('#{getLibPath("_ceri-polyfill.js")}');
            resolve()
          })
        } else {
          resolve()
        }
      }).then(function(){
        var ce = window.customElements;
    """
  else
    code = "var ce = window.customElements;"
  styl = ""
  for {plugin} in config.plugins
    result = plugin(obj)
    code += result.code if result.code
    styl += "\n" + result.styl if result.styl
  code = "require('#{getLibPath("_ceri-config.styl")}');" + code if styl
  code += "})" if pf

  files = [
    new VirtualModulePlugin
      path: getLibPath("_ceri-config.js")
      contents: code
  ]
  if styl
    files.push new VirtualModulePlugin
      path: getLibPath("_ceri-config.styl")
      contents: styl
  if pf
    files.push new VirtualModulePlugin
      path: getLibPath("_ceri-polyfill.js")
      contents: await fs.readFile require.resolve(pf), "utf8"

  return files: files, apply: (compiler) =>
      for file in files
        file.apply(compiler)