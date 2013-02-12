

class properties


  string: (styleprovider, glyphspec, attrname) ->
    default_value = styleprovider.mget(attrname)

    if not (attrname of glyphspec)
      if _.isString(default_value)
        @[attrname] = {value: default_value}
      else if _.isObject(default_value)
        @[attrname] = default_value
      else
        console.log("string property'#{ attrname }' given invalid default value: " + default_value)
      return

    glyph_value = glyphspec[attrname]
    if _.isString(glyph_value)
      @[attrname] = {value: glyph_value}
    else if _.isObject(glyph_value)
      @[attrname] = glyph_value
      if not @[attrname].default?
        @[attrname].default = default_value
      console.log @[attrname]
    else
      console.log("string property'#{ attrname }' given invalid glyph value: " + glyph_value)

  number: (styleprovider, glyphspec, attrname) ->
    default_value = styleprovider.mget(attrname)
    default_units = styleprovider.mget(attrname+"_units") ? 'data'

    if not (attrname of glyphspec)
      if _.isString(default_value)
        @[attrname] = {field: default_value, units: default_units} # no default value
      else if _.isNumber(default_value)
        @[attrname] = {value: default_value, units: default_units}
      else if _.isObject(default_value)
        @[attrname] = default_value
        if not @[attrname].units?
          @[attrname].units = default_units
      else
        console.log("number property'#{ attrname }' given invalid default value: " + default_value)
      return

    glyph_value = glyphspec[attrname]
    if _.isString(glyph_value)
      @[attrname] = {field: glyph_value, default: default_value, units: default_units}
    else if _.isNumber(glyph_value)
      @[attrname] = {value: glyph_value, units: default_units}
    else if _.isObject(glyph_value)
      @[attrname] = glyph_value
      if not @[attrname].default?
        @[attrname].default = default_value
      if not @[attrname].units?
        @[attrname].units = default_units
    else
      console.log("number property'#{ attrname }' given invalid glyph value: " + glyph_value)

  color: (styleprovider, glyphspec, attrname) ->
    default_value = styleprovider.mget(attrname)

    if not (attrname of glyphspec)
      if _.isString(default_value) or _.isNull(default_value)
        @[attrname] = {value: default_value}
      else if _.isObject(default_value)
        @[attrname] = default_value
      else
        console.log("color property'#{ attrname }' given invalid default value: " + default_value)
      return

    glyph_value = glyphspec[attrname]
    if _.isString(glyph_value) or _.isNull(glyph_value)
      @[attrname] = {value: glyph_value}
    else if _.isObject(glyph_value)
      @[attrname] = glyph_value
      if not @[attrname].default?
        @[attrname].default = default_value
    else
      console.log("color property'#{ attrname }' given invalid glyph value: " + glyph_value)

  array: (styleprovider, glyphspec, attrname) ->
    default_value = styleprovider.mget(attrname)
    default_units = styleprovider.mget(attrname+"_units") ? 'data'

    if not (attrname of glyphspec)
      if _.isString(default_value)
        @[attrname] = {field: default_value, units: default_units} # no default value
      else if _.isArray(default_value)
        @[attrname] = {value: default_value, units: default_units}
      else if _.isObject(default_value)
        @[attrname] = default_value
      else
        console.log("array property'#{ attrname }' given invalid default value: " + default_value)
      return

    glyph_value = glyphspec[attrname]
    if _.isString(glyph_value)
      @[attrname] = {field: glyph_value, default: default_value, units: default_units}
    else if _.isArray(glyph_value)
      @[attrname] = {value: glyph_value, units: default_units}
    else if _.isObject(glyph_value)
      @[attrname] = glyph_value
      if not @[attrname].default?
        @[attrname].default = default_value
    else
      console.log("array property'#{ attrname }' given invalid glyph value: " + glyph_value)

  enum: (styleprovider, glyphspec, attrname, vals) ->
    default_value = styleprovider.mget(attrname)
    levels_value = vals.split(" ")

    if not (attrname of glyphspec)
      if _.isString(default_value)
        if default_value in levels_value
          @[attrname] = {value: default_value}
        else
          @[attrname] = {field: default_value} # no default value
      else if _.isObject(default_value)
        @[attrname] = default_value
      else
        console.log("enum property'#{ attrname }' given invalid default value: " + default_value)
        console.log("    acceptable values:" + levels_value)
      return

    glyph_value = glyphspec[attrname]
    if _.isString(glyph_value)
      if glyph_value in levels_value
        @[attrname] = {value: glyph_value}
      else
        @[attrname] = {field: glyph_value, default: default_value}
    else if _.isObject(glyph_value)
      @[attrname] = glyph_value
      if not @[attrname].default?
        @[attrname].default = default_value
    else
      console.log("enum property'#{ attrname }' given invalid glyph value: " + glyph_value)
      console.log("    acceptable values:" + levels_value)

  setattr: (styleprovider, glyphspec, attrname, attrtype) ->
    values = null
    if attrtype.indexOf(":") > -1
      [attrtype, values] = attrtype.split(":")

    if      attrtype == "string" then @string(styleprovider, glyphspec, attrname)
    else if attrtype == "number" then @number(styleprovider, glyphspec, attrname)
    else if attrtype == "color"  then @color(styleprovider, glyphspec, attrname)
    else if attrtype == "array"  then @array(styleprovider, glyphspec, attrname)
    else if attrtype == "enum" and values
      @enum(styleprovider, glyphspec, attrname, values)
    else
      console.log("Unknown type '#{ attrtype }' for glyph property: " + attrname)

  select: (attrname, obj) ->
    if not (attrname of @)
      console.log("requested unknown property '#{ attrname } on object: " + obj)
      return
    if @[attrname].field?
      if (@[attrname].field of obj)
        return obj[@[attrname].field]
      else if @[attrname].default?
        return @[attrname].default
    if obj[attrname]
      return obj[attrname]
    if @[attrname].value?
      return @[attrname].value
    else
      console.log "UNK", attrname, @, obj


