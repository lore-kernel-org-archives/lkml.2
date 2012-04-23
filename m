Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753837Ab2DWI5x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 04:57:53 -0400
Received: from na3sys009aog131.obsmtp.com ([74.125.149.247]:43711 "EHLO
	na3sys009aog131.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753641Ab2DWI5u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 04:57:50 -0400
Date: Mon, 23 Apr 2012 11:56:36 +0300
From: Felipe Balbi <balbi@ti.com>
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Randy Dunlap <rdunlap@xenotime.net>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, linux-usb@vger.kernel.org,
        target-devel@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Greg KH <gregkh@linuxfoundation.org>
Subject: Re: linux-next: Tree for Apr 20 (usb & target)
Message-ID: <20120423085635.GL26302@arwen.pp.htv.fi>
Reply-To: balbi@ti.com
References: <20120420155151.3fcac4c2d1002ade5ccf44ac@canb.auug.org.au>
 <4F91D9D9.6020609@xenotime.net>
 <1334999263.30707.129.camel@haakon2.linux-iscsi.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="oiL9LJXJsdjS5rzq"
Content-Disposition: inline
In-Reply-To: <1334999263.30707.129.camel@haakon2.linux-iscsi.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--oiL9LJXJsdjS5rzq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Sat, Apr 21, 2012 at 02:07:43AM -0700, Nicholas A. Bellinger wrote:
> On Fri, 2012-04-20 at 14:49 -0700, Randy Dunlap wrote:
> > On 04/19/2012 10:51 PM, Stephen Rothwell wrote:
> >=20
> > > Hi all,
> > >=20
> > > Changes since 20120419:
> >=20
> >=20
>=20
> Hi Randy,
>=20
> > CONFIG_MODULES is not enabled.
> > CONFIG_TCM_USB_GADGET=3Dy
> > CONFIG_USB_GADGET=3Dy
> >
> > drivers/usb/built-in.o: In function `usb_descriptor_fillbuf':
> > (.text+0x53bb): multiple definition of `usb_descriptor_fillbuf'
> > drivers/target/built-in.o:(.text+0x1e605): first defined here
> > drivers/usb/built-in.o: In function `usb_string_ids_n':
> > (.text+0x4f1a): multiple definition of `usb_string_ids_n'
> > drivers/target/built-in.o:(.text+0x1f1ed): first defined here
> > drivers/usb/built-in.o: In function `usb_interface_id':
> > (.text+0x4ea8): multiple definition of `usb_interface_id'
> > drivers/target/built-in.o:(.text+0x1f0bc): first defined here
> > drivers/usb/built-in.o: In function `usb_string_id':
> > (.text+0x4ecc): multiple definition of `usb_string_id'
> > drivers/target/built-in.o:(.text+0x1f19f): first defined here
> > drivers/usb/built-in.o: In function `usb_string_ids_tab':
> > (.text+0x4ee8): multiple definition of `usb_string_ids_tab'
> > drivers/target/built-in.o:(.text+0x1f1bb): first defined here
> > drivers/usb/built-in.o: In function `usb_copy_descriptors':
> > (.text+0x5a01): multiple definition of `usb_copy_descriptors'
> > drivers/target/built-in.o:(.text+0x1ec48): first defined here
> > drivers/usb/built-in.o: In function `usb_composite_unregister':
> > (.text+0x4fe2): multiple definition of `usb_composite_unregister'
> > drivers/target/built-in.o:(.text+0x1f2b5): first defined here
> > drivers/usb/built-in.o: In function `config_ep_by_speed':
> > (.text+0x4bd7): multiple definition of `config_ep_by_speed'
> > drivers/target/built-in.o:(.text+0x1ecca): first defined here
> > drivers/usb/built-in.o: In function `usb_gadget_get_string':
> > (.text+0x5094): multiple definition of `usb_gadget_get_string'
> > drivers/target/built-in.o:(.text+0x1dd85): first defined here
> > drivers/usb/built-in.o: In function `usb_add_function':
> > (.text+0x4cfc): multiple definition of `usb_add_function'
> > drivers/target/built-in.o:(.text+0x1ee6c): first defined here
> > drivers/usb/built-in.o: In function `usb_composite_probe':
> > (.text+0x4f4a): multiple definition of `usb_composite_probe'
> > drivers/target/built-in.o:(.text+0x1f21d): first defined here
> > drivers/usb/built-in.o: In function `usb_composite_setup_continue':
> > (.text+0x4ffd): multiple definition of `usb_composite_setup_continue'
> > drivers/target/built-in.o:(.text+0x1f369): first defined here
> > drivers/usb/built-in.o: In function `usb_gadget_config_buf':
> > (.text+0x59ad): multiple definition of `usb_gadget_config_buf'
> > drivers/target/built-in.o:(.text+0x1ebf4): first defined here
> > drivers/usb/built-in.o: In function `usb_ep_autoconfig':
> > (.text+0x5bba): multiple definition of `usb_ep_autoconfig'
> > drivers/target/built-in.o:(.text+0x1e358): first defined here
> > drivers/usb/built-in.o: In function `usb_function_activate':
> > (.text+0x4e29): multiple definition of `usb_function_activate'
> > drivers/target/built-in.o:(.text+0x1f03b): first defined here
> > drivers/usb/built-in.o: In function `usb_ep_autoconfig_reset':
> > (.text+0x5bc7): multiple definition of `usb_ep_autoconfig_reset'
> > drivers/target/built-in.o:(.text+0x1e365): first defined here
> > drivers/usb/built-in.o: In function `usb_add_config':
> > (.text+0x5e6a): multiple definition of `usb_add_config'
> > drivers/target/built-in.o:(.text+0x1f0e0): first defined here
> > drivers/usb/built-in.o: In function `usb_ep_autoconfig_ss':
> > (.text+0x5a83): multiple definition of `usb_ep_autoconfig_ss'
> > drivers/target/built-in.o:(.text+0x1e0ab): first defined here
> > drivers/usb/built-in.o: In function `usb_function_deactivate':
> > (.text+0x4dc2): multiple definition of `usb_function_deactivate'
> > drivers/target/built-in.o:(.text+0x1efd4): first defined here
> >=20
> >=20
>=20
> Mmmm, It looks like the source file include usage in target/usb-gadget.c
> might be causing some problems here:
>=20
> #include "usbstring.c"
> #include "epautoconf.c"
> #include "config.c"
> #include "composite.c"

BTW, this construction was done by David Brownell when Greg asked about
the size of the gadget drivers:

$ git log --oneline --author=3D"Brownell" --grep=3D"link fixes" drivers/usb=
/gadget/
33376c1 usb gadget: link fixes for network gadget
8a1ce2c usb gadget: link fixes for cdc composite gadget
352e2b9 usb gadget: link fixes for storage gadget
0a56b03 usb gadget: link fixes for printer gadget
77f754c usb gadget: link fixes for MIDI gadget
7e75bc0 usb gadget: link fixes for gadget zero
4e9ba51 usb gadget: link fixes for serial gadget

And here are the mailing list archives:

=2E http://marc.info/?t=3D121867757300003&r=3D1&w=3D2
=2E http://marc.info/?t=3D121910658600003&r=3D1&w=3D2

--=20
balbi

--oiL9LJXJsdjS5rzq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPlRlCAAoJEIaOsuA1yqREYVgQAKqMBhcVdSJiIlV3u2qNmz7/
O4xnyI0J9W0SH1OxC2fDriRi2YFKY0z2w9LjkpHQUQ98Z2+Bk7Q3nXLLHFj7MYZv
sbWT/BsIaIw4v0LFxXaQcudDXHMTAKL8HJHk0pVV8qWXEMeKtvl2+iPwc5meFsrP
zBPUJn/IyhUqMjsPUo3mVDpJDtALz72GS+RgYUjKDQC0u2Y608az71a8KmAu6WWM
Lx3SxY/Dt2JPiBrq8Z9coxZhv1IYKJuu4aZiX71Q7WHB4QWPBc2CNHe7/CSh/Rld
gNIrW66ppCs+l+i5LhFSsNbRJwGEu4sbKSBgYkCkmTLE/r+gZoYqHe2SWrTIcDj2
MYlcK7mb83rYWuebwGMddPVJbge2Bev4YbRYfRmNxyMGex+A9TtmMctI+nvCPB98
5eZqbfIA8rwFwP4TSbltW+XOWJF7ogavmg4hKxYzwpJY16810LyBzEsKco3+5BLx
wmbwxIDRW/k3FPHythvq0RPEBJrn7pf8tdfXNJ82m514ESxXueBCb16qjZaQN3M7
NNXvHjFmOfdXAz/Az0ZNCRKr2yan3rdeOCvXtuZgxfF7OZZI3d5lo8MuUhEAPgpx
xW0CdthMbL2r6b5XD63sov1K5RjFHuGrPxC2PJS//mELiPFXJh1net83mx7SjU6u
8JAhmecwHijC98jMDDVQ
=fh0M
-----END PGP SIGNATURE-----

--oiL9LJXJsdjS5rzq--
