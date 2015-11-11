var Handlebars = require('handlebars');
module.exports = function(src, alt) {
  return new Handlebars.SafeString('<img src="/assets/images/' + src + '" alt="' + alt + '"/>');
}
