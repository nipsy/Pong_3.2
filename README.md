# Pong_3.2

## About

This was inspired by the demise of the Pong example in older
versions of Godot and was my first project using Godot or really
any game engine for that matter.

I wanted a basic game which leveraged as many features of Godot
as I had learned while still trying to minimize the amount of
scripting needed.  My hope is that it will help some other people
just learning Godot for the first time to wrap their head around
some concepts.

Having said that, I'm open to pull requests if there are some
other Godot-isms or even basic programming approaches which will
simplify this any further.  I'm not looking to add a bunch of
crazy functionality to this, but it would be nice to keep it
updated from one version to the next as features change if it
makes sense to do so and simplifies the design further.

## Running

You should be able to import this as a project in Godot and
immediately run it with F5.  The default input mappings use the
D-pad on the first and second detected joysticks or W+A and
Up+Down on the keyboard for left and right player respectively.
You can mix and match as desired and Godot even handles hot
plugging a joystick correctly mid-game.

The ball increases in speed up to a certain threshold to try to
prevent a stalemate.  The first player to reach eleven points
"wins" at which point, the game resets.  Press F8 to exit.

The game isn't supposed to be an exact replica of the original,
but I think most of the ideas in use are faithful to it.
