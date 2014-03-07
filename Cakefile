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
    scripts:
      test: 'mocha --compilers coffee:coffee-script/register'
    dependencies:
      stylus: '>=0.42.3'
      nib: '>=1.0.2'
      browserify: '>=3.31.2'
      coffeeify: '>=0.6.0'
      'uglify-js': '>=2.4.12'
    devDependencies:
      mocha: '>=1.17.1'
      should: '>=3.1.3'
      tmp: '>=0.0.23'
    repository:
      type: 'git'
      url: 'https://github.com/paul-nechifor/web-build-tools'
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
