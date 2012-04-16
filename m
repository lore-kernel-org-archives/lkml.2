Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752593Ab2DPJTv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 05:19:51 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:60043 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751373Ab2DPJTt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 05:19:49 -0400
Date: Mon, 16 Apr 2012 10:19:46 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH] regulator: core: Fix getting input_uV when supplied by
 another regulator
Message-ID: <20120416091946.GD3238@opensource.wolfsonmicro.com>
References: <1334324105.2732.2.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="fOHHtNG4YXGJ0yqR"
Content-Disposition: inline
In-Reply-To: <1334324105.2732.2.camel@phoenix>
X-Cookie: Beware of Bigfoot!
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--fOHHtNG4YXGJ0yqR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Apr 13, 2012 at 09:35:05PM +0800, Axel Lin wrote:
> When supplied by another regulator, returns the supply regulator's output
> voltage for inpu_uV.
>=20
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Applied, thanks.

--fOHHtNG4YXGJ0yqR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPi+QsAAoJEBus8iNuMP3dAMgP/0KWKkgW4pgKSGod7O4sp5U2
yJDwLHOMGS+SjvI5zxM50bB7q5Av8rYe2mubE3R9sWEuFTpu35lkjVGMrfFfcACh
SrSmXnSmYvZPTUDmV05N23TfJ9oS4Np+VcyBKa5AYg7TlGSRQvIWEIjv0T++JWvk
Hi/CRghPKAA1pWX5KyO4gf6zJ4rpjLE0S06XF51nwHkGZ8Yfu1d4IxO6LTMz578A
dkY8q5l+yokAr1hFrcl5Z35F3L5irjKZY3AE6UjgxCRn2G4h7PLJLBAM1xBpnCpI
6klQ6zi+MftzwQ68PlydKP3tB2epbQwxBA62+g2M625sycMMQHO0QIRk7WmHvEYy
Gt/WlrGBvY6sgYBLm/qErrA26rTzYUjp07rf360JxxrLddT8Ty5h4H2TzffaZBsA
fv84iqb1gQ/vp7KBdbM6LvUfz76UV10VqA4W/14f/v0aSNBalbZuLU2DWL311MED
BDLN7QhuIYZCSweBCs4v1QkDCEguJ9qULwaf/e90yP3uXosy6czSEmSxGzxy9MB1
PNab8g7dT5sZXdSkUoqUhWaBrJoVGkiwSRk5RORRCsCR/E7oAfooLfFXUpjqC9EA
m7Iakl/Xi+lFec0yzs/o8VTbqxlVLeFM7b6HGSjlAYRl9jZV+d0mWLZ0GHolaB9s
VMgBKCzCSCwIdFQU0R0v
=74aK
-----END PGP SIGNATURE-----

--fOHHtNG4YXGJ0yqR--
