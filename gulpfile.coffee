gulp = require 'gulp'
panini = require 'panini'

paniniConfig =
  layouts: 'source/layouts/'
  partials: 'source/partials/**/*.html'
  data: 'source/data/**/*.{json,yml}'
  helpers: 'helpers/**/*.js'

gulp.task 'default', ->
  gulp.src('source/templates/**/*.html')
    .pipe(panini(paniniConfig))
    .pipe gulp.dest('build')
  return
