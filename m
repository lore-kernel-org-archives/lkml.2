Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932161Ab2ENTOu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 15:14:50 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:32827 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757521Ab2ENTOt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 15:14:49 -0400
Message-ID: <1337022885.2042.9.camel@koala>
Subject: Re: [PATCH] UBIFS: add crypto lookup field to tree node cache
From: Artem Bityutskiy <dedekind1@gmail.com>
To: Joel Reardon <joel@clambassador.com>
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Date: Mon, 14 May 2012 22:14:45 +0300
In-Reply-To: <alpine.DEB.2.00.1205142032210.12448@eristoteles.iwoars.net>
References: <alpine.DEB.2.00.1205111323010.17715@eristoteles.iwoars.net>
	  <1337001716.2528.56.camel@sauron.fi.intel.com>
	  <alpine.DEB.2.00.1205141907290.12448@eristoteles.iwoars.net>
	 <1337020106.2042.2.camel@koala>
	 <alpine.DEB.2.00.1205142032210.12448@eristoteles.iwoars.net>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-vtxncxwPCgGRk6DEufF1"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-vtxncxwPCgGRk6DEufF1
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2012-05-14 at 20:45 +0200, Joel Reardon wrote:
> I use this because I figured it should be abstracted in functions that
> have these values, but don't need to know about the internal structure.
> From the view of all UBIFS components (except the new keymap), two values
> have no more meaning than one, its all just some value the keymap gives
> out and returns the same key on read_key.

Well, dunno, OK, let's see - we can changes this later if needed. I'll
apply this patch tomorrow.

--=20
Best Regards,
Artem Bityutskiy

--=-vtxncxwPCgGRk6DEufF1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJPsVmlAAoJECmIfjd9wqK0sGIP/20pvklcq9bsxpgdmVY8RRdD
zD4hSNMZhwv2TXXm+O9uQUisui5pveFxL4aPBDBfZYpDZoAokb+yvn6iridS6LZK
+/n1ZX50+6HjAWZ24wTBvzlO8YGmPQs9FYKEtNCP0TMN51x5hKzMEjwV7ooMAmxX
PZ8emy0f7tG/E2zpZ0MUpt/W9Z8ijpem/W7K3eTriKTjkwg0TmXdnyzh/kZobzeL
iHXNHMXddBPfiEYysaKRiphU2Tzpc3NBAI5z0YkfamESo65Uz2b8h3Q7ynju5kQB
yI3CQsuF8WOMrSQl1YhAVAD2FlJqnWuOD889oI48HpKiQrzf7oV6sxl9CuHFOAqd
7kTrgov20ppulHdt/KTI4JaxlgG1nQHp9OnqK6QqiodgS1dCALSf7Rp6iPOrX261
C6kLVFaHW/twk/RuPQFbsNRUs9EZaYukUCAnex8tjy0TQmKj1HFHkiSpQ8Ko5Kyt
dJm6OVFudk0FVQwjxsQ25yc95F15blTyv5NUKrQpPdc2B7v/j0xcGdyk3K+T7bmO
rCC7hJz26V2TtUHKO4ju6xZqc/dwg1GUqYzZKQ3QMSDFGX2g7qy+GGssrzWYVp5k
ngCgL5KKT1P9p24oaAQ7cH45AduDcBMnh0mZWrigeRbTpfLjYY8oFPT9m8w3J6tW
I9RcUjM5ksNguKPgesR9
=rKvC
-----END PGP SIGNATURE-----

--=-vtxncxwPCgGRk6DEufF1--

