margin = 
  top: 10
  right: 10
  bottom: 100
  left: 40

margin2 =
  top: 430
  right: 10
  bottom: 20
  left: 40

width = 960 - margin.left - margin.right
height = 500 - margin.top - margin.bottom
height2 = 500 - margin.top - margin.bottom

parseDate = d3.time.formate("%b %Y").parse

x = d3.time.scale().range([0, width])
x2 = d3.time.scale().range([0, width])
y = d3.time.scale().range([height, 0])
y2 = d3.time.scale().range([height2, 0])

xAxis = d3.svg.axis().scale(x).orient("bottom")
xAxis2 = d3.svg.axis().scale(x2).orient("bottom")
yAxis = d3.svg.axis().scale(y).orient("left")

brush = d3.svg.brush()
.x(x2)
.on("brush", brushed)

area = d3.svg.area()
.interpolate("monotone").x((d)->
  xd.date )
.y0(height).y1((d)->
  y d.price )

area2 = d3.svg.area()
.interpolate("monotone").x((d)->
  x2 d.date )
.y0(height2).y1((d)->
  	y2 d.price )

svg = d3.select("body")
.append("svg")
.attr("width", width + margin.left + margin.right)
.attr("height", height + margin.top + margin.bottom)

svg.append("defs").append("clipPath")
.attr("id", "clip")
.append("rect")
.attr("width", width)
.attr("height", height)

focus = svg.append("g")
.attr("class", "focus")
.attr("transform", "translate(" + margin.left + "," + margin.top +")")

context = svg.append("g")
.attr("class", "context")
.attr("transform", "translate(" + margin2.left + "," + margin2.top + ")")

d3.csv "sp500.csv", type, (error, data) ->
  x.domain d3.extent(data.map((d) ->
    d.date ))

  y.domain [
    0
    d3.max(data.map((d) ->
  	  d.price ))
  ]
  focus.append("path")
      .datum(data)
      .attr("class", "area")
      .attr "d", area

  focus.append("g")
      .attr("class", "x axis")
      .attr("transform", "translate(0," + height + ")")
      .call xAxis
  
  focus.append("g")
      .attr("class", "y axis")
      .call yAxis
  
  context.append("path")
      .datum(data)
      .attr("class", "area")
      .attr "d", area2
  
  context.append("g")
      .attr("class", "x axis")
      .attr("transform", "translate(0," + height2 + ")")
      .call xAxis2

  context.append("g")
      .attr("class", "x brush")
      .call(brush)
    .selectAll("rect")
      .attr("y", -6)
      .attr "height", height2 + 7
return

brushed = ->
  x.domain (if brush.empty() then x2.domain() else brush.extent())
  focus.select(".area")
    .attr "d", area
  focus.select(".x.axis")
    .call xAxis
  return


type = (d) ->
  d.date = parseDate(d.date)
  d.price = +d.price
  d