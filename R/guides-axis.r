# Grob axis
# Grob for axes
# 
# @arguments position of ticks
# @arguments labels at ticks
# @arguments position of axis (top, bottom, left or right)
# @arguments range of data values
# @keyword hplot 
# @keyword internal
guide_axis <- function(at, labels, position="right", theme) {
  position <- match.arg(position, c("top", "bottom", "right", "left"))
  
  at <- unit(at, "native")
  length <- theme$axis.ticks.length
  label_pos <- length + theme$axis.ticks.margin
  one <- unit(1, "npc")
  
  label_render <- switch(position,
    top = , bottom = "axis.text.x",
    left = , right = "axis.text.y"
  )
  label_x <- switch(position,
    top = , 
    bottom = at,
    right = label_pos,
    left = one - label_pos
  )
  label_y <- switch(position,
    top = label_pos, 
    bottom = one - label_pos,
    right = ,
    left = at,
  )
  
  if (is.language(labels[[1]])) {
    labels <- do.call(expression, labels)
  } else {
    labels <- unlist(labels)    
  }
  labels <- theme_render(theme, label_render, labels, label_x, label_y)
  
  ticks <- switch(position,
    top =    theme_render(theme, "axis.ticks.x", at, 0, at, length),
    bottom = theme_render(theme, "axis.ticks.x", at, one - length, at, 1),
    right =  theme_render(theme, "axis.ticks.y", 0, at, length, at),
    left =   theme_render(theme, "axis.ticks.y", one - length, at, 1, at)
  )
    
  absoluteGrob(
    grobTree(ticks, labels),
    width = grobWidth(labels) + label_pos,
    height = grobHeight(labels) + label_pos
  )  
}