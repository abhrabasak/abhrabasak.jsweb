gulp = require 'gulp'
_ = require 'underscore'
connect = require 'gulp-connect'
sass = (require 'gulp-sass')(require 'sass')
coffee = require 'gulp-coffee'
concat = require 'gulp-concat'
rename = require 'gulp-rename'
frontmatter = require 'gulp-front-matter'
hb = require 'gulp-hb'
path = require 'path'
layout = require 'gulp-layout'
del = require 'del'
panini = require 'panini'
# tHelpers = require 'template-helpers'
hbsHelpers = (require 'handlebars-helpers')()

config =
  coffee:
    bare: true

gulp.task 'panini', ->
  gulp.src 'source/templates/**/*.html'
    .pipe panini  # https://github.com/zurb/panini
      layouts: 'source/layouts/'
      partials: 'source/partials/**/*.html'
      data: 'source/data/**/*.{json,yml}'
      helpers: 'source/helpers/*.js'
    .pipe gulp.dest 'build'
    .pipe connect.reload()

gulp.task 'html', ->
  gulp.src 'source/templates/**/*.hbs'
    .pipe frontmatter
      property: 'data'
      remove: true
    .pipe hb({ debug: true }) # https://github.com/shannonmoeller/gulp-hb
      .partials 'source/partials/**/*.hbs',
        parsePartialName: (o, f) -> path.basename(f.path, path.extname(f.path))
      .partials 'source/layouts/*.hbs'
      .data 'source/data/**/*.{json,yml}'
      .helpers 'source/helpers/*.js'
      # .helpers tHelpers # http://jonschlinkert.github.io/template-helpers
      .helpers hbsHelpers # https://github.com/helpers/handlebars-helpers
    .pipe rename
      extname: '.html'
    .pipe gulp.dest 'build'
    .pipe connect.reload()

gulp.task 'sass', ->
  gulp.src ['source/assets/styles/*.scss']
    .pipe sass # https://sass-lang.com/documentation/js-api/interfaces/options/
      loadPaths: ['source/bower/foundation/scss']
      style: 'expanded'
      sourceComments: true # Unsupported: https://github.com/sass/node-sass#options
    .pipe gulp.dest 'build/assets/styles'
    .pipe connect.reload()

gulp.task 'scripts', ->
  gulp.src ['source/bower/foundation/js/vendor/{modernizr,jquery}.js']
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
  gulp.watch ['source/**/*.hbs', 'source/**/*.json'], (gulp.series 'html')
  gulp.watch ['source/assets/styles/*.scss'], (gulp.series 'sass')
  gulp.watch ['source/assets/scripts/*.coffee'], (gulp.series 'coffee')
  gulp.watch ['source/assets/images/**/*.*'], (gulp.series 'images')

gulp.task 'clean', (cb)->
  del.deleteSync ['build']
  cb()

gulp.task 'build', (gulp.parallel 'html', 'sass', 'scripts', 'coffee', 'images')
gulp.task 'default', (gulp.series 'build', 'connect', 'watch')
