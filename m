Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752047Ab2GPIPX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 04:15:23 -0400
Received: from na3sys009aog132.obsmtp.com ([74.125.149.250]:32769 "EHLO
	na3sys009aog132.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750897Ab2GPIPE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 04:15:04 -0400
Date: Mon, 16 Jul 2012 11:12:05 +0300
From: Felipe Balbi <balbi@ti.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: balbi@ti.com, "ABRAHAM, KISHON VIJAY" <kishon@ti.com>,
        Greg KH <gregkh@linuxfoundation.org>, grant.likely@secretlab.ca,
        rob.herring@calxeda.com, rob@landley.net, linux@arm.linux.org.uk,
        b-cousson@ti.com, rnayak@ti.com, tony@atomide.com,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC PATCH v2 1/2] drivers: misc: omap: add a new driver for
 ocp2scp
Message-ID: <20120716081204.GI7955@arwen.pp.htv.fi>
Reply-To: balbi@ti.com
References: <1340370942-23201-1-git-send-email-kishon@ti.com>
 <CAAe_U6+dkiQw-i93pFapt6qKrArzaQoE8X3GjDzUDraziG8B2Q@mail.gmail.com>
 <20120625122449.GA30463@arwen.pp.htv.fi>
 <201206251626.09666.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="1E1Oui4vdubnXi3o"
Content-Disposition: inline
In-Reply-To: <201206251626.09666.arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--1E1Oui4vdubnXi3o
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Jun 25, 2012 at 04:26:08PM +0000, Arnd Bergmann wrote:
> On Monday 25 June 2012, Felipe Balbi wrote:
> > > > Can't this live where the scp drivers live?  Actually, where is tha=
t at?
> > > > Do we have scp drivers?
> > > AFAIK, there isn't any driver for scp. But we have a driver for ocp
> > > and it is present at arch/arm/mach-omap2/omap_l3_noc.c
> >=20
> > I don't think this deserves a directory of its own. Maybe
> > drivers/platform/arm/omap/ ?? the l3_noc is an OMAP-specific
> > interconnect and the SCP bus is also an OMAP-specific bus. I don't know
> > of any other arch/soc who uses the same interconnect IP as OMAP and the
> > same ocp2scp bridge. That bridge was created by TI for all I know.
> >=20
> > Greg, would drivers/platform/arm/omap/ work for you ? We could also move
> > the interconnect drivers there.
>=20
> I really don't like the idea of introducing drivers/platform/arm/ because
> very little of the stuff that one would put in there are actually ARM
> specific.
>=20
> I have suggested a drivers/bus/ before and people did not see the need
> back then, and we agreed to continue having a directory for each bus,
> as we have for the big ones (pci, usb, i2c, spi, ...) and a lot of
> simple (amba, rapidio, bcma, ...) or obscure (tc,  vlynq, nubus, ...)
> ones.
>=20
> I think we should reconsider the idea of drivers/bus/ with a file per
> bus in there at least for new buses, but doing a new drivers/scp/
> would be ok for me if there is enough opposition against the idea
> of drivers/bus aggregating different buses.

I don't mind either way. The fact is that this ocp-to-scp bridge is
really a TI/OMAP thing. Not sure it deserves a directory of its own.

--=20
balbi

--1E1Oui4vdubnXi3o
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQA8zUAAoJEIaOsuA1yqRE4JkQALI83LTo9OfM8CoTYh0g7KGd
5TJvXf0AG0WBfCoDlQvZ9j5EgtYRszt3i+M9E+0w+kyvzyGbIJKfLY/IfB4rr3BR
dh79GY4omy6olnD4qU6cKv4lOz36W+LFgbM61ncopuo3zUXMPWy6cgOGnMWnSRFl
XGs53wEWyC0Ya2GB81c5HXXMAlMJYQOwF2yQgQczR9ruS3cVPZbyZwylK/to0cFa
utLMCVH9SZDBEZLtz6krTPf2Msm2paa74FFmDvgQTbkz6Ytz5rOPkmzeqUjapAzx
8EnMrzEBbpRXC+wTmnCNw+Cp5lU2xF4kgWWkE0JITimEQcLPo3/N0BlNnCW3VDEl
oAVJyNpEU1Tgeeby415yiVaUKBKEECVdKXJgalZud4FEnEThyiSqKsw7N4Vsp3aF
iIBO/8Nth/3kdwPvf4hVdC28+rDKqkOPm8hG/qW+eAvKRwb4K5J5Wa9yIAG+QmLl
E+eD+NIHeVb86JmtlLubn9X50mInRV6qVGS2KYkCYHAKiU2oIPRZq/prnahTP9Jx
LJq+/DiHFoyqtsz7rOq8YzGePKKGMRmU4XnaAAJFhRxQBNbLDI8sP0UTpxUFQpEx
/OqeFIacUyw5WgFHmYF6UZJYt22rqDX0Kv5r++/Xg1jKvEgdeqWUIS+89AmuuQ47
2ViplZx5LsFYUuxnn2I5
=uQmT
-----END PGP SIGNATURE-----

--1E1Oui4vdubnXi3o--
