p5       = require 'p5'
p5.dom   = require 'p5/lib/addons/p5.dom'
p5.sound = require 'p5/lib/addons/p5.sound'


new p5 (sketch) ->

    # superscoping
    capture = undefined
    mic     = undefined
    fft     = undefined

    sketch.setup = ->
        sketch.createCanvas(640, 420)

        capture = sketch.createCapture(sketch.VIDEO)
        capture.size(320, 240)
        capture.hide()

        mic = new p5.AudioIn()
        mic.start()

        fft = new p5.FFT()
        fft.setInput( mic )


    sketch.draw = ->
        sketch.background(0)

        # console.log mic.getLevel()

        stepSize  = 12
        specArray = []

        spectrum = fft.analyze()

        sketch.stroke('red')
        sketch.noFill()


        sketch.beginShape()
        i = 0
        while i < spectrum.length
            vy = sketch.map(spectrum[i], 0, 255, sketch.height, 0)
            # sketch.vertex( i, vy )
            if (i-6) % stepSize is 0
                 specArray.push( vy )
            i++
        sketch.endShape()

        # console.log(specArray)


        sketch.fill('white')
        sketch.noStroke()

        capture.loadPixels()

        y = 0
        while y < sketch.height
            x = 0
            while x < sketch.width
                i = y * sketch.width + x
                darkness = (255 - (capture.pixels[i * 4])) / 255
                radius = stepSize * darkness

                currentSpec = specArray[x / stepSize]

                if (currentSpec - stepSize) <= y and (currentSpec + stepSize) >= y
                    sketch.fill('red')
                else
                    sketch.fill('white')

                sketch.ellipse(x, y, radius, radius)

                # console.log( specArray[x / stepSize] )

                x += stepSize
            y += stepSize




