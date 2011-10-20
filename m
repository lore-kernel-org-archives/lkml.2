Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932424Ab1JTKtt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Oct 2011 06:49:49 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:47265 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932383Ab1JTKts (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Oct 2011 06:49:48 -0400
Date: Thu, 20 Oct 2011 12:49:43 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Zeng Zhaoming <zhaoming.zeng@freescale.com>,
        Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        alsa-devel@alsa-project.org, Dong Aisheng <B29396@freescale.com>
Subject: Re: [PATCH] ASoC: Set sgtl5000->ldo in ldo_regulator_register
Message-ID: <20111020104943.GA2379@pengutronix.de>
References: <1319106779.8866.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="r5Pyd7+fXNt84Ff3"
Content-Disposition: inline
In-Reply-To: <1319106779.8866.1.camel@phoenix>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:221:70ff:fe71:1890
X-SA-Exim-Mail-From: w.sang@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--r5Pyd7+fXNt84Ff3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 20, 2011 at 06:32:59PM +0800, Axel Lin wrote:
> Otherwise calling ldo_regulator_remove() does not unregister regulator
> and free memories.
>=20
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Acked-by: Wolfram Sang <w.sang@pengutronix.de>

BTW I think it is better to CC "Dong Aisheng <B29396@freescale.com>"
instead of Zeng Zhaoming; he was lately working with sgtl5000.

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--r5Pyd7+fXNt84Ff3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAk6f/McACgkQD27XaX1/VRvsJACgwyHXZQ5ZH8Ey1S+qG/DMSkwO
JIEAn0LTOghzpAy1Zio4k0ql7QizZ6EB
=qnpr
-----END PGP SIGNATURE-----

--r5Pyd7+fXNt84Ff3--
