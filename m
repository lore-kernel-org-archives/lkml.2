Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755081Ab2DFItY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2012 04:49:24 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:42396 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754735Ab2DFItX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2012 04:49:23 -0400
Date: Fri, 6 Apr 2012 09:49:19 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Laxman Dewangan <ldewangan@nvidia.com>,
        Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH] regulator: rc5t583: Simplify RC5T583_REG macro
Message-ID: <20120406084919.GC3172@opensource.wolfsonmicro.com>
References: <1333670496.2777.0.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="kfjH4zxOES6UT95V"
Content-Disposition: inline
In-Reply-To: <1333670496.2777.0.camel@phoenix>
X-Cookie: Your domestic life may be harmonious.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--kfjH4zxOES6UT95V
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Apr 06, 2012 at 08:01:36AM +0800, Axel Lin wrote:
> Simplify RC5T583_REG macro by removing _vout_reg and _ds_reg parameters.
>=20
> The naming for vout_reg and deepsleep_reg can be replaced by:
> .vout_reg       =3D RC5T583_REG_##_id##DAC,
> .deepsleep_reg  =3D RC5T583_REG_##_id##DAC_DS,

Applied, thanks.

--kfjH4zxOES6UT95V
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPfq39AAoJEBus8iNuMP3d9OwP/iaqFalL/lyrb8LDWvBuW3BP
KX86I65xPZOcvW0YDnvHffd6AVdDS1nMJowkCIUKnqOx1oDrSY1cxwC0M2ws1iqF
S4lQT9Y2A90dkOzQbitawCnPiqKLE6MlAAMlgfJyL3xZ4ZuEi64z6uM/RkI6I9jg
IxZYttzvicBXsbquLLBZ+N6qG1wIHGMtEAwZlR83fmYAwi1Tko8Bz7HUpqPpJSwt
WoNr6T4cRkwZ8/lDqPhZvunzF58KbyeNgFfYkUVsy/j65x6p3RLG2Mwd9be9v5el
KMAqZsa2GfPR+PtXF0tn6Lr1BJx95WIJVGZMOZzw543y/z/ahVyTSsw5WDk41ZZ2
LJRS8VIO25jx8wwW+mMqfpiYldVZ+UbfWBYN/T6kiW5QDDqGesPfljfoFvCdzdJk
W7/Q7+sfcw4fYnr/Rj+AoN/E7DTwcWa/8riEFXie09JvGFZJrqAx5a+AFr2quFXT
VgWPKyeZT7VlXHpBqZwoQWdwkJ/UPlyRoKhDJFxlkibkk2S/cTPr6bAALivKzmJZ
sXb9DXrOKA1sTijUaNHIV3JoGTAWGJx7JbGerFSsN/9Iht9vaUDA5ezUceAtqF4q
6x+dQdTojwnAG2BZ6UEyE2lnRtk25FpCq+jtnG3uRrDdJHgos7kqvA3Eq2zib7j0
0TM3gW1IZDH2Fv4Gp9p3
=bH2v
-----END PGP SIGNATURE-----

--kfjH4zxOES6UT95V--
