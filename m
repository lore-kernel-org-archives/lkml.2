Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752749Ab2ARVlR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 16:41:17 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:50160 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752112Ab2ARVlO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 16:41:14 -0500
Date: Wed, 18 Jan 2012 22:41:09 +0100
From: Wolfram Sang <w.sang@pengutronix.de>
To: Austin Boyle <Austin.Boyle@aviatnet.com>
Cc: rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] rtc: ds1307: generalise ram size and offset
Message-ID: <20120118214109.GB21576@pengutronix.de>
References: <1326144071.3096.25.camel@pc786-ubu.gnet.global.vpn>
 <20120111110650.GC2605@pengutronix.de>
 <1326320516.3096.64.camel@pc786-ubu.gnet.global.vpn>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="PmA2V3Z32TCmWXqI"
Content-Disposition: inline
In-Reply-To: <1326320516.3096.64.camel@pc786-ubu.gnet.global.vpn>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--PmA2V3Z32TCmWXqI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Austin,

> This patch generalises NVRAM to support RAM with other size and offset, s=
uch
> as the 64 bytes of SRAM on the mcp7941x.
>=20
> Signed-off-by: Austin Boyle <Austin.Boyle@aviatnet.com>

I'll pick it up with one minor change:

Reviewed-by: Wolfram Sang <w.sang@pengutronix.de>

> +	if (chip) {
> +		if (chip->nvram_size)
> +			ds1307->nvram_size =3D chip->nvram_size;
> +		if (chip->nvram_offset)
> +			ds1307->nvram_offset =3D chip->nvram_offset;

I'd say we can spare the two ifs above.

> +	}

Regards,

   Wolfram

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--PmA2V3Z32TCmWXqI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk8XPHUACgkQD27XaX1/VRvg1ACdG5rK+9CAbViSG3yq5F5m4Khz
kvwAoIdQ9zeBCgAaEWTIsleakJOEz4NW
=dnaM
-----END PGP SIGNATURE-----

--PmA2V3Z32TCmWXqI--
