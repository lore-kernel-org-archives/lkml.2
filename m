Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757803Ab1LGUny (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 15:43:54 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:50355 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757383Ab1LGUnx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 15:43:53 -0500
Date: Wed, 7 Dec 2011 21:43:44 +0100
From: Wolfram Sang <w.sang@pengutronix.de>
To: Tomoya MORINAGA <tomoya.rohm@gmail.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        kok.howg.ewe@intel.com, qi.wang@intel.com, joel.clark@intel.com,
        yong.y.wang@intel.com
Subject: Re: [PATCH] spi-topcliff-pch: Fix count calculation issue
Message-ID: <20111207204344.GC3744@pengutronix.de>
References: <1321511841-12824-1-git-send-email-tomoya.rohm@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="WplhKdTI2c8ulnbP"
Content-Disposition: inline
In-Reply-To: <1321511841-12824-1-git-send-email-tomoya.rohm@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:221:70ff:fe71:1890
X-SA-Exim-Mail-From: w.sang@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--WplhKdTI2c8ulnbP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, Nov 17, 2011 at 03:37:21PM +0900, Tomoya MORINAGA wrote:
> Currently, count value is not correct more than len=3D8193 like below.
>=20
> len	Current-cnt	New-cnt		Anticipated-cnt
> 4095	1		1		1
> 4096	1		1		1
> 4097	2		2		2
>=20
> 8191	2		2		2
> 8192	2		2		2
> 8193	2(NG)		3		3
>=20
> 12287	3		3		3
> 12288	3		3		3
> 12289	3(NG)		4		4
>=20
> This patch fixes the issue.
>=20
> Signed-off-by: Tomoya MORINAGA <tomoya.rohm@gmail.com>

Which branch is this patch based on?

Regards,

   Wolfram

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--WplhKdTI2c8ulnbP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAk7f0AAACgkQD27XaX1/VRu18wCgieyMu97KZviV7ovGE8MjlVzu
nj8An3SOFxGxtu0td6qHmvohCm/abNiU
=Xqwo
-----END PGP SIGNATURE-----

--WplhKdTI2c8ulnbP--
