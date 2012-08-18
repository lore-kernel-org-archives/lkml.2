Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753273Ab2HRTCI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2012 15:02:08 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:50268 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752153Ab2HRTCG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2012 15:02:06 -0400
Date: Sat, 18 Aug 2012 21:01:52 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: Thierry Reding <thierry.reding@avionic-design.de>
Cc: Jean Delvare <khali@linux-fr.org>, Ben Dooks <ben-linux@fluff.org>,
        Daniel Kurtz <djkurtz@chromium.org>, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] i2c-i801: Add device tree support
Message-ID: <20120818190152.GE19802@pengutronix.de>
References: <1344409609-1904-1-git-send-email-thierry.reding@avionic-design.de>
 <20120818094846.GA24812@pengutronix.de>
 <20120818111745.GA15702@avionic-0098.mockup.avionic-design.de>
 <20120818121628.GB12839@pengutronix.de>
 <20120818123527.GA28701@avionic-0098.adnet.avionic-design.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="orO6xySwJI16pVnm"
Content-Disposition: inline
In-Reply-To: <20120818123527.GA28701@avionic-0098.adnet.avionic-design.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--orO6xySwJI16pVnm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


> > I thought to recall that busses which can be probed at runtime should
> > not have nodes but should be probed. Maybe that was wrong. Can you point
> > me to a dts-file with an example?
>=20
> That approach doesn't work for I2C controllers, though because you
> couldn't attach an slaves to them. The same goes for SPI controllers or
> any other dumb busses that can't be probed.

I understand the problem. I was wondering how it has been solved. Thanks
for the pointer, I got the idea now.

> arch/x86/platform/ce4100/falconfalls.dts is an example for an X86
> platform where PCI devices have associated device tree nodes.

Do you intend to send a dts file mainline which needs the patch you sent?

Regards,

   Wolfram

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--orO6xySwJI16pVnm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlAv5qAACgkQD27XaX1/VRsBCgCgnMfKEoOhgv4MIwrZwaDet8Yn
dNgAoJnrGR/qWQYZ1tVDv5kkc9jFHVcQ
=KhcD
-----END PGP SIGNATURE-----

--orO6xySwJI16pVnm--
