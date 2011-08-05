Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756845Ab1HEWhz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 18:37:55 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:54783 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752166Ab1HEWhy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 18:37:54 -0400
Date: Sat, 6 Aug 2011 00:37:40 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: Julia Lawall <julia@diku.dk>
Cc: Riku Voipio <riku.voipio@iki.fi>, kernel-janitors@vger.kernel.org,
        Richard Purdie <rpurdie@rpsys.net>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] drivers/leds/leds-pca9532.c: delete useless
 initialization
Message-ID: <20110805223740.GA31186@pengutronix.de>
References: <1312453774-23333-1-git-send-email-julia@diku.dk>
 <1312453774-23333-5-git-send-email-julia@diku.dk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="envbJBWh7q8WU6mo"
Content-Disposition: inline
In-Reply-To: <1312453774-23333-5-git-send-email-julia@diku.dk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--envbJBWh7q8WU6mo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 04, 2011 at 12:29:34PM +0200, Julia Lawall wrote:
> From: Julia Lawall <julia@diku.dk>
>=20
> Delete nontrivial initialization that is immediately overwritten by the
> result of an allocation function.
>=20
> The semantic match that makes this change is as follows:
> (http://coccinelle.lip6.fr/)
>=20
> // <smpl>
> @@
> type T;
> identifier i;
> expression e;
> @@
>=20
> (
> T i =3D \(0\|NULL\|ERR_PTR(...)\);
> |
> -T i =3D e;
> +T i;
> )
> ... when !=3D i
> i =3D \(kzalloc\|kcalloc\|kmalloc\)(...);
>=20
> // </smpl>
>=20
> Signed-off-by: Julia Lawall <julia@diku.dk>

Acked-by: Wolfram Sang <w.sang@pengutronix.de>

BTW LED patches seem to go via akpm these days...

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--envbJBWh7q8WU6mo
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk48cLQACgkQD27XaX1/VRvo0QCgr9txxteL7yxbL+aVvNVQ/XJv
GZ8AniX4IXkwQyKyB08Q3qzCZGpPJQEu
=zTrG
-----END PGP SIGNATURE-----

--envbJBWh7q8WU6mo--
