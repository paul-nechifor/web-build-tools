require('coffee-script').register()
wbt = require './src'
{sh, writeJson} = wbt.Build

config =
  packageJson:
    name: 'web-build-tools'
    author: 'Paul Nechifor <paul@nechifor.net>'
    version: '0.0.1'
    private: false
    main: './lib'
    dependencies:
      stylus: '>=0.42.3'
      nib: '>=1.0.2'
      browserify: '>=3.31.2'
      coffeeify: '>=0.6.0'
      'uglify-js': '>=2.4.12'
    license: 'MIT'

cleanupLib = (cb) ->
  sh 'rm -fr lib/; mkdir lib', cb

writePackage = ->
  writeJson 'package.json', config.packageJson

compileCoffee = (cb) ->
  sh 'coffee --compile --bare --output lib src', cb

task 'build', 'Build the Node package.', ->
  cleanupLib ->
    writePackage()
    compileCoffee ->
