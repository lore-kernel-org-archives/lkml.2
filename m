Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759359Ab2INMVl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 08:21:41 -0400
Received: from na3sys009aog111.obsmtp.com ([74.125.149.205]:45496 "EHLO
	na3sys009aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755794Ab2INMVi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 08:21:38 -0400
Date: Fri, 14 Sep 2012 15:16:55 +0300
From: Felipe Balbi <balbi@ti.com>
To: Wolfram Sang <w.sang@pengutronix.de>
Cc: Aaro Koskinen <aaro.koskinen@iki.fi>, Jean Delvare <khali@linux-fr.org>,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-i2c@vger.kernel.org
Subject: Re: [PATCH 1/4] i2c: introduce i2c-cbus driver
Message-ID: <20120914121652.GC20659@arwen.pp.htv.fi>
Reply-To: balbi@ti.com
References: <1346703805-31598-1-git-send-email-aaro.koskinen@iki.fi>
 <1346703805-31598-2-git-send-email-aaro.koskinen@iki.fi>
 <20120914100806.GC2630@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="m51xatjYGsM+13rf"
Content-Disposition: inline
In-Reply-To: <20120914100806.GC2630@pengutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--m51xatjYGsM+13rf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Sep 14, 2012 at 12:08:06PM +0200, Wolfram Sang wrote:
> On Mon, Sep 03, 2012 at 11:23:22PM +0300, Aaro Koskinen wrote:
> > Add i2c driver to enable access to devices behind CBUS on Nokia Internet
> > Tablets.
> >=20
> > The patch also adds CBUS I2C configuration for N8x0 which is one of the
> > users of this driver.
> >=20
> > Cc: linux-i2c@vger.kernel.org
> > Acked-by: Felipe Balbi <balbi@ti.com>
> > Acked-by: Tony Lindgren <tony@atomide.com>
> > Signed-off-by: Aaro Koskinen <aaro.koskinen@iki.fi>
>=20
> OK, I found the short paragrahp about CBUS in the I2C spec, so I2C might
> be an appropriate place. Still, before deciding if it should rather be
> in the core directory, I still have a few questions.
>=20
> Also, does anybody know of a generic bit-banging implementation in the
> kernel which could be used here?

there is i2c-gpio, but it wouldn't help much for cbus, unless we change
it quite a lot. The generic i2c_algo_bit_data would have to be changed
to learn about a 3 wire bus. I guess the impact is much bigger than just
accepting this small, self-contained driver.

--=20
balbi

--m51xatjYGsM+13rf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQUyA0AAoJEIaOsuA1yqREdfIP/2N1Eosj/o1XnLIypmTvHekg
E7JBUADTnZFd+9It4CyPAdeH1GkLVXrtJfofIOwuw8gT3Y1Q0ZypHYpBDWlYwMWx
yrHD5FUqj1wWo1/CFxGckTgLUdMPtN95gL6eW3wMA9lhCfNP7LhxmOapkYR4TSPu
qOKwmJwP4p217GF235JlG6WemXu1uAFAY/WO0vLvYvu4ekNP/IB2YKMbzUqInO4A
wWv5+F4B6RXeyA+wqZRzmnGAzGur68WXQUK91/XpWt2e5922lh0OkJDVqWQ5DXIZ
3+wW/hRkNnzLsvF9HvewTdZzLgzlmVh/Wcg278RDC7xVt8ulW+ymwXK+Oz0rBXC2
a7D//FyyhTxnklTp/6ubR7Fd1Oaz2k9/9K9p3x+alYkkf9GWtm1uZKjlam/xJOo5
a5olmm3/pbMiVoEg2lwlaSxS/VlH4Dsg1tmI9lDIJYZs/CEGFNMnUROs8GjTjrkb
fbPa4apUgf/N1i+LhzuGw0zWRiH8bFqKx4Q/hdB1rFCF6cHP+20Csq7xEk01ujS8
xawgdjW9Xv+cEChBaYvT8u5W1dE4kQYVjhTz95mUEMnJ0S/RXYC3hWLxkDs2tXgs
wA2JXtD8DXz9j0k+gBvaNdfc4aghXHE2n2lBQ1nCCIpdQFjoIf92JpWSasy0l5rk
lYl2ckDWWrrlu9OxNtKe
=25Dt
-----END PGP SIGNATURE-----

--m51xatjYGsM+13rf--
