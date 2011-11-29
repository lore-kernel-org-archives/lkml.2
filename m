Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752875Ab1K2IGZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 03:06:25 -0500
Received: from na3sys009aog115.obsmtp.com ([74.125.149.238]:33470 "EHLO
	na3sys009aog115.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751801Ab1K2IGY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 03:06:24 -0500
Subject: Re: linux-next: manual merge of the arm-soc tree with the arm tree
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Tony Lindgren <tony@atomide.com>,
        Russell King <rmk@arm.linux.org.uk>
In-Reply-To: <201111281911.36341.arnd@arndb.de>
References: <20111128105633.8a8c06afce3cdccb1ce0d7b7@canb.auug.org.au>
	 <201111281911.36341.arnd@arndb.de>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-lyLvMVTx+RZKJbDjTWbn"
Date: Tue, 29 Nov 2011 10:06:17 +0200
Message-ID: <1322553977.1869.1.camel@deskari>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-lyLvMVTx+RZKJbDjTWbn
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, 2011-11-28 at 19:11 +0000, Arnd Bergmann wrote:
> On Sunday 27 November 2011, Stephen Rothwell wrote:
> > Today's linux-next merge of the arm-soc tree got a conflict in
> > arch/arm/plat-omap/include/plat/common.h between commit 4e65331c6bb4
> > ("ARM: 7159/1: OMAP: Introduce local common.h files") from the  tree an=
d
> > commit 13662dc5b177 ("ARM: OMAP: HWMOD: Unify DSS resets for OMAPs") fr=
om
> > the arm-soc tree.
> >=20
> > I did the obvious fixup (see below) and can carry the fix as necessary.
>=20
> Your fix looks technically correct, thanks!
>=20
> Tony, I believe what you actually want here is to move omap_dss_reset
> into mach-omap2/common.h, right?

omap_dss_reset will never be used by omap1 boards, so I think
mach-omap2/common.h would be a good place for it.

 Tomi


--=-lyLvMVTx+RZKJbDjTWbn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJO1JJ0AAoJEPo9qoy8lh71dKUP/0wFNnNLM9BRhTbISdtb+ayF
Oxv1wvIlxZVv/jfAcrKZUYJ8mloa6vB8O3cKKfB9ggGk26SbrEeyt7VCm1pb2QMK
CTko1W4lwVrThu3LO/XytEgw0sp3+0m2xkXnHcNobkdOXGsZuvX9CY1XiKSybh7l
lbJXOMf+tpWWOIlNNzXKlyRqWpgXetyOW/0wcjKjeV29MZY3FTMw9AE/bN5i/X00
Ab7bTg1iLu5eIADSXtd5TGNc0kEbtkdulCREkzdTz1iGU7avhayTS5Lm3SOyxH1f
iRpsrkFBGRCxFDepq0V0n6MFg/thVFdU6GH85s7LKcrgvFOjGteh//gDb/DKnEsB
PgCEIqykvGQMeIatXR7Lyb4hbdhzN+0NCVx8MukaETbQWWc/jYHTnuLmEjPzqhQ2
shqJ2DX3HBtFl+c+ka5FqLp6f7uqyUuLzsNrC8dHHbroLKkjJcRvbmQD08w0/kkK
YAu0+9R1ILtq+GkL77b/nXaHUqEan4QoT96tJqoCJxDy8uvr7yvxP4HoV5KzS0xb
lbcWOk7IQ7n/SlVZEutdETvEj11UCSapJbWaUL6m7XAtfKMamBAcnD/b6KJ/5gPZ
p8WQ/8IhFqWjP2IPsVHl5w0panlYGBpb12NVB3K7xNwRr6tqFmUkAUerZfM5E6uT
r8Emy+kkuf4xKtz/5bqQ
=66ee
-----END PGP SIGNATURE-----

--=-lyLvMVTx+RZKJbDjTWbn--

