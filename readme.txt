Original text in
https://svn.freepascal.org/cgi-bin/viewvc.cgi/trunk/demo/modex/voxel.pp?view=co&revision=3&root=fpcbuild

    This program is part of the FPC demoes.
    Copyright (C) 1999 by Marco van de Voort

    A port of a more "dirty" graphical program, to demonstrate
    some Go32 features. The program displays a landscape in which
    you can move with the cursorkeys

    See the file COPYING.FPC, included in this distribution,
    for details about the copyright.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

 **********************************************************************

The sources for this game was found in SWAG, and was also posted to the
International FIDO Pascal area.
I assume that it is PD (both sources said nothing about the form of copyrights,
but it was contributed to SWAG, which is generally PD)

If there is somebody that claims authorship of these programs,
please mail marco@freepascal.org, and the sources will be removed from our
websites.

------------------------------------------------------------------------
There was no real original, I reconstructed some from several versions.

A voxel source from Swag patched for FPC.

- The original author was unknown. I saw a different version which named
  "Borek" (Marcin Borkowski), 2:480/25  as author.
- Bas van Gaalen donated it to SWAG.
- I, Marco van de Voort made some small FPC adjustments.
- However one problem remained (wrapping of arrays), and Jonas Maebe mailed me
   that glitch to me. This practically meant putting all those WORD()
   typecasts in the array-parameters.
