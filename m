Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932733Ab2AMUKU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jan 2012 15:10:20 -0500
Received: from na3sys009aog108.obsmtp.com ([74.125.149.199]:44878 "EHLO
	na3sys009aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759001Ab2AMUKR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jan 2012 15:10:17 -0500
Date: Fri, 13 Jan 2012 22:10:13 +0200
From: Felipe Balbi <balbi@ti.com>
To: Sergei Shtylyov <sshtylyov@mvista.com>
Cc: "Gupta, Ajay Kumar" <ajay.gupta@ti.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: RFC: usb: musb: Adding CPPI4.1 DMA driver under drivers/dma
Message-ID: <20120113201010.GJ3133@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <201201120753.00667.oneukum@suse.de>
 <Pine.LNX.4.44L0.1201121037340.1384-100000@iolanthe.rowland.org>
 <20120112215014.GC5735@xanatos>
 <20120112215459.GA1161@kroah.com>
 <20120112222947.GD5735@xanatos>
 <20120112223513.GA2925@kroah.com>
 <20120113061144.GA30569@suse.cz>
 <47CEF8C4B26E8C44B22B028A650E0EA9317A6B8B@DBDE01.ent.ti.com>
 <4F1096E9.4020501@mvista.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Qgof7w7UksPF5inF"
Content-Disposition: inline
In-Reply-To: <4F1096E9.4020501@mvista.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Qgof7w7UksPF5inF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 13, 2012 at 11:41:13PM +0300, Sergei Shtylyov wrote:
> Hello.
>=20
> On 01/13/2012 01:40 PM, Gupta, Ajay Kumar wrote:
>=20
> >CPPI4.1 (Communication Port Programming Interface) is a TI specific DMA
> >controller used in multiple TI platform such as AM33x, DA8x, AM35x, TI81=
x.
> >The DMA engine is mainly used by musb controller on above platform.
>=20
>    There are (at least out of tree) platforms using CPPI 4.1 for Ethernet.

if they are out of tree, I'm sorry but we don't care about them. If they
are in tree, then that needs to be sorted out on the same patchset.

> >Earlier version of the driver was submitted by Sergei Shtylyov at [1] but
> >was not merged due to disagreement on the location of driver in kernel.
>=20
>    To be precise, TI requested pulling out already queued (to
> arch/arm/common/) CPPI 4.1 driver from RMK's patch system without
> even notifying me. At least that was RMK's version...
>=20
> >Refer the discussions at [1] for more details.
>=20
> >[1] http://marc.info/?l=3Dlinux-usb&m=3D125087318308323
>=20
>    Unfortunately, that's not all of the discussion of interest.
>=20
> >The new implementation of the CPPI4.1 DMA slave driver will be in the
> >drivers/dma folder, complying to dmaengine framework.
>=20
>    Has there been any work in this direction done yet?
>=20
> >It would involve changes in existing musb driver also for which current
> >plan is to maintain the compatibility of non-CPPI4.1 DMA in musb driver.
>=20
>    I didn't quite understand this part...

how come ? What he's saying is that while moving cppi-dma.c to
drivers/dma he will not move all the other dma engines (Inventra, OMAP,
TUSB-over-GPMC, etc).

> >The task is planned to be spitted into below subtasks.
>=20
> >(1) Post RFC on the API details, changes envisaged in musb driver and ot=
her
> >challenges
>=20
>    First of all, I foresee changes in drivers/dma/ to cope with the
> entity in CPPI 4.1 called the queue manager (there's also buffer
> manager but it wasn't implemented on DA8xx, so I didn't design any
> API for it).

that's why the kernel is open source, right ? If we need to improve the
framework so that it understands other types of DMAs, so be it.

--=20
balbi

--Qgof7w7UksPF5inF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPEI+iAAoJEIaOsuA1yqREioYP/Ahkb5iAtMfalnjWKNEK0QnJ
CX0v0Zv3O9RZdRjlQLzPiGKpryzdi/b7FSQYLB85XMHS1Uqxt3E1MP8hQOZgN80i
GEmgF9apya0170SwIFRkPY0Qne99LdvQH7CTiGEw+9STxNgjxOm8/Bt2Hq0yhFHZ
V5lUH4gyh1oE9ilK/GJsHkE+gwR/mhUvdOiWTNVIkjCfs+unX/fx5uC2U+PJ8MX0
JRi/lNbJpt4vKit67HPb+uWqRkgVYhZknUP03DTHhLh/Ij4s2vUhyx4R1GQUP9n5
2b3bl+HbEf3HrBcajTSL+F8cAfWfs/l4fFZ+FKgEbP4W5+yd/OyvV74xjBqaIJTV
Rt2EaOX8zKAEjycohHjdrPiLqNWmYJIF1hR95HOaAHn01Z3YyHW0wdsK6rHUB59W
dClaU2YabNnA79QUkNxu/s6/DGLOyDV/EhkY7eaxoZzHvEwgY6bKPDYc9RLGaRL0
MPITm3FZhpUtXQNatE/kPD0+3aKpErmELrotMyHw4y2U3SYYXYWSDMcxVT75nwt6
yVM9tZ04phme6X9JFeTT74SK1nxy4SUhlkTyFbRBWoMwUsaKE7UYcR2EFEjwtbEt
Madvj+xuTQgmu7Aw+0OC9/VY7fc01eup9WWDPTroN7RX1ZzwKw3GQtJRepT9wLPH
k0m/cV6yZ9F3R5x0kHGp
=QYmI
-----END PGP SIGNATURE-----

--Qgof7w7UksPF5inF--
