Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751695Ab2HRMfy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2012 08:35:54 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:51632 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750856Ab2HRMfw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2012 08:35:52 -0400
Date: Sat, 18 Aug 2012 14:35:27 +0200
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Wolfram Sang <w.sang@pengutronix.de>
Cc: Jean Delvare <khali@linux-fr.org>, Ben Dooks <ben-linux@fluff.org>,
        Daniel Kurtz <djkurtz@chromium.org>, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] i2c-i801: Add device tree support
Message-ID: <20120818123527.GA28701@avionic-0098.adnet.avionic-design.de>
References: <1344409609-1904-1-git-send-email-thierry.reding@avionic-design.de>
 <20120818094846.GA24812@pengutronix.de>
 <20120818111745.GA15702@avionic-0098.mockup.avionic-design.de>
 <20120818121628.GB12839@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="SUOF0GtieIMvvwua"
Content-Disposition: inline
In-Reply-To: <20120818121628.GB12839@pengutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:0DkoCzgbQdMhT/E9yKwu9D2DZt+qvjwQ4n7slUG1kx5
 rgXzva5l4FU8Jh2e2gIUiXCBajDwsnJ59Gobdzduudx3l4Lkt7
 7EMdRyWF3AjNUdnJHZqouCDp+LiLOOuts85Dm2b9mqh0hUxpd8
 xlNDnmn9ODiz6vyG51fewJGa+QAIS1osbd8gfKGtceGYlwSaIW
 oN++g5CGUWoYc6Yu8bH4pQlGcONU+J2kCBM1a/zfOrMCiS97zR
 2W/TRoJidzqCl3WKdHKHofatQxQnHk1ihVBcp0JM89wthCaSC0
 Hx8Y9L9TjaUOrOD8uFHw0Kjvl/P0c8jyewD3ham+q272M1nykq
 SutpE/Uy04a6yf1PZ5vARVzsFrNO2OI5+YMwM1tZ/tXHD9eH+Z
 9NvfLqN8XznqN3uVnDbOtOI3+zyoq7EzRs=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--SUOF0GtieIMvvwua
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Aug 18, 2012 at 02:16:28PM +0200, Wolfram Sang wrote:
> On Sat, Aug 18, 2012 at 01:17:45PM +0200, Thierry Reding wrote:
> > On Sat, Aug 18, 2012 at 11:48:46AM +0200, Wolfram Sang wrote:
> > > On Wed, Aug 08, 2012 at 09:06:47AM +0200, Thierry Reding wrote:
> > > > This commit adds support for probing slave devices parsed from the
> > > > device tree.
> > > >=20
> > > > Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
> > >=20
> > > How are the devicetree nodes of the slaves connected to this PCI devi=
ce
> > > which should not have a node itself?
> >=20
> > The matching is done by pci_set_of_node() and pci_set_bus_of_node().
> > The latter will eventually call pcibios_get_phb_of_node(). What makes
> > you say that PCI devices shouldn't have nodes themselves?
>=20
> I thought to recall that busses which can be probed at runtime should
> not have nodes but should be probed. Maybe that was wrong. Can you point
> me to a dts-file with an example?

That approach doesn't work for I2C controllers, though because you
couldn't attach an slaves to them. The same goes for SPI controllers or
any other dumb busses that can't be probed.

arch/x86/platform/ce4100/falconfalls.dts is an example for an X86
platform where PCI devices have associated device tree nodes.

Thierry

--SUOF0GtieIMvvwua
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQL4wPAAoJEN0jrNd/PrOhHK8P/3m57dktG66Qby1V44+8MHAd
qQVSwaf0ka93ffrDFc8qSDzL0szfQLQyqPNuxDr2Na9zbIXTKBReGqsuMgQpoyLe
R7P5qVTWaXk5zYXE2zItD0QrVYUZPaxCWtxYW22dMPi0u6+CU2AaHj7SjZn8FPNF
GzroNj5hFdO9sEVWTYJaaHzL1SFSaXFj/GGBfamHn9XQhAcdPqSX4A7BLiZ529BA
tEvEsesag3lcU9kgMPspvB7Pth4xuGFsaYasJ6/aMwERwXOTePInJaPVkacaaPu+
Na5GKWEKGNTcfJL9SMeTZQlegG+IhdsoPbJBjaeTZqvVqEbCZ09Uc8jEOE08QQ7D
1pm0Rog4z0KecXhQ8Hm2szFLB9645YQEGZptS9Ahahb+NjiHbJjjm1GfDhp7VvcZ
G9S8r3QM/HmaPNAyA0EbxHjF79NJBHP0bEeZ4Z5fJzD5jx1FmP+WrxfoCA+sYV+h
TsHz9NQpv48r253KFpntBoSwmtE80zAoD7dtF01AQcgIxmwhSlJxjfEtyduA0Noz
iYbHGFAPnil4bbPRFGYWDbjB5iM5P4uugRW+7xfv2Kj97XpXaEomqPotPgCOoKAf
kUZ0UM3dY4TADbOJOepa2ieUeNYxJ63Gl4TJ6uPKHcUGnuKuUoreevIJ1tYm4Hno
W8YcWGACWg6Do/73MZgY
=yR+V
-----END PGP SIGNATURE-----

--SUOF0GtieIMvvwua--
