Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758628Ab2FHMQ1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 08:16:27 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46614 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755892Ab2FHMQ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 08:16:26 -0400
Message-ID: <1339157775.21665.115.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [ 31/82] mm/vmalloc.c: change void* into explict vm_struct*
From: Ben Hutchings <ben@decadent.org.uk>
To: David Rientjes <rientjes@google.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Minchan Kim <minchan@kernel.org>
Date: Fri, 08 Jun 2012 13:16:15 +0100
In-Reply-To: <alpine.DEB.2.00.1206080341050.4994@chino.kir.corp.google.com>
References: <20120608041845.013957176@decadent.org.uk>
	 <alpine.DEB.2.00.1206080341050.4994@chino.kir.corp.google.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-wO8VPZYG9RM2X2CtNlPg"
X-Mailer: Evolution 3.2.2-1+b1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-wO8VPZYG9RM2X2CtNlPg
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2012-06-08 at 03:41 -0700, David Rientjes wrote:
> On Fri, 8 Jun 2012, Ben Hutchings wrote:
>=20
> > 3.2-stable review patch.  If anyone has any objections, please let me k=
now.
> >=20
> > ------------------
> >=20
> > From: Minchan Kim <minchan@kernel.org>
> >=20
> > commit db1aecafef58b5dda39c4228debe2c845e4a27ab upstream.
> >=20
> > vmap_area->private is void* but we don't use the field for various purp=
ose
> > but use only for vm_struct.  So change it to a vm_struct* with naming t=
o
> > improve for readability and type checking.
> >=20
> > Signed-off-by: Minchan Kim <minchan@kernel.org>
> > Acked-by: David Rientjes <rientjes@google.com>
> > Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> > Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> > Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
>=20
> I'm not sure this is stable material and it wasn't annotated as such when=
=20
> it was commited, why should someone need to upgrade their 3.2 for a patch=
=20
> like this?

It allows the next one (commit dbda591d920b4c7692725b13e3f68ecb251e9080,
'mm: fix faulty initialization in vmalloc_init()') apply cleanly.  So,
unless it causes some harm, I'll keep it.

Ben.

--=20
Ben Hutchings
I haven't lost my mind; it's backed up on tape somewhere.

--=-wO8VPZYG9RM2X2CtNlPg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAT9HtD+e/yOyVhhEJAQqDrxAAzty1VhYgLhEkSo0uB66y3Kj/WJA0FGlY
KGPUdFHfC8iJaGtIUJXtfQRNt4W0SaV33wiGavh51Ua4YQ6ck5go3eDhCyjKQk8S
QTj/vrE7ocj7SYuJVotRTidHW0wHv5jiCqc7MoC6nZS85REKpNfa5ryrIJs8Mp9T
IKYhmtd/r851yFl+Py0UEV1N3extuRv8vIIWWn8JAv1hai3JQRuuJZqcas3DrAwf
SK96EF1Iy7nEvXPULy+KVFIahAZnWUDYy6czLfb6ZG/3l/d0gt8mmTW9rQlOdXLu
gReuATJUi3GWutcDL6braQcKUWs2Uy31b8fESD1NGOx/VK0HoHHGorT6wsOCTukL
CPLIYk1ejhtQW0/Lie+f7f9/HHlfULrDjtlhPpyTigj4OH37QbXxPuFTd9A/GooY
tfWIlOXJWeSRYkhBNccj3z0OCdTROadPTQUu5x2qTmcm96kjT0vtzXF3z7ASqgHR
+wTvhn92xte4aA2NABFnHaeswWxVpjhc2jm+EDogQbeWmgRAyvkjIXmoGyTrgNuw
aw4uwRgVJp2zqk51pPC3ZRxfS2k0LovFizfWO8mevZiff+53Cp3bDF4ftvOorkcF
YlPQU6nzua8qU40r/rsEXzcDBCE1JYfTviNxW8u9NTFcp+HsSywlZgDIbdTDZN0I
l0onwI6LDX0=
=f4oJ
-----END PGP SIGNATURE-----

--=-wO8VPZYG9RM2X2CtNlPg--
