Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755968Ab0JOCjA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 22:39:00 -0400
Received: from www.telegraphics.com.au ([204.15.192.19]:33057 "EHLO
	mail.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753276Ab0JOCi7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 22:38:59 -0400
Date: Fri, 15 Oct 2010 13:38:47 +1100 (EST)
From: Finn Thain <fthain@telegraphics.com.au>
To: "Justin P. Mattock" <justinmattock@gmail.com>
cc: trivial@kernel.org, linux-kernel@vger.kernel.org,
        Jiri Kosina <jkosina@suse.cz>
Subject: Re: [RFC v5]Update broken web addresses in arch directory.
In-Reply-To: <4CB7AD50.2010103@gmail.com>
Message-ID: <alpine.OSX.2.00.1010151328510.283@localhost>
References: <1286225296-10070-1-git-send-email-justinmattock@gmail.com> <alpine.OSX.2.00.1010051146260.289@localhost> <4CB7AD50.2010103@gmail.com>
User-Agent: Alpine 2.00 (OSX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="0-2033526450-1287109769=:283"
Content-ID: <alpine.OSX.2.00.1010151335520.283@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--0-2033526450-1287109769=:283
Content-Type: TEXT/PLAIN; CHARSET=ISO-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Content-ID: <alpine.OSX.2.00.1010151335521.283@localhost>


On Thu, 14 Oct 2010, Justin P. Mattock wrote:

> hey jiri, whats the status of this? do you want to take this?
> if so should I rebase the two patches to the current?

The other patch needs to be resubmitted. Please see:

http://groups.google.com.au/group/linux.kernel/msg/ce349d502567ebc4

Finn

>=20
>=20
> >=20
> > Thanks, Justin. Looks good to me.
> >=20
> > Jiri, feel free to add my "reviewed-by" tag.
> >=20
> > Finn
> >=20
> > On Mon, 4 Oct 2010, Justin P. Mattock wrote:
> >=20
> > > Below is an updated patch to fix broken web addresses in the arch
> > > directory.
> > > Please let me know if I missed anything.(and Thank you vary much for
> > > taking
> > > the time to look at this..)
> > >=20
> > > Signed-off-by: Justin P. Mattock<justinmattock@gmail.com>
> > > Signed-off-by: Maciej W. Rozycki<macro@linux-mips.org>
> > > Cc: Finn Thain<fthain@telegraphics.com.au>
> > > Cc: Randy Dunlap<rdunlap@xenotime.net>
> > >=20
> > > ---
> > >   arch/arm/Kconfig                         |    2 +-
> > >   arch/arm/common/icst.c                   |    2 +-
> > >   arch/arm/include/asm/hardware/icst.h     |    2 +-
> > >   arch/arm/mach-at91/Kconfig               |    6 +++---
> > >   arch/arm/mach-omap1/Kconfig              |    2 +-
> > >   arch/arm/mach-pxa/am200epd.c             |    2 +-
> > >   arch/arm/mach-pxa/am300epd.c             |    2 +-
> > >   arch/arm/mach-s3c2440/mach-at2440evb.c   |    2 +-
> > >   arch/arm/mach-sa1100/Kconfig             |    6 +++---
> > >   arch/arm/mach-sa1100/cpu-sa1100.c        |    2 +-
> > >   arch/arm/nwfpe/milieu.h                  |    4 ++--
> > >   arch/arm/nwfpe/softfloat-macros          |    4 ++--
> > >   arch/arm/nwfpe/softfloat-specialize      |    4 ++--
> > >   arch/arm/nwfpe/softfloat.c               |    4 ++--
> > >   arch/arm/nwfpe/softfloat.h               |    4 ++--
> > >   arch/arm/plat-samsung/include/plat/adc.h |    2 +-
> > >   arch/avr32/Kconfig                       |    2 +-
> > >   arch/h8300/Kconfig.cpu                   |    8 ++++----
> > >   arch/h8300/README                        |    1 +
> > >   arch/m32r/Kconfig                        |    2 +-
> > >   arch/m68k/mac/macboing.c                 |    3 ++-
> > >   arch/m68k/q40/README                     |    2 +-
> > >   arch/mips/Kconfig                        |   12 ++++++++----
> > >   arch/mips/math-emu/cp1emu.c              |    1 -
> > >   arch/mips/math-emu/dp_add.c              |    1 -
> > >   arch/mips/math-emu/dp_cmp.c              |    1 -
> > >   arch/mips/math-emu/dp_div.c              |    1 -
> > >   arch/mips/math-emu/dp_fint.c             |    1 -
> > >   arch/mips/math-emu/dp_flong.c            |    1 -
> > >   arch/mips/math-emu/dp_frexp.c            |    1 -
> > >   arch/mips/math-emu/dp_fsp.c              |    1 -
> > >   arch/mips/math-emu/dp_logb.c             |    1 -
> > >   arch/mips/math-emu/dp_modf.c             |    1 -
> > >   arch/mips/math-emu/dp_mul.c              |    1 -
> > >   arch/mips/math-emu/dp_scalb.c            |    1 -
> > >   arch/mips/math-emu/dp_simple.c           |    1 -
> > >   arch/mips/math-emu/dp_sqrt.c             |    1 -
> > >   arch/mips/math-emu/dp_sub.c              |    1 -
> > >   arch/mips/math-emu/dp_tint.c             |    1 -
> > >   arch/mips/math-emu/dp_tlong.c            |    1 -
> > >   arch/mips/math-emu/ieee754.c             |    1 -
> > >   arch/mips/math-emu/ieee754.h             |    1 -
> > >   arch/mips/math-emu/ieee754d.c            |    1 -
> > >   arch/mips/math-emu/ieee754dp.c           |    1 -
> > >   arch/mips/math-emu/ieee754dp.h           |    1 -
> > >   arch/mips/math-emu/ieee754int.h          |    1 -
> > >   arch/mips/math-emu/ieee754m.c            |    1 -
> > >   arch/mips/math-emu/ieee754sp.c           |    1 -
> > >   arch/mips/math-emu/ieee754sp.h           |    1 -
> > >   arch/mips/math-emu/ieee754xcpt.c         |    1 -
> > >   arch/mips/math-emu/sp_add.c              |    1 -
> > >   arch/mips/math-emu/sp_cmp.c              |    1 -
> > >   arch/mips/math-emu/sp_div.c              |    1 -
> > >   arch/mips/math-emu/sp_fdp.c              |    1 -
> > >   arch/mips/math-emu/sp_fint.c             |    1 -
> > >   arch/mips/math-emu/sp_flong.c            |    1 -
> > >   arch/mips/math-emu/sp_frexp.c            |    1 -
> > >   arch/mips/math-emu/sp_logb.c             |    1 -
> > >   arch/mips/math-emu/sp_modf.c             |    1 -
> > >   arch/mips/math-emu/sp_mul.c              |    1 -
> > >   arch/mips/math-emu/sp_scalb.c            |    1 -
> > >   arch/mips/math-emu/sp_simple.c           |    1 -
> > >   arch/mips/math-emu/sp_sqrt.c             |    1 -
> > >   arch/mips/math-emu/sp_sub.c              |    1 -
> > >   arch/mips/math-emu/sp_tint.c             |    1 -
> > >   arch/mips/math-emu/sp_tlong.c            |    1 -
> > >   arch/powerpc/include/asm/hydra.h         |    2 +-
> > >   arch/x86/kernel/apm_32.c                 |    4 ++--
> > >   arch/x86/kernel/microcode_core.c         |    2 +-
> > >   arch/x86/kernel/microcode_intel.c        |    2 +-
> > >   70 files changed, 48 insertions(+), 85 deletions(-)
> > >=20
> > > diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
> > > index 88c97bc..b79dad3 100644
> > > --- a/arch/arm/Kconfig
> > > +++ b/arch/arm/Kconfig
> > > @@ -1187,7 +1187,7 @@ config SMP
> > >=20
> > >   =09  See also<file:Documentation/i386/IO-APIC.txt>,
> > >   =09<file:Documentation/nmi_watchdog.txt>  and the SMP-HOWTO availab=
le at
> > > -=09<http://www.linuxdoc.org/docs.html#howto>.
> > > +=09<http://tldp.org/HOWTO/SMP-HOWTO.html>.
> > >=20
> > >   =09  If you don't know what to do here, say N.
> > >=20
> > > diff --git a/arch/arm/common/icst.c b/arch/arm/common/icst.c
> > > index 9a7f09c..2dc6da70 100644
> > > --- a/arch/arm/common/icst.c
> > > +++ b/arch/arm/common/icst.c
> > > @@ -8,7 +8,7 @@
> > >    * published by the Free Software Foundation.
> > >    *
> > >    *  Support functions for calculating clocks/divisors for the ICST3=
07
> > > - *  clock generators.  See http://www.icst.com/ for more information
> > > + *  clock generators.  See http://www.idt.com/ for more information
> > >    *  on these devices.
> > >    *
> > >    *  This is an almost identical implementation to the ICST525 clock
> > > generator.
> > > diff --git a/arch/arm/include/asm/hardware/icst.h
> > > b/arch/arm/include/asm/hardware/icst.h
> > > index 10382a3..794220b 100644
> > > --- a/arch/arm/include/asm/hardware/icst.h
> > > +++ b/arch/arm/include/asm/hardware/icst.h
> > > @@ -8,7 +8,7 @@
> > >    * published by the Free Software Foundation.
> > >    *
> > >    *  Support functions for calculating clocks/divisors for the ICST
> > > - *  clock generators.  See http://www.icst.com/ for more information
> > > + *  clock generators.  See http://www.idt.com/ for more information
> > >    *  on these devices.
> > >    */
> > >   #ifndef ASMARM_HARDWARE_ICST_H
> > > diff --git a/arch/arm/mach-at91/Kconfig b/arch/arm/mach-at91/Kconfig
> > > index 939bccd..e5be994 100644
> > > --- a/arch/arm/mach-at91/Kconfig
> > > +++ b/arch/arm/mach-at91/Kconfig
> > > @@ -105,7 +105,7 @@ config MACH_ONEARM
> > >   =09bool "Ajeco 1ARM Single Board Computer"
> > >   =09help
> > >   =09  Select this if you are using Ajeco's 1ARM Single Board Compute=
r.
> > > -=09<http://www.ajeco.fi/products.htm>
> > > +=09<http://www.ajeco.fi/>
> > >=20
> > >   config ARCH_AT91RM9200DK
> > >   =09bool "Atmel AT91RM9200-DK Development board"
> > > @@ -137,7 +137,7 @@ config MACH_CARMEVA
> > >   =09bool "Conitec ARM&EVA"
> > >   =09help
> > >   =09  Select this if you are using Conitec's AT91RM9200-MCU-Module.
> > > -=09<http://www.conitec.net/english/linuxboard.htm>
> > > +=09<http://www.conitec.net/english/linuxboard.php>
> > >=20
> > >   config MACH_ATEB9200
> > >   =09bool "Embest ATEB9200"
> > > @@ -149,7 +149,7 @@ config MACH_KB9200
> > >   =09bool "KwikByte KB920x"
> > >   =09help
> > >   =09  Select this if you are using KwikByte's KB920x board.
> > > -=09<http://kwikbyte.com/KB9202_description_new.htm>
> > > +=09<http://www.kwikbyte.com/KB9202.html>
> > >=20
> > >   config MACH_PICOTUX2XX
> > >   =09bool "picotux 200"
> > > diff --git a/arch/arm/mach-omap1/Kconfig b/arch/arm/mach-omap1/Kconfi=
g
> > > index 3b02d3b..5f64963 100644
> > > --- a/arch/arm/mach-omap1/Kconfig
> > > +++ b/arch/arm/mach-omap1/Kconfig
> > > @@ -128,7 +128,7 @@ config MACH_OMAP_PALMTT
> > >   =09help
> > >   =09  Support for the Palm Tungsten|T PDA. To boot the kernel, you'l=
l
> > >   =09  need a PalmOS compatible bootloader (Garux); check out
> > > -=09  http://www.hackndev.com/palm/tt/ for more information.
> > > +=09  http://garux.sourceforge.net/ for more information.
> > >   =09  Say Y here if you have this PDA model, say N otherwise.
> > >=20
> > >   config MACH_SX1
> > > diff --git a/arch/arm/mach-pxa/am200epd.c b/arch/arm/mach-pxa/am200ep=
d.c
> > > index 3499fad..0fd6a08 100644
> > > --- a/arch/arm/mach-pxa/am200epd.c
> > > +++ b/arch/arm/mach-pxa/am200epd.c
> > > @@ -10,7 +10,7 @@
> > >    * Layout is based on skeletonfb.c by James Simmons and Geert
> > > Uytterhoeven.
> > >    *
> > >    * This work was made possible by help and equipment support from E=
-Ink
> > > - * Corporation. http://support.eink.com/community
> > > + * Corporation. http://www.support.eink.com/
> > >    *
> > >    * This driver is written to be used with the Metronome display
> > > controller.
> > >    * on the AM200 EPD prototype kit/development kit with an E-Ink 800=
x600
> > > diff --git a/arch/arm/mach-pxa/am300epd.c b/arch/arm/mach-pxa/am300ep=
d.c
> > > index 993d75e..01aa021 100644
> > > --- a/arch/arm/mach-pxa/am300epd.c
> > > +++ b/arch/arm/mach-pxa/am300epd.c
> > > @@ -8,7 +8,7 @@
> > >    * more details.
> > >    *
> > >    * This work was made possible by help and equipment support from E=
-Ink
> > > - * Corporation. http://support.eink.com/community
> > > + * Corporation. http://www.support.eink.com/
> > >    *
> > >    * This driver is written to be used with the Broadsheet display
> > > controller.
> > >    * on the AM300 EPD prototype kit/development kit with an E-Ink 800=
x600
> > > diff --git a/arch/arm/mach-s3c2440/mach-at2440evb.c
> > > b/arch/arm/mach-s3c2440/mach-at2440evb.c
> > > index 8472579..67b6ba0 100644
> > > --- a/arch/arm/mach-s3c2440/mach-at2440evb.c
> > > +++ b/arch/arm/mach-s3c2440/mach-at2440evb.c
> > > @@ -5,7 +5,7 @@
> > >    *      and modifications by SBZ<sbz@spgui.org>  and
> > >    *      Weibing<http://weibing.blogbus.com>
> > >    *
> > > - * For product information, visit http://www.arm9e.com/
> > > + * For product information, visit http://www.arm.com/
> > >    *
> > >    * This program is free software; you can redistribute it and/or mo=
dify
> > >    * it under the terms of the GNU General Public License version 2 a=
s
> > > diff --git a/arch/arm/mach-sa1100/Kconfig b/arch/arm/mach-sa1100/Kcon=
fig
> > > index fd4c52b..5da8c35 100644
> > > --- a/arch/arm/mach-sa1100/Kconfig
> > > +++ b/arch/arm/mach-sa1100/Kconfig
> > > @@ -90,8 +90,8 @@ config SA1100_JORNADA720
> > >   =09# FIXME: select CPU_FREQ_SA11x0
> > >   =09help
> > >   =09  Say Y here if you want to build a kernel for the HP Jornada 72=
0
> > > -=09  handheld computer.  See<http://www.hp.com/jornada/products/720>
> > > -=09  for details.
> > > +=09  handheld computer.  See
> > > +
> > > <http://h10025.www1.hp.com/ewfrf/wc/product?product=3D61677&cc=3Dus&l=
c=3Den&dlc=3Den&product=3D61677#>
> > >=20
> > >   config SA1100_JORNADA720_SSP
> > >   =09bool "HP Jornada 720 Extended SSP driver"
> > > @@ -145,7 +145,7 @@ config SA1100_SIMPAD
> > >   =09  FLASH. The SL4 version got 64 MB RAM and 32 MB FLASH and a
> > >   =09  PCMCIA-Slot. The version for the Germany Telecom (DTAG) is the=
 same
> > >   =09  like CL4 in additional it has a PCMCIA-Slot. For more informat=
ion
> > > -=09  visit<http://www.my-siemens.com/>  or<http://www.siemens.ch/>.
> > > +=09  visit<http://www.usa.siemens.com/>  or<http://www.siemens.ch/>.
> > >=20
> > >   config SA1100_SSP
> > >   =09tristate "Generic PIO SSP"
> > > diff --git a/arch/arm/mach-sa1100/cpu-sa1100.c
> > > b/arch/arm/mach-sa1100/cpu-sa1100.c
> > > index ef81787..c0a13ef 100644
> > > --- a/arch/arm/mach-sa1100/cpu-sa1100.c
> > > +++ b/arch/arm/mach-sa1100/cpu-sa1100.c
> > > @@ -13,7 +13,7 @@
> > >    * This software has been developed while working on the LART
> > >    * computing board (http://www.lartmaker.nl/), which is
> > >    * sponsored by the Mobile Multi-media Communications
> > > - * (http://www.mmc.tudelft.nl/) and Ubiquitous Communications
> > > + * (http://www.mobimedia.org/) and Ubiquitous Communications
> > >    * (http://www.ubicom.tudelft.nl/) projects.
> > >    *
> > >    * The authors can be reached at:
> > > diff --git a/arch/arm/nwfpe/milieu.h b/arch/arm/nwfpe/milieu.h
> > > index a3892ab..09a4f2d 100644
> > > --- a/arch/arm/nwfpe/milieu.h
> > > +++ b/arch/arm/nwfpe/milieu.h
> > > @@ -12,8 +12,8 @@ National Science Foundation under grant MIP-9311980=
=2E
> > > The original version
> > >   of this code was written as part of a project to build a fixed-poin=
t
> > > vector
> > >   processor in collaboration with the University of California at
> > > Berkeley,
> > >   overseen by Profs. Nelson Morgan and John Wawrzynek.  More informat=
ion
> > > -is available through the Web page `http://HTTP.CS.Berkeley.EDU/~jhau=
ser/
> > > -arithmetic/softfloat.html'.
> > > +is available through the Web page
> > > +http://www.jhauser.us/arithmetic/SoftFloat-2b/SoftFloat-source.txt
> > >=20
> > >   THIS SOFTWARE IS DISTRIBUTED AS IS, FOR FREE.  Although reasonable
> > > effort
> > >   has been made to avoid it, THIS SOFTWARE MAY CONTAIN FAULTS THAT WI=
LL AT
> > > diff --git a/arch/arm/nwfpe/softfloat-macros
> > > b/arch/arm/nwfpe/softfloat-macros
> > > index 5a060f9..cf2a617 100644
> > > --- a/arch/arm/nwfpe/softfloat-macros
> > > +++ b/arch/arm/nwfpe/softfloat-macros
> > > @@ -12,8 +12,8 @@ National Science Foundation under grant MIP-9311980=
=2E
> > > The original version
> > >   of this code was written as part of a project to build a fixed-poin=
t
> > > vector
> > >   processor in collaboration with the University of California at
> > > Berkeley,
> > >   overseen by Profs. Nelson Morgan and John Wawrzynek.  More informat=
ion
> > > -is available through the web page `http://HTTP.CS.Berkeley.EDU/~jhau=
ser/
> > > -arithmetic/softfloat.html'.
> > > +is available through the web page
> > > +http://www.jhauser.us/arithmetic/SoftFloat-2b/SoftFloat-source.txt
> > >=20
> > >   THIS SOFTWARE IS DISTRIBUTED AS IS, FOR FREE.  Although reasonable
> > > effort
> > >   has been made to avoid it, THIS SOFTWARE MAY CONTAIN FAULTS THAT WI=
LL AT
> > > diff --git a/arch/arm/nwfpe/softfloat-specialize
> > > b/arch/arm/nwfpe/softfloat-specialize
> > > index d4a4c8e..679a026 100644
> > > --- a/arch/arm/nwfpe/softfloat-specialize
> > > +++ b/arch/arm/nwfpe/softfloat-specialize
> > > @@ -12,8 +12,8 @@ National Science Foundation under grant MIP-9311980=
=2E
> > > The original version
> > >   of this code was written as part of a project to build a fixed-poin=
t
> > > vector
> > >   processor in collaboration with the University of California at
> > > Berkeley,
> > >   overseen by Profs. Nelson Morgan and John Wawrzynek.  More informat=
ion
> > > -is available through the Web page `http://HTTP.CS.Berkeley.EDU/~jhau=
ser/
> > > -arithmetic/softfloat.html'.
> > > +is available through the Web page
> > > +http://www.jhauser.us/arithmetic/SoftFloat-2b/SoftFloat-source.txt
> > >=20
> > >   THIS SOFTWARE IS DISTRIBUTED AS IS, FOR FREE.  Although reasonable
> > > effort
> > >   has been made to avoid it, THIS SOFTWARE MAY CONTAIN FAULTS THAT WI=
LL AT
> > > diff --git a/arch/arm/nwfpe/softfloat.c b/arch/arm/nwfpe/softfloat.c
> > > index 0f9656e..ffa6b43 100644
> > > --- a/arch/arm/nwfpe/softfloat.c
> > > +++ b/arch/arm/nwfpe/softfloat.c
> > > @@ -11,8 +11,8 @@ National Science Foundation under grant MIP-9311980=
=2E
> > > The original version
> > >   of this code was written as part of a project to build a fixed-poin=
t
> > > vector
> > >   processor in collaboration with the University of California at
> > > Berkeley,
> > >   overseen by Profs. Nelson Morgan and John Wawrzynek.  More informat=
ion
> > > -is available through the web page `http://HTTP.CS.Berkeley.EDU/~jhau=
ser/
> > > -arithmetic/softfloat.html'.
> > > +is available through the web page
> > > +http://www.jhauser.us/arithmetic/SoftFloat-2b/SoftFloat-source.txt
> > >=20
> > >   THIS SOFTWARE IS DISTRIBUTED AS IS, FOR FREE.  Although reasonable
> > > effort
> > >   has been made to avoid it, THIS SOFTWARE MAY CONTAIN FAULTS THAT WI=
LL AT
> > > diff --git a/arch/arm/nwfpe/softfloat.h b/arch/arm/nwfpe/softfloat.h
> > > index 13e479c..df4d243 100644
> > > --- a/arch/arm/nwfpe/softfloat.h
> > > +++ b/arch/arm/nwfpe/softfloat.h
> > > @@ -12,8 +12,8 @@ National Science Foundation under grant MIP-9311980=
=2E
> > > The original version
> > >   of this code was written as part of a project to build a fixed-poin=
t
> > > vector
> > >   processor in collaboration with the University of California at
> > > Berkeley,
> > >   overseen by Profs. Nelson Morgan and John Wawrzynek.  More informat=
ion
> > > -is available through the Web page `http://HTTP.CS.Berkeley.EDU/~jhau=
ser/
> > > -arithmetic/softfloat.html'.
> > > +is available through the Web page
> > > +http://www.jhauser.us/arithmetic/SoftFloat-2b/SoftFloat-source.txt
> > >=20
> > >   THIS SOFTWARE IS DISTRIBUTED AS IS, FOR FREE.  Although reasonable
> > > effort
> > >   has been made to avoid it, THIS SOFTWARE MAY CONTAIN FAULTS THAT WI=
LL AT
> > > diff --git a/arch/arm/plat-samsung/include/plat/adc.h
> > > b/arch/arm/plat-samsung/include/plat/adc.h
> > > index e8382c7..b258a08 100644
> > > --- a/arch/arm/plat-samsung/include/plat/adc.h
> > > +++ b/arch/arm/plat-samsung/include/plat/adc.h
> > > @@ -1,7 +1,7 @@
> > >   /* arch/arm/plat-samsung/include/plat/adc.h
> > >    *
> > >    * Copyright (c) 2008 Simtec Electronics
> > > - *=09http://armlinux.simnte.co.uk/
> > > + *=09http://armlinux.simtec.co.uk/=09
> > >    *=09Ben Dooks<ben@simtec.co.uk>
> > >    *
> > >    * S3C ADC driver information
> > > diff --git a/arch/avr32/Kconfig b/arch/avr32/Kconfig
> > > index f515727..559aca8 100644
> > > --- a/arch/avr32/Kconfig
> > > +++ b/arch/avr32/Kconfig
> > > @@ -145,7 +145,7 @@ config BOARD_HAMMERHEAD
> > >   =09  will cover even the most exceptional need of memory bandwidth.
> > > Together with the onboard
> > >   =09  video decoder the board is ready for video processing.
> > >=20
> > > -=09  For more information see: http://www.miromico.com/hammerhead
> > > +=09  For more information see:
> > > http://www.miromico.ch/index.php/hammerhead.html
> > >=20
> > >   config BOARD_FAVR_32
> > >   =09bool "Favr-32 LCD-board"
> > > diff --git a/arch/h8300/Kconfig.cpu b/arch/h8300/Kconfig.cpu
> > > index 6e2ecff..d236ab4 100644
> > > --- a/arch/h8300/Kconfig.cpu
> > > +++ b/arch/h8300/Kconfig.cpu
> > > @@ -17,7 +17,7 @@ config H8300H_AKI3068NET
> > >   =09help
> > >   =09  AKI-H8/3068F / AKI-H8/3069F Flashmicom LAN Board Support
> > >   =09  More Information. (Japanese Only)
> > > -=09<http://akizukidensi.com/catalog/h8.html>
> > > +=09<http://akizukidenshi.com/catalog/default.aspx>
> > >   =09AE-3068/69 Evaluation Board Support
> > >   =09  More Information.
> > >   =09<http://www.microtronique.com/ae3069lan.htm>
> > > @@ -36,7 +36,7 @@ config H8300H_SIM
> > >   =09help
> > >   =09  GDB Simulator Support
> > >   =09  More Information.
> > > -=09  arch/h8300/Doc/simulator.txt
> > > +=09<http://sourceware.org/sid/>
> > >=20
> > >   config H8S_GENERIC
> > >   =09bool "H8S Generic"
> > > @@ -50,14 +50,14 @@ config H8S_EDOSK2674
> > >   =09  Renesas EDOSK-2674 Evaluation Board Support
> > >   =09  More Information.
> > >   =09<http://www.azpower.com/H8-uClinux/index.html>
> > > - =09<http://www.eu.renesas.com/tools/edk/support/edosk2674.html>
> > > +
> > > <http://www.renesas.eu/products/tools/introductory_evaluation_tools/e=
valuation_development_os_kits/edosk2674r/edosk2674r_software_tools_root.jsp=
>
> > >=20
> > >   config H8S_SIM
> > >   =09bool "H8S Simulator"
> > >   =09help
> > >   =09  GDB Simulator Support
> > >   =09  More Information.
> > > -=09  arch/h8300/Doc/simulator.txt
> > > +=09<http://sourceware.org/sid/>
> > >=20
> > >   endchoice
> > >=20
> > > diff --git a/arch/h8300/README b/arch/h8300/README
> > > index 2fd6f6d..637f5a0 100644
> > > --- a/arch/h8300/README
> > > +++ b/arch/h8300/README
> > > @@ -18,6 +18,7 @@ H8/300H and H8S
> > >=20
> > >   4.EDOSK2674
> > >     see
> > > http://www.eu.renesas.com/products/mpumcu/tool/edk/support/edosk2674.=
html
> > > +      http://www.uclinux.org/pub/uClinux/ports/h8/HITACHI-EDOSK2674-=
HOWTO
> > >         http://www.azpower.com/H8-uClinux/
> > >=20
> > >   * Toolchain Version
> > > diff --git a/arch/m32r/Kconfig b/arch/m32r/Kconfig
> > > index 836abbb..3867fd2 100644
> > > --- a/arch/m32r/Kconfig
> > > +++ b/arch/m32r/Kconfig
> > > @@ -315,7 +315,7 @@ config SMP
> > >   =09  Management" code will be disabled if you say Y here.
> > >=20
> > >   =09  See also the SMP-HOWTO available at
> > > -=09<http://www.linuxdoc.org/docs.html#howto>.
> > > +=09<http://tldp.org/HOWTO/SMP-HOWTO.html>.
> > >=20
> > >   =09  If you don't know what to do here, say N.
> > >=20
> > > diff --git a/arch/m68k/mac/macboing.c b/arch/m68k/mac/macboing.c
> > > index 05285d0..ffaa1f6 100644
> > > --- a/arch/m68k/mac/macboing.c
> > > +++ b/arch/m68k/mac/macboing.c
> > > @@ -114,7 +114,8 @@ static void mac_init_asc( void )
> > >   =09=09=09 *   16-bit I/O functionality.  The PowerBook 500
> > > series computers
> > >   =09=09=09 *   support 16-bit stereo output, but only mono
> > > input."
> > >   =09=09=09 *
> > > -=09=09=09 *
> > > http://til.info.apple.com/techinfo.nsf/artnum/n16405
> > > +=09=09=09 *   Technical Information Library (TIL) article
> > > number 16405.
> > > +=09=09=09 *   http://support.apple.com/kb/TA32601
> > >   =09=09=09 *
> > >   =09=09=09 * --David Kilzer
> > >   =09=09=09 */
> > > diff --git a/arch/m68k/q40/README b/arch/m68k/q40/README
> > > index 6bdbf48..f877b72 100644
> > > --- a/arch/m68k/q40/README
> > > +++ b/arch/m68k/q40/README
> > > @@ -3,7 +3,7 @@ Linux for the Q40
> > >=20
> > >   You may try http://www.geocities.com/SiliconValley/Bay/2602/ for
> > >   some up to date information. Booter and other tools will be also
> > > -available from this place or ftp.uni-erlangen.de/linux/680x0/q40/
> > > +available from this place or
> > > http://ftp.uni-erlangen.de/pub/unix/Linux/680x0/q40/
> > >   and mirrors.
> > >=20
> > >   Hints to documentation usually refer to the linux source tree in
> > > diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
> > > index 3ad59dd..4606248 100644
> > > --- a/arch/mips/Kconfig
> > > +++ b/arch/mips/Kconfig
> > > @@ -2175,10 +2175,14 @@ config TC
> > >   =09bool "TURBOchannel support"
> > >   =09depends on MACH_DECSTATION
> > >   =09help
> > > -=09  TurboChannel is a DEC (now Compaq (now HP)) bus for Alpha and M=
IPS
> > > -=09  processors.  Documentation on writing device drivers for
> > > TurboChannel
> > > -=09  is available at:
> > > -
> > > <http://www.cs.arizona.edu/computer.help/policy/DIGITAL_unix/AA-PS3HD=
-TET1_html/TITLE.html>.
> > > +=09  TURBOchannel is a DEC (now Compaq (now HP)) bus for Alpha and M=
IPS
> > > +=09  processors.  TURBOchannel programming specifications are availa=
ble
> > > +=09  at:
> > > +=09<ftp://ftp.hp.com/pub/alphaserver/archive/triadd/>
> > > +=09  and:
> > > +
> > > <http://www.computer-refuge.org/classiccmp/ftp.digital.com/pub/DEC/Tr=
iAdd/>
> > > +=09  Linux driver support status is documented at:
> > > +=09<http://www.linux-mips.org/wiki/DECstation>
> > >=20
> > >   #config ACCESSBUS
> > >   #=09bool "Access.Bus support"
> > > diff --git a/arch/mips/math-emu/cp1emu.c b/arch/mips/math-emu/cp1emu.=
c
> > > index 47842b7..ec3faa4 100644
> > > --- a/arch/mips/math-emu/cp1emu.c
> > > +++ b/arch/mips/math-emu/cp1emu.c
> > > @@ -3,7 +3,6 @@
> > >    *
> > >    * MIPS floating point support
> > >    * Copyright (C) 1994-2000 Algorithmics Ltd.
> > > - * http://www.algor.co.uk
> > >    *
> > >    * Kevin D. Kissell, kevink@mips.com and Carsten Langgaard,
> > > carstenl@mips.com
> > >    * Copyright (C) 2000  MIPS Technologies, Inc.
> > > diff --git a/arch/mips/math-emu/dp_add.c b/arch/mips/math-emu/dp_add.=
c
> > > index bcf73bb..b422fca 100644
> > > --- a/arch/mips/math-emu/dp_add.c
> > > +++ b/arch/mips/math-emu/dp_add.c
> > > @@ -4,7 +4,6 @@
> > >   /*
> > >    * MIPS floating point support
> > >    * Copyright (C) 1994-2000 Algorithmics Ltd.
> > > - * http://www.algor.co.uk
> > >    *
> > >    *
> > > #####################################################################=
###
> > >    *
> > > diff --git a/arch/mips/math-emu/dp_cmp.c b/arch/mips/math-emu/dp_cmp.=
c
> > > index 8ab4f32..0f32486 100644
> > > --- a/arch/mips/math-emu/dp_cmp.c
> > > +++ b/arch/mips/math-emu/dp_cmp.c
> > > @@ -4,7 +4,6 @@
> > >   /*
> > >    * MIPS floating point support
> > >    * Copyright (C) 1994-2000 Algorithmics Ltd.
> > > - * http://www.algor.co.uk
> > >    *
> > >    *
> > > #####################################################################=
###
> > >    *
> > > diff --git a/arch/mips/math-emu/dp_div.c b/arch/mips/math-emu/dp_div.=
c
> > > index 6acedce..a1bce1b 100644
> > > --- a/arch/mips/math-emu/dp_div.c
> > > +++ b/arch/mips/math-emu/dp_div.c
> > > @@ -4,7 +4,6 @@
> > >   /*
> > >    * MIPS floating point support
> > >    * Copyright (C) 1994-2000 Algorithmics Ltd.
> > > - * http://www.algor.co.uk
> > >    *
> > >    *
> > > #####################################################################=
###
> > >    *
> > > diff --git a/arch/mips/math-emu/dp_fint.c b/arch/mips/math-emu/dp_fin=
t.c
> > > index 39a71de1..8857128 100644
> > > --- a/arch/mips/math-emu/dp_fint.c
> > > +++ b/arch/mips/math-emu/dp_fint.c
> > > @@ -4,7 +4,6 @@
> > >   /*
> > >    * MIPS floating point support
> > >    * Copyright (C) 1994-2000 Algorithmics Ltd.
> > > - * http://www.algor.co.uk
> > >    *
> > >    *
> > > #####################################################################=
###
> > >    *
> > > diff --git a/arch/mips/math-emu/dp_flong.c b/arch/mips/math-emu/dp_fl=
ong.c
> > > index f08f223..14fc01e 100644
> > > --- a/arch/mips/math-emu/dp_flong.c
> > > +++ b/arch/mips/math-emu/dp_flong.c
> > > @@ -4,7 +4,6 @@
> > >   /*
> > >    * MIPS floating point support
> > >    * Copyright (C) 1994-2000 Algorithmics Ltd.
> > > - * http://www.algor.co.uk
> > >    *
> > >    *
> > > #####################################################################=
###
> > >    *
> > > diff --git a/arch/mips/math-emu/dp_frexp.c b/arch/mips/math-emu/dp_fr=
exp.c
> > > index e650cb1..cb15a5e 100644
> > > --- a/arch/mips/math-emu/dp_frexp.c
> > > +++ b/arch/mips/math-emu/dp_frexp.c
> > > @@ -4,7 +4,6 @@
> > >   /*
> > >    * MIPS floating point support
> > >    * Copyright (C) 1994-2000 Algorithmics Ltd.
> > > - * http://www.algor.co.uk
> > >    *
> > >    *
> > > #####################################################################=
###
> > >    *
> > > diff --git a/arch/mips/math-emu/dp_fsp.c b/arch/mips/math-emu/dp_fsp.=
c
> > > index 494d19a..1dfbd92 100644
> > > --- a/arch/mips/math-emu/dp_fsp.c
> > > +++ b/arch/mips/math-emu/dp_fsp.c
> > > @@ -4,7 +4,6 @@
> > >   /*
> > >    * MIPS floating point support
> > >    * Copyright (C) 1994-2000 Algorithmics Ltd.
> > > - * http://www.algor.co.uk
> > >    *
> > >    *
> > > #####################################################################=
###
> > >    *
> > > diff --git a/arch/mips/math-emu/dp_logb.c b/arch/mips/math-emu/dp_log=
b.c
> > > index 6033886..151127e 100644
> > > --- a/arch/mips/math-emu/dp_logb.c
> > > +++ b/arch/mips/math-emu/dp_logb.c
> > > @@ -4,7 +4,6 @@
> > >   /*
> > >    * MIPS floating point support
> > >    * Copyright (C) 1994-2000 Algorithmics Ltd.
> > > - * http://www.algor.co.uk
> > >    *
> > >    *
> > > #####################################################################=
###
> > >    *
> > > diff --git a/arch/mips/math-emu/dp_modf.c b/arch/mips/math-emu/dp_mod=
f.c
> > > index a8570e5..b01f9cf 100644
> > > --- a/arch/mips/math-emu/dp_modf.c
> > > +++ b/arch/mips/math-emu/dp_modf.c
> > > @@ -4,7 +4,6 @@
> > >   /*
> > >    * MIPS floating point support
> > >    * Copyright (C) 1994-2000 Algorithmics Ltd.
> > > - * http://www.algor.co.uk
> > >    *
> > >    *
> > > #####################################################################=
###
> > >    *
> > > diff --git a/arch/mips/math-emu/dp_mul.c b/arch/mips/math-emu/dp_mul.=
c
> > > index 48908a8..aa566e7 100644
> > > --- a/arch/mips/math-emu/dp_mul.c
> > > +++ b/arch/mips/math-emu/dp_mul.c
> > > @@ -4,7 +4,6 @@
> > >   /*
> > >    * MIPS floating point support
> > >    * Copyright (C) 1994-2000 Algorithmics Ltd.
> > > - * http://www.algor.co.uk
> > >    *
> > >    *
> > > #####################################################################=
###
> > >    *
> > > diff --git a/arch/mips/math-emu/dp_scalb.c b/arch/mips/math-emu/dp_sc=
alb.c
> > > index b84e633..6f5df43 100644
> > > --- a/arch/mips/math-emu/dp_scalb.c
> > > +++ b/arch/mips/math-emu/dp_scalb.c
> > > @@ -4,7 +4,6 @@
> > >   /*
> > >    * MIPS floating point support
> > >    * Copyright (C) 1994-2000 Algorithmics Ltd.
> > > - * http://www.algor.co.uk
> > >    *
> > >    *
> > > #####################################################################=
###
> > >    *
> > > diff --git a/arch/mips/math-emu/dp_simple.c
> > > b/arch/mips/math-emu/dp_simple.c
> > > index b909742..79ce267 100644
> > > --- a/arch/mips/math-emu/dp_simple.c
> > > +++ b/arch/mips/math-emu/dp_simple.c
> > > @@ -4,7 +4,6 @@
> > >   /*
> > >    * MIPS floating point support
> > >    * Copyright (C) 1994-2000 Algorithmics Ltd.
> > > - * http://www.algor.co.uk
> > >    *
> > >    *
> > > #####################################################################=
###
> > >    *
> > > diff --git a/arch/mips/math-emu/dp_sqrt.c b/arch/mips/math-emu/dp_sqr=
t.c
> > > index 032328c..a2a51b8 100644
> > > --- a/arch/mips/math-emu/dp_sqrt.c
> > > +++ b/arch/mips/math-emu/dp_sqrt.c
> > > @@ -4,7 +4,6 @@
> > >   /*
> > >    * MIPS floating point support
> > >    * Copyright (C) 1994-2000 Algorithmics Ltd.
> > > - * http://www.algor.co.uk
> > >    *
> > >    *
> > > #####################################################################=
###
> > >    *
> > > diff --git a/arch/mips/math-emu/dp_sub.c b/arch/mips/math-emu/dp_sub.=
c
> > > index a2127d6..0de098c 100644
> > > --- a/arch/mips/math-emu/dp_sub.c
> > > +++ b/arch/mips/math-emu/dp_sub.c
> > > @@ -4,7 +4,6 @@
> > >   /*
> > >    * MIPS floating point support
> > >    * Copyright (C) 1994-2000 Algorithmics Ltd.
> > > - * http://www.algor.co.uk
> > >    *
> > >    *
> > > #####################################################################=
###
> > >    *
> > > diff --git a/arch/mips/math-emu/dp_tint.c b/arch/mips/math-emu/dp_tin=
t.c
> > > index 2447862..0ebe859 100644
> > > --- a/arch/mips/math-emu/dp_tint.c
> > > +++ b/arch/mips/math-emu/dp_tint.c
> > > @@ -4,7 +4,6 @@
> > >   /*
> > >    * MIPS floating point support
> > >    * Copyright (C) 1994-2000 Algorithmics Ltd.
> > > - * http://www.algor.co.uk
> > >    *
> > >    *
> > > #####################################################################=
###
> > >    *
> > > diff --git a/arch/mips/math-emu/dp_tlong.c b/arch/mips/math-emu/dp_tl=
ong.c
> > > index 0f07ec2..133ce2b 100644
> > > --- a/arch/mips/math-emu/dp_tlong.c
> > > +++ b/arch/mips/math-emu/dp_tlong.c
> > > @@ -4,7 +4,6 @@
> > >   /*
> > >    * MIPS floating point support
> > >    * Copyright (C) 1994-2000 Algorithmics Ltd.
> > > - * http://www.algor.co.uk
> > >    *
> > >    *
> > > #####################################################################=
###
> > >    *
> > > diff --git a/arch/mips/math-emu/ieee754.c b/arch/mips/math-emu/ieee75=
4.c
> > > index cb1b682..30554e1 100644
> > > --- a/arch/mips/math-emu/ieee754.c
> > > +++ b/arch/mips/math-emu/ieee754.c
> > > @@ -9,7 +9,6 @@
> > >   /*
> > >    * MIPS floating point support
> > >    * Copyright (C) 1994-2000 Algorithmics Ltd.
> > > - * http://www.algor.co.uk
> > >    *
> > >    *
> > > #####################################################################=
###
> > >    *
> > > diff --git a/arch/mips/math-emu/ieee754.h b/arch/mips/math-emu/ieee75=
4.h
> > > index dd91733..22796e0 100644
> > > --- a/arch/mips/math-emu/ieee754.h
> > > +++ b/arch/mips/math-emu/ieee754.h
> > > @@ -1,7 +1,6 @@
> > >   /*
> > >    * MIPS floating point support
> > >    * Copyright (C) 1994-2000 Algorithmics Ltd.
> > > - * http://www.algor.co.uk
> > >    *
> > >    *  This program is free software; you can distribute it and/or mod=
ify
> > > it
> > >    *  under the terms of the GNU General Public License (Version 2) a=
s
> > > diff --git a/arch/mips/math-emu/ieee754d.c b/arch/mips/math-emu/ieee7=
54d.c
> > > index a032533..9599bdd 100644
> > > --- a/arch/mips/math-emu/ieee754d.c
> > > +++ b/arch/mips/math-emu/ieee754d.c
> > > @@ -4,7 +4,6 @@
> > >    * MIPS floating point support
> > >    *
> > >    * Copyright (C) 1994-2000 Algorithmics Ltd.
> > > - * http://www.algor.co.uk
> > >    *
> > >    *  This program is free software; you can distribute it and/or mod=
ify
> > > it
> > >    *  under the terms of the GNU General Public License (Version 2) a=
s
> > > diff --git a/arch/mips/math-emu/ieee754dp.c
> > > b/arch/mips/math-emu/ieee754dp.c
> > > index 2f22fd7..080b5ca 100644
> > > --- a/arch/mips/math-emu/ieee754dp.c
> > > +++ b/arch/mips/math-emu/ieee754dp.c
> > > @@ -4,7 +4,6 @@
> > >   /*
> > >    * MIPS floating point support
> > >    * Copyright (C) 1994-2000 Algorithmics Ltd.
> > > - * http://www.algor.co.uk
> > >    *
> > >    *
> > > #####################################################################=
###
> > >    *
> > > diff --git a/arch/mips/math-emu/ieee754dp.h
> > > b/arch/mips/math-emu/ieee754dp.h
> > > index 7627865..f139c72 100644
> > > --- a/arch/mips/math-emu/ieee754dp.h
> > > +++ b/arch/mips/math-emu/ieee754dp.h
> > > @@ -5,7 +5,6 @@
> > >   /*
> > >    * MIPS floating point support
> > >    * Copyright (C) 1994-2000 Algorithmics Ltd.
> > > - * http://www.algor.co.uk
> > >    *
> > >    *
> > > #####################################################################=
###
> > >    *
> > > diff --git a/arch/mips/math-emu/ieee754int.h
> > > b/arch/mips/math-emu/ieee754int.h
> > > index 1a846c5..2701d95 100644
> > > --- a/arch/mips/math-emu/ieee754int.h
> > > +++ b/arch/mips/math-emu/ieee754int.h
> > > @@ -5,7 +5,6 @@
> > >   /*
> > >    * MIPS floating point support
> > >    * Copyright (C) 1994-2000 Algorithmics Ltd.
> > > - * http://www.algor.co.uk
> > >    *
> > >    *
> > > #####################################################################=
###
> > >    *
> > > diff --git a/arch/mips/math-emu/ieee754m.c b/arch/mips/math-emu/ieee7=
54m.c
> > > index d66896c..24190f3 100644
> > > --- a/arch/mips/math-emu/ieee754m.c
> > > +++ b/arch/mips/math-emu/ieee754m.c
> > > @@ -4,7 +4,6 @@
> > >   /*
> > >    * MIPS floating point support
> > >    * Copyright (C) 1994-2000 Algorithmics Ltd.
> > > - * http://www.algor.co.uk
> > >    *
> > >    *
> > > #####################################################################=
###
> > >    *
> > > diff --git a/arch/mips/math-emu/ieee754sp.c
> > > b/arch/mips/math-emu/ieee754sp.c
> > > index a19b721..271d00d 100644
> > > --- a/arch/mips/math-emu/ieee754sp.c
> > > +++ b/arch/mips/math-emu/ieee754sp.c
> > > @@ -4,7 +4,6 @@
> > >   /*
> > >    * MIPS floating point support
> > >    * Copyright (C) 1994-2000 Algorithmics Ltd.
> > > - * http://www.algor.co.uk
> > >    *
> > >    *
> > > #####################################################################=
###
> > >    *
> > > diff --git a/arch/mips/math-emu/ieee754sp.h
> > > b/arch/mips/math-emu/ieee754sp.h
> > > index d9e3586..754fd54 100644
> > > --- a/arch/mips/math-emu/ieee754sp.h
> > > +++ b/arch/mips/math-emu/ieee754sp.h
> > > @@ -5,7 +5,6 @@
> > >   /*
> > >    * MIPS floating point support
> > >    * Copyright (C) 1994-2000 Algorithmics Ltd.
> > > - * http://www.algor.co.uk
> > >    *
> > >    *
> > > #####################################################################=
###
> > >    *
> > > diff --git a/arch/mips/math-emu/ieee754xcpt.c
> > > b/arch/mips/math-emu/ieee754xcpt.c
> > > index e02423a..b99a693 100644
> > > --- a/arch/mips/math-emu/ieee754xcpt.c
> > > +++ b/arch/mips/math-emu/ieee754xcpt.c
> > > @@ -1,7 +1,6 @@
> > >   /*
> > >    * MIPS floating point support
> > >    * Copyright (C) 1994-2000 Algorithmics Ltd.
> > > - * http://www.algor.co.uk
> > >    *
> > >    *
> > > #####################################################################=
###
> > >    *
> > > diff --git a/arch/mips/math-emu/sp_add.c b/arch/mips/math-emu/sp_add.=
c
> > > index d8c4211..ae1a327 100644
> > > --- a/arch/mips/math-emu/sp_add.c
> > > +++ b/arch/mips/math-emu/sp_add.c
> > > @@ -4,7 +4,6 @@
> > >   /*
> > >    * MIPS floating point support
> > >    * Copyright (C) 1994-2000 Algorithmics Ltd.
> > > - * http://www.algor.co.uk
> > >    *
> > >    *
> > > #####################################################################=
###
> > >    *
> > > diff --git a/arch/mips/math-emu/sp_cmp.c b/arch/mips/math-emu/sp_cmp.=
c
> > > index d3eff6b..716cf37 100644
> > > --- a/arch/mips/math-emu/sp_cmp.c
> > > +++ b/arch/mips/math-emu/sp_cmp.c
> > > @@ -4,7 +4,6 @@
> > >   /*
> > >    * MIPS floating point support
> > >    * Copyright (C) 1994-2000 Algorithmics Ltd.
> > > - * http://www.algor.co.uk
> > >    *
> > >    *
> > > #####################################################################=
###
> > >    *
> > > diff --git a/arch/mips/math-emu/sp_div.c b/arch/mips/math-emu/sp_div.=
c
> > > index 2b437fc..d774792 100644
> > > --- a/arch/mips/math-emu/sp_div.c
> > > +++ b/arch/mips/math-emu/sp_div.c
> > > @@ -4,7 +4,6 @@
> > >   /*
> > >    * MIPS floating point support
> > >    * Copyright (C) 1994-2000 Algorithmics Ltd.
> > > - * http://www.algor.co.uk
> > >    *
> > >    *
> > > #####################################################################=
###
> > >    *
> > > diff --git a/arch/mips/math-emu/sp_fdp.c b/arch/mips/math-emu/sp_fdp.=
c
> > > index 4093723..e1515aa 100644
> > > --- a/arch/mips/math-emu/sp_fdp.c
> > > +++ b/arch/mips/math-emu/sp_fdp.c
> > > @@ -4,7 +4,6 @@
> > >   /*
> > >    * MIPS floating point support
> > >    * Copyright (C) 1994-2000 Algorithmics Ltd.
> > > - * http://www.algor.co.uk
> > >    *
> > >    *
> > > #####################################################################=
###
> > >    *
> > > diff --git a/arch/mips/math-emu/sp_fint.c b/arch/mips/math-emu/sp_fin=
t.c
> > > index e88e125..9694d6c 100644
> > > --- a/arch/mips/math-emu/sp_fint.c
> > > +++ b/arch/mips/math-emu/sp_fint.c
> > > @@ -4,7 +4,6 @@
> > >   /*
> > >    * MIPS floating point support
> > >    * Copyright (C) 1994-2000 Algorithmics Ltd.
> > > - * http://www.algor.co.uk
> > >    *
> > >    *
> > > #####################################################################=
###
> > >    *
> > > diff --git a/arch/mips/math-emu/sp_flong.c b/arch/mips/math-emu/sp_fl=
ong.c
> > > index 26d6919..16a651f 100644
> > > --- a/arch/mips/math-emu/sp_flong.c
> > > +++ b/arch/mips/math-emu/sp_flong.c
> > > @@ -4,7 +4,6 @@
> > >   /*
> > >    * MIPS floating point support
> > >    * Copyright (C) 1994-2000 Algorithmics Ltd.
> > > - * http://www.algor.co.uk
> > >    *
> > >    *
> > > #####################################################################=
###
> > >    *
> > > diff --git a/arch/mips/math-emu/sp_frexp.c b/arch/mips/math-emu/sp_fr=
exp.c
> > > index 359c648..5bc993c 100644
> > > --- a/arch/mips/math-emu/sp_frexp.c
> > > +++ b/arch/mips/math-emu/sp_frexp.c
> > > @@ -4,7 +4,6 @@
> > >   /*
> > >    * MIPS floating point support
> > >    * Copyright (C) 1994-2000 Algorithmics Ltd.
> > > - * http://www.algor.co.uk
> > >    *
> > >    *
> > > #####################################################################=
###
> > >    *
> > > diff --git a/arch/mips/math-emu/sp_logb.c b/arch/mips/math-emu/sp_log=
b.c
> > > index 3c33721..9c14e0c 100644
> > > --- a/arch/mips/math-emu/sp_logb.c
> > > +++ b/arch/mips/math-emu/sp_logb.c
> > > @@ -4,7 +4,6 @@
> > >   /*
> > >    * MIPS floating point support
> > >    * Copyright (C) 1994-2000 Algorithmics Ltd.
> > > - * http://www.algor.co.uk
> > >    *
> > >    *
> > > #####################################################################=
###
> > >    *
> > > diff --git a/arch/mips/math-emu/sp_modf.c b/arch/mips/math-emu/sp_mod=
f.c
> > > index 7656894..25a0fba 100644
> > > --- a/arch/mips/math-emu/sp_modf.c
> > > +++ b/arch/mips/math-emu/sp_modf.c
> > > @@ -4,7 +4,6 @@
> > >   /*
> > >    * MIPS floating point support
> > >    * Copyright (C) 1994-2000 Algorithmics Ltd.
> > > - * http://www.algor.co.uk
> > >    *
> > >    *
> > > #####################################################################=
###
> > >    *
> > > diff --git a/arch/mips/math-emu/sp_mul.c b/arch/mips/math-emu/sp_mul.=
c
> > > index 3f070f8..c06bb40 100644
> > > --- a/arch/mips/math-emu/sp_mul.c
> > > +++ b/arch/mips/math-emu/sp_mul.c
> > > @@ -4,7 +4,6 @@
> > >   /*
> > >    * MIPS floating point support
> > >    * Copyright (C) 1994-2000 Algorithmics Ltd.
> > > - * http://www.algor.co.uk
> > >    *
> > >    *
> > > #####################################################################=
###
> > >    *
> > > diff --git a/arch/mips/math-emu/sp_scalb.c b/arch/mips/math-emu/sp_sc=
alb.c
> > > index 44ceb87..dd76196 100644
> > > --- a/arch/mips/math-emu/sp_scalb.c
> > > +++ b/arch/mips/math-emu/sp_scalb.c
> > > @@ -4,7 +4,6 @@
> > >   /*
> > >    * MIPS floating point support
> > >    * Copyright (C) 1994-2000 Algorithmics Ltd.
> > > - * http://www.algor.co.uk
> > >    *
> > >    *
> > > #####################################################################=
###
> > >    *
> > > diff --git a/arch/mips/math-emu/sp_simple.c
> > > b/arch/mips/math-emu/sp_simple.c
> > > index 2fd53c9..ae4fcfa 100644
> > > --- a/arch/mips/math-emu/sp_simple.c
> > > +++ b/arch/mips/math-emu/sp_simple.c
> > > @@ -4,7 +4,6 @@
> > >   /*
> > >    * MIPS floating point support
> > >    * Copyright (C) 1994-2000 Algorithmics Ltd.
> > > - * http://www.algor.co.uk
> > >    *
> > >    *
> > > #####################################################################=
###
> > >    *
> > > diff --git a/arch/mips/math-emu/sp_sqrt.c b/arch/mips/math-emu/sp_sqr=
t.c
> > > index 8a934b9..fed2017 100644
> > > --- a/arch/mips/math-emu/sp_sqrt.c
> > > +++ b/arch/mips/math-emu/sp_sqrt.c
> > > @@ -4,7 +4,6 @@
> > >   /*
> > >    * MIPS floating point support
> > >    * Copyright (C) 1994-2000 Algorithmics Ltd.
> > > - * http://www.algor.co.uk
> > >    *
> > >    *
> > > #####################################################################=
###
> > >    *
> > > diff --git a/arch/mips/math-emu/sp_sub.c b/arch/mips/math-emu/sp_sub.=
c
> > > index dbb802c..886ed5b 100644
> > > --- a/arch/mips/math-emu/sp_sub.c
> > > +++ b/arch/mips/math-emu/sp_sub.c
> > > @@ -4,7 +4,6 @@
> > >   /*
> > >    * MIPS floating point support
> > >    * Copyright (C) 1994-2000 Algorithmics Ltd.
> > > - * http://www.algor.co.uk
> > >    *
> > >    *
> > > #####################################################################=
###
> > >    *
> > > diff --git a/arch/mips/math-emu/sp_tint.c b/arch/mips/math-emu/sp_tin=
t.c
> > > index 352dc3a..0fe9acc 100644
> > > --- a/arch/mips/math-emu/sp_tint.c
> > > +++ b/arch/mips/math-emu/sp_tint.c
> > > @@ -4,7 +4,6 @@
> > >   /*
> > >    * MIPS floating point support
> > >    * Copyright (C) 1994-2000 Algorithmics Ltd.
> > > - * http://www.algor.co.uk
> > >    *
> > >    *
> > > #####################################################################=
###
> > >    *
> > > diff --git a/arch/mips/math-emu/sp_tlong.c b/arch/mips/math-emu/sp_tl=
ong.c
> > > index 92cd9c5..d0ca6e2 100644
> > > --- a/arch/mips/math-emu/sp_tlong.c
> > > +++ b/arch/mips/math-emu/sp_tlong.c
> > > @@ -4,7 +4,6 @@
> > >   /*
> > >    * MIPS floating point support
> > >    * Copyright (C) 1994-2000 Algorithmics Ltd.
> > > - * http://www.algor.co.uk
> > >    *
> > >    *
> > > #####################################################################=
###
> > >    *
> > > diff --git a/arch/powerpc/include/asm/hydra.h
> > > b/arch/powerpc/include/asm/hydra.h
> > > index 1ad4eed..d529a2c 100644
> > > --- a/arch/powerpc/include/asm/hydra.h
> > > +++ b/arch/powerpc/include/asm/hydra.h
> > > @@ -10,7 +10,7 @@
> > >    *
> > >    *=09=A9 Copyright 1995 Apple Computer, Inc. All rights reserved.
> > >    *
> > > - *  It's available online from http://chrp.apple.com/MacTech.pdf.
> > > + *  It's available online from http://www.cpu.lu/~mlan/ftp/MacTech.p=
df.
> > >    *  You can obtain paper copies of this book from computer bookstor=
es or
> > > by
> > >    *  writing Morgan Kaufmann Publishers, Inc., 340 Pine Street, Sixt=
h
> > > Floor, San
> > >    *  Francisco, CA 94104. Reference ISBN 1-55860-393-X.
> > > diff --git a/arch/x86/kernel/apm_32.c b/arch/x86/kernel/apm_32.c
> > > index 4c9c67b..9fed1cc 100644
> > > --- a/arch/x86/kernel/apm_32.c
> > > +++ b/arch/x86/kernel/apm_32.c
> > > @@ -189,8 +189,8 @@
> > >    *   Intel Order Number 241704-001.  Microsoft Part Number 781-110-=
X01.
> > >    *
> > >    * [This document is available free from Intel by calling 800.628.8=
686
> > > (fax
> > > - * 916.356.6100) or 800.548.4725; or via anonymous ftp from
> > > - * ftp://ftp.intel.com/pub/IAL/software_specs/apmv11.doc.  It is als=
o
> > > + * 916.356.6100) or 800.548.4725; or from
> > > + * http://www.microsoft.com/whdc/archive/amp_12.mspx  It is also
> > >    * available from Microsoft by calling 206.882.8080.]
> > >    *
> > >    * APM 1.2 Reference:
> > > diff --git a/arch/x86/kernel/microcode_core.c
> > > b/arch/x86/kernel/microcode_core.c
> > > index fa6551d..b9c5c54 100644
> > > --- a/arch/x86/kernel/microcode_core.c
> > > +++ b/arch/x86/kernel/microcode_core.c
> > > @@ -12,7 +12,7 @@
> > >    *=09Software Developer's Manual
> > >    *=09Order Number 253668 or free download from:
> > >    *
> > > - *=09http://developer.intel.com/design/pentium4/manuals/253668.htm
> > > + *=09http://developer.intel.com/Assets/PDF/manual/253668.pdf=09
> > >    *
> > >    *=09For more information, go to http://www.urbanmyth.org/microcode
> > >    *
> > > diff --git a/arch/x86/kernel/microcode_intel.c
> > > b/arch/x86/kernel/microcode_intel.c
> > > index 3561702..dcb65cc 100644
> > > --- a/arch/x86/kernel/microcode_intel.c
> > > +++ b/arch/x86/kernel/microcode_intel.c
> > > @@ -12,7 +12,7 @@
> > >    *=09Software Developer's Manual
> > >    *=09Order Number 253668 or free download from:
> > >    *
> > > - *=09http://developer.intel.com/design/pentium4/manuals/253668.htm
> > > + *=09http://developer.intel.com/Assets/PDF/manual/253668.pdf=09
> > >    *
> > >    *=09For more information, go to http://www.urbanmyth.org/microcode
> > >    *
>=20
>=20
--0-2033526450-1287109769=:283--
