gulp = require 'gulp'
panini = require 'panini'
connect = require 'gulp-connect'
sass = require 'gulp-sass'
coffee = require 'gulp-coffee'
concat = require 'gulp-concat'
# gulpHB = require 'gulp-hb'
# layout = require 'gulp-layout'
del = require 'del'
# rename = require 'gulp-rename'
# handlebars = require 'handlebars'
# HandlebarsHelpers = require 'handlebars-helpers'

# HandlebarsHelpers.register(handlebars, {})

config =
  panini: # https://github.com/zurb/panini
    layouts: 'source/layouts/'
    partials: 'source/partials/**/*.html'
    data: 'source/data/**/*.{json,yml}'
    helpers: 'source/helpers/*.js'
  sass: # https://github.com/sass/node-sass#options
    includePaths: ['source/bower/foundation/scss']
    outputStyle: 'expanded'
    sourceComments: true
  coffee:
    bare: true
  gulpHB:
    partials: 'source/partials/**/*.hbs'
    data: 'source/data/**/*.{json,yml}'
    helpers: 'source/helpers/*.js'
  layout:
    layout: 'source/layouts/default.hbs'
    engine: 'handlebars'

gulp.task 'html', ->
  gulp.src 'source/templates/**/*.html'
    .pipe panini config.panini
    .pipe gulp.dest 'build'
    .pipe connect.reload()

gulp.task 'html2', ->
  gulp.src 'source/templates/**/*.hbs'
    .pipe gulpHB config.gulpHB
    .pipe layout config.layout
    .pipe gulp.dest 'build'
    .pipe connect.reload()

gulp.task 'sass', ->
  gulp.src ['source/assets/styles/*.scss']
    .pipe sass config.sass
    .pipe gulp.dest 'build/assets/styles'
    .pipe connect.reload()

gulp.task 'scripts', ->
  gulp.src ['source/bower/foundation/js/vendor/modernizr.js', 'source/bower/foundation/js/vendor/jquery.js']
    .pipe concat 'app.js'
    .pipe gulp.dest 'build/assets/scripts/'

gulp.task 'coffee', ->
  gulp.src ['source/assets/scripts/*.coffee']
    .pipe coffee()
    .pipe gulp.dest 'build/assets/scripts'
    .pipe connect.reload()

gulp.task 'images', ->
  gulp.src ['source/assets/images/**/*.*']
    .pipe gulp.dest 'build/assets/images'
    .pipe connect.reload()

gulp.task 'connect', ->
  connect.server
    root: 'build'
    livereload: true

gulp.task 'watch', ->
  gulp.watch ['source/**/*.html'], ['html']
  gulp.watch ['source/assets/styles/*.scss'], ['sass']
  gulp.watch ['source/assets/scripts/*.coffee'], ['coffee']
  gulp.watch ['source/assets/images/**/*.*'], ['images']

gulp.task 'clean', (cb)->
  del ['build'], cb

gulp.task 'build', ['html', 'sass', 'scripts', 'coffee', 'images']
gulp.task 'default', ['build', 'connect', 'watch']
