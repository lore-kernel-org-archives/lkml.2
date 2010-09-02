Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755538Ab0IBP33 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 11:29:29 -0400
Received: from romulus.commandcorp.com ([130.205.32.3]:45343 "EHLO
	romulus.wittsend.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751632Ab0IBP31 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 11:29:27 -0400
X-Greylist: delayed 336 seconds by postgrey-1.27 at vger.kernel.org; Thu, 02 Sep 2010 11:29:27 EDT
Subject: Re: [RFC 0/5] tty: move stuff around
From: "Michael H. Warfield" <mhw@WittsEnd.com>
Reply-To: mhw@WittsEnd.com
To: Rogier Wolff <R.E.Wolff@BitWizard.nl>
Cc: mhw@WittsEnd.com, Arnd Bergmann <arnd@arndb.de>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, Greg KH <gregkh@suse.de>,
        Jiri Slaby <jslaby@suse.cz>, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Mike Frysinger <vapier.adi@gmail.com>
In-Reply-To: <20100831104205.GA2301@bitwizard.nl>
References: <1283115995-4734-1-git-send-email-arnd@arndb.de>
	 <201008302333.22447.arnd@arndb.de>
	 <20100830232800.3cb768fc@lxorguk.ukuu.org.uk>
	 <201008311126.45190.arnd@arndb.de>  <20100831104205.GA2301@bitwizard.nl>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-qITO65RSGRYGiQCZ++ks"
Organization: Thaumaturgy & Speculums Technology
Date: Thu, 02 Sep 2010 11:16:07 -0400
Message-ID: <1283440567.5202.19.camel@canyon.wittsend.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 (2.30.2-4.fc13) 
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.3 (romulus.wittsend.com [IPv6:2001:4830:3000:2:280:3fff:fe03:455b]); Thu, 02 Sep 2010 11:16:14 -0400 (EDT)
X-WittsEnd-MailScanner-Information: Please contact the ISP for more information
X-WittsEnd-MailScanner-ID: o82FG8ph002537
X-WittsEnd-MailScanner: Found to be clean
X-WittsEnd-MailScanner-From: mhw@wittsend.com
X-WittsEnd-MailScanner-Watermark: 1284045374.69954@c1iXkfkac8P+TDHMJhT+4g
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-qITO65RSGRYGiQCZ++ks
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hey guys!

I see vger has bounced me off the majordomo lists...  Again.  And I
missed it.  Again...  Sigh...  I appreciate getting a direct ping on
this...

On Tue, 2010-08-31 at 12:42 +0200, Rogier Wolff wrote:=20
> Hi,=20

> The question is whether I want the drivers I wrote to stay or to
> go away?

> I was paid years ago to make Linux support the Specialix cards. It
> started with one card from their line of "solutions", but the others
> followed.

My story is very similar with the Computone Intelliport II boards.  I
was paid (in hardware) by Computone to get their drivers integrated into
the mainline kernel and support them.  That was a long long time ago.
The boards have not been manufactured in over a decade and the company
went of of business a long time ago.  I'm still in touch with several of
the old developers that use to work there.

> I personally don't use "serial" very much anymore. If I do, I end up
> getting an USB-serial converter for $3 in China (includes shipping).

Every once in a while I'll hear from someone who picked up some old
boards on E-Bay or something inquiring about the drivers and how do they
set it up.  I strongly discourage anyone from setting up a new project
with these boards.  They were expensive at the time and replacements are
going to be impossible to find.  I send every new inquiry over to look
at the USB serial converters (there are some really nice 8 port and 16
port units out there as well as the singles) that are cheaper and will
be possible to replace if and when they break.

I do hear, once in a very long while, from some of the legacy users of
those boards.  They love'm.  But they're mostly staying on the 2.4
kernel anyways and not upgrading.  More often than not, it's some
problem getting them to work on some new motherboard after repairing or
upgrading a system.  I wouldn't be surprised if some of these shops
haven't discovered that they can not get replacement boards and migrated
over to USB.  It actually has been quite some time since I last heard
from anyone.

That driver supported 256 serial ports with a couple of different
interfaces resulting in 3 whole majors allocated to it.  Even back then,
that seemed like such a waste for such an obscure board.

At this point in time, I would have no heartburn if that driver was
relegated to legacy status and those 3 majors freed up.

> But my personal interest in the serial protocol is that I interface
> with microcontrollers. The mess of the +/- 12V levels is a nuisance.=20
>=20
> Other people might use "serial" devices because they are stuck with a
> historical setup. If you have a factory with a well-designed computer
> system, it is very well possible that some installations are still
> running with a serial terminal on every desk. Some desks will have a
> windows PC and a terminal application, but the serial interface to the
> central "mainframe" will still be maintained.
>=20
> Those central "mainframes" might be Linux PCs. The Linux PCs replaced
> older hardware and software. Maybe they were running SCO or another
> Unix variant, and through the years the application was ported to
> Linux.=20

That was exactly why I got involved with Computone.  I had customers on
SCO Unix plus my own setup and I wanted to get everyone off that OS.

> In those setups, I can imagine a 8-port or 32-port serial card to be
> useful. It would be nice that people supporting that sort of setup
> would be able to install Ubuntu 10.10 and have their hardware simply
> work. Buying new multiport serial cards seems unneccesary unless they
> are ISA. But specialix cards are available in PCI. So if you already
> have PCI cards why force them to new hardware if they have hardware
> that works?

Computone Intelliport II boards were also available in PCI.  Now days,
you can pick up an 8 port USB to serial converter for under $30 that
will do just as well as one of those boards use to do.

> Oh! One more thing. The sysops at shops that use these multiport
> serial cards are not the types to monitor Linux-kernel and make waves
> if support for their card is going to be dropped.

They're also not likely to be running the latest and greatest on those
serial engines.

> Now I've missed the first part of this discussion... Is there a change
> imminent that requires rewriting of all the drivers?
>=20
>=20
> (If rewriting serial drivers, PLEASE make it so that the
> userspace-kernel interface just passes a baud rate integer, not the
> one-of-16-possible baudrate-flags. The old stuff can be emulated in a
> library. Secondly serial port drivers should NOT have to worry about
> DCD changes and what to do with sleeping processes. The driver should
> have an kernel function to call: "hey, one of the control lines
> changed level. These are the new ones". And "These characters
> arrived". And the driver has an entry point: "please send these
> characters". )

> 	Roger.=20

Regards,
Mike

> On Tue, Aug 31, 2010 at 11:26:45AM +0200, Arnd Bergmann wrote:
> > On Tuesday 31 August 2010, Alan Cox wrote:
> > > > drivers/char/tty_*      -> tty/*
> > > > drivers/char/{vt stuff} -> tty/vt/
> > > > drivers/char/hvc_*      -> drivers/tty/hvc/hvc_*
> > > > drivers/serial/*        -> drivers/tty/serial/*
> > >=20
> > > There are dead bits in there too we should prune 68xxx stuff mostly
> >=20
> > Geert, can you comment on the 68k serial drivers? Which
> > ones are to stay, which ones can get phased out?
> >=20
> > > > drivers/usb/serial      -> drivers/usb/serial
> > > >=20
> > > > cyclades,moxa,mxser     -> drivers/tty/hw/
> > > >=20
> > > > stallion,istallion,
> > > > epca,specialix,ip2,
> > > > riscom,isicom           -> drivers/staging/tty/*
> > >=20
> > > isicom has users and gets tested a bit, not sure about ip2/specialix.
> >=20
> > I'll leave isicom then.
> >=20
> > Specialix is marked in MAINTAINERS as supported by Roger, ip2
> > is maintained by Michael, maybe they have a preference for their
> > drivers.
> >=20
> > Both drivers have a web page that is ~10 years old, which hints
> > that there is probably not much new hardware around.
> >=20
> > > > generic_serial,vme_scc,
> > > > ser_a2232,sx,rio        -> drivers/staging/generic_serial/*
> > > >=20
> > > > amiserial,nozomi,
> > > > serial167,synclink      -> drivers/tty/hw (?)
> > >=20
> > > Why /hw - its a tty driver so drivers/tty - the non hw stuff is now i=
n
> > > tty/
> >=20
> > Right, makes sense.
> >=20
> > > serial167 is dead/staging stuff, synclink* are used
> >=20
> > ok
> > =20
> > > > bfin_jtag_comm          -> drivers/tty/hvc/hvc_bfin_jtag (?)
> > >=20
> > > Nothing to do with hvc
> >=20
> > Not yet ;-)
> >=20
> > You didn't reply to my question why it couldn't be. I'll let Mike
> > judge this one when he has looked at the hvc infrastructure.
> >=20
> > I wouldn't move it to that directory unless the code gets changed
> > first, but I wanted to write down where I think it should end up.
> >=20
> > > > rocket,ipwireless       -> drivers/staging/tty/* (?)
> > >=20
> > > Rocket is used, ipwireless I think is also used
> >=20
> > ok.
> >=20
> > 	Arnd
> >=20
>=20

--=20
Michael H. Warfield (AI4NB) | (770) 985-6132 |  mhw@WittsEnd.com
   /\/\|=3Dmhw=3D|\/\/          | (678) 463-0932 |  http://www.wittsend.com=
/mhw/
   NIC whois: MHW9          | An optimist believes we live in the best of a=
ll
 PGP Key: 0x674627FF        | possible worlds.  A pessimist is sure of it!

--=-qITO65RSGRYGiQCZ++ks
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEVAwUATH+/sMDrlnVnRif/AQJq1Qf/UEryov1ndAmcIdBsVjjT8b67qrs8SY4W
o/2xiEtRYDjRI1JoV93OOZrzzLpD+R5kiEJRH+nSmHxACadZNb42wsS53A/E1JfX
Nx0QYnji557zyhKtOr+J08Dd4s/qm9PbFbk5JNS5z0UskVvyDTYHSI9sRW/FAy5O
nfqBPYWYMfhw3zlGbXZzr9LzQzPoPfJQaA2w8qLnpaGZo4QPE8pU+RbpIt9kfrud
vhWke7SqPKPa9tAYcOk8d1pK2ZADHwxA5oO88fBIM8CZ7kgLgF6PX6dL2kzSNmDb
CbkFFvIXIzy/+bdEwH1mtoJTmDVFNkhRjKgEEz7D4QPbyT4+JXJ5GQ==
=Xmm/
-----END PGP SIGNATURE-----

--=-qITO65RSGRYGiQCZ++ks--

