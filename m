Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932864Ab0HFIpv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 04:45:51 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:46149 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755364Ab0HFIps (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 04:45:48 -0400
Date: Fri, 6 Aug 2010 10:45:47 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Robert Jarzmik <robert.jarzmik@free.fr>
Subject: Re: [PATCH] regulator: max1586 - fix a memory leak in
 max1586_pmic_remove()
Message-ID: <20100806084547.GB2347@pengutronix.de>
References: <1281072795.24426.3.camel@mola>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="zx4FCpZtqtKETZ7O"
Content-Disposition: inline
In-Reply-To: <1281072795.24426.3.camel@mola>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:221:70ff:fe71:1890
X-SA-Exim-Mail-From: w.sang@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--zx4FCpZtqtKETZ7O
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 06, 2010 at 01:33:15PM +0800, Axel Lin wrote:
> In max1586_pmic_probe(), we allocate memory for max1586.
> In max1586_pmic_remove(), current implementation only free rdev
> which is a member of struct max1586_data.
> Thus, there is a small memory leak when we unload the module.
>=20
> This patch fixes the memory leak by passing max1586 to i2c clientdata,
> and properly kfree(max1586) in max1586_pmic_remove().
>=20
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Like with the max8660-patch:

Acked-by: Wolfram Sang <w.sang@pengutronix.de>

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--zx4FCpZtqtKETZ7O
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkxby7sACgkQD27XaX1/VRtzSwCgzBU9KeiywfzedMWqE9Eob6fQ
zvAAoKlOovy/HX1WdtwflpRF2v78IjRz
=h0mN
-----END PGP SIGNATURE-----

--zx4FCpZtqtKETZ7O--
