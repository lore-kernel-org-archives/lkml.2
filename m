Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752233Ab2KPO60 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 09:58:26 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:35129 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751666Ab2KPO6Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 09:58:25 -0500
Date: Fri, 16 Nov 2012 15:58:11 +0100
From: Wolfram Sang <w.sang@pengutronix.de>
To: Andreas Larsson <andreas@gaisler.com>
Cc: Ben Dooks <ben-linux@fluff.org>, Peter Korsgaard <jacmet@sunsite.dk>,
        linux-i2c@vger.kernel.org, Grant Likely <grant.likely@secretlab.ca>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        software@gaisler.com
Subject: Re: [PATCH v6 0/2]  i2c: i2c-ocores: Add support for sparc, custom
 set and get functions, and the GRLIB port of the controller
Message-ID: <20121116145811.GH7313@pengutronix.de>
References: <1352994659-22392-1-git-send-email-andreas@gaisler.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="NzX0AQGjRQPusK/O"
Content-Disposition: inline
In-Reply-To: <1352994659-22392-1-git-send-email-andreas@gaisler.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--NzX0AQGjRQPusK/O
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 15, 2012 at 04:50:57PM +0100, Andreas Larsson wrote:
> On sparc, irqs are not present as an IORESOURCE in the struct platform_de=
vice
> representation. By using platform_get_irq instead of platform_get_resourc=
e the
> driver works for sparc.
>=20
> The GRLIB port of the ocores i2c controller needs custom getreg and setreg
> functions to allow for big endian register access and to deal with the fa=
ct that
> the PRELOW and PREHIGH registers have been merged into one register.
>=20
> Signed-off-by: Andreas Larsson <andreas@gaisler.com>

Thanks, applied to for-next. I like the outcome, so thanks to Peter as
well.

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--NzX0AQGjRQPusK/O
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlCmVIMACgkQD27XaX1/VRsV8ACff9M6uurXdhW9BO7AN+OJCYXG
w7AAoJLil3f203jkUjMnMRpt75N5l9l7
=1/+0
-----END PGP SIGNATURE-----

--NzX0AQGjRQPusK/O--