class line_properties extends properties
  constructor: (styleprovider, glyphspec, prefix="") ->
    @line_color_name = "#{ prefix }line_color"
    @line_width_name = "#{ prefix }line_width"
    @line_alpha_name = "#{ prefix }line_alpha"
    @line_join_name  = "#{ prefix }line_join"
    @line_cap_name   = "#{ prefix }line_cap"
    @line_dash_name  = "#{ prefix }line_dash"

    @color(styleprovider, glyphspec, @line_color_name)
    @number(styleprovider, glyphspec, @line_width_name)
    @number(styleprovider, glyphspec, @line_alpha_name)
    @enum(styleprovider, glyphspec, @line_join_name, "miter round bevel")
    @enum(styleprovider, glyphspec, @line_cap_name, "butt round square")
    @array(styleprovider, glyphspec, @line_dash_name)

    @do_stroke = not (@line_color.value == null)

  set: (ctx, obj) ->
    ctx.strokeStyle = @select(@line_color_name, obj)
    ctx.globalAlpha = @select(@line_alpha_name, obj)
    ctx.lineWidth   = @select(@line_width_name, obj)
    ctx.lineJoin    = @select(@line_join_name,  obj)
    ctx.lineCap     = @select(@line_cap_name,   obj)
    ctx.setLineDash(@select(@line_dash_name, obj))
    # dash offset/phase unimplemented



class fill_properties extends properties
  constructor: (styleprovider, glyphspec, prefix="") ->
    @fill_name       = "#{ prefix }fill"
    @fill_alpha_name = "#{ prefix }fill_alpha"

    @color(styleprovider, glyphspec, @fill_name)
    @number(styleprovider, glyphspec, @fill_alpha_name)

    @do_fill = not (@fill.value == null)

  set: (ctx, obj) ->
    ctx.fillStyle   = @select(@fill_name,       obj)
    ctx.globalAlpha = @select(@fill_alpha_name, obj)



class text_properties extends properties
  constructor: (styleprovider, glyphspec, prefix="") ->
    @text_font_name       = "#{ prefix }text_font"
    @text_font_size_name  = "#{ prefix }text_font_size"
    @text_font_style_name = "#{ prefix }text_font_style"
    @text_color_name      = "#{ prefix }text_color"
    @text_alpha_name      = "#{ prefix }text_alpha"
    @text_align_name      = "#{ prefix }text_align"
    @text_baseline_name   = "#{ prefix }text_baseline"

    @string(styleprovider, glyphspec, @text_font_name)
    @string(styleprovider, glyphspec, @text_font_size_name)
    @string(styleprovider, glyphspec, @text_font_style_name)
    @color(styleprovider, glyphspec, @text_color_name)
    @number(styleprovider, glyphspec, @text_alpha_name)
    @enum(styleprovider, glyphspec, @text_align_name, "left right center")
    @enum(styleprovider, glyphspec, @text_baseline_name, "top middle bottom")

  set: (ctx, obj) ->
    font       = @select(@text_font_name,       obj)
    font_size  = @select(@text_font_size_name,  obj)
    font_style = @select(@text_font_style_name, obj)

    ctx.font         = font_style + " " + font_size + " " + font
    ctx.fillStyle    = @select(@text_color_name,    obj)
    ctx.globalAlpha  = @select(@text_alpha_name,    obj)
    ctx.textAlign    = @select(@text_align_name,    obj)
    ctx.textBaseline = @select(@text_baseline_name, obj)



class Glyph extends properties
  constructor: (styleprovider, glyphspec, attrnames, properties) ->
    for attrname in attrnames
      attrtype = "number"
      if attrname.indexOf(":") > -1
        [attrname, attrtype] = attrname.split(":")
      @setattr(styleprovider, glyphspec, attrname, attrtype)

    for prop in properties
      @[prop.name] = new prop(styleprovider, glyphspec)

    # TODO auto detect fast path cases
    @fast_path = false
    if ('fast_path' of glyphspec)
      @fast_path = glyphspec.fast_path



exports.Glyph = Glyph
exports.fill_properties = fill_properties
exports.line_properties = line_properties
exports.text_properties = text_properties

