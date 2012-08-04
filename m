Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752687Ab2HDFn2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Aug 2012 01:43:28 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:54699 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751068Ab2HDFn0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Aug 2012 01:43:26 -0400
Message-ID: <1344059003.1716.5.camel@kyv>
Subject: Re: Linux 3.6-rc1
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat, 04 Aug 2012 08:43:23 +0300
In-Reply-To: <CA+55aFz322dKXUwtmrrW=nfp5XJa5ACh1syE8RXOOdcA7V_76A@mail.gmail.com>
References: <CA+55aFy4vnD5-8SWF_WDC3oTGotzkDg2_4=YHXd6qMiJ=OKekw@mail.gmail.com>
	 <1343976472.1730.18.camel@sauron.fi.intel.com>
	 <CA+55aFz322dKXUwtmrrW=nfp5XJa5ACh1syE8RXOOdcA7V_76A@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-qia7nQyBxzea5FfrtOpC"
X-Mailer: Evolution 3.4.3 (3.4.3-2.fc17) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-qia7nQyBxzea5FfrtOpC
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2012-08-03 at 13:23 -0700, Linus Torvalds wrote:
> On Thu, Aug 2, 2012 at 11:47 PM, Artem Bityutskiy <dedekind1@gmail.com> w=
rote:
> >
> > We have had 11 of 13 pieces of the 'sync_supers()' removal patch-sets
> > merged. The 12th piece removes dead code in exofs was supposed to go
> > through the exofs tree and blocked the 13th piece which removes
> > 'sync_supers()' and was supposed to go via the VFS tree.
> >
> > Both 12th and 13th pieces zap dead code. I man not sure delaying that t=
o
> > v3.7 would be very beneficial for the kernel (why having a useless
> > thread waking up every 5 secs?). Would you let us merge this to -rc1?
>=20
> Ok. I'm pulling the exofs changes, they're small and remove more lines
> than they add. And if the last piece then just kills dead code, I
> won't mind that either.

Thanks Linus. Yes, the first patch of the series removes dead code, and
there are additional patches which amend comments and documentation
without touching any functionality, just remove words pdflush, s_dirt,
and write_super.

--=20
Best Regards,
Artem Bityutskiy

--=-qia7nQyBxzea5FfrtOpC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJQHLZ7AAoJECmIfjd9wqK0WwUP+gOKFYeqOj7GG23fKPwVOEFd
B/S0yATCYIMl+Nj9iMQjK0Ubyz6EoubkxQXd6prd5nK2QUFAPRyjYoZ636GO9OEz
ShofUFjHisapnEvPLjypygCSzffUksRivwe2Ah2Jk2xnjoNv7i++bpXzrFhz+UNI
QY0l6QczEisXZ2YzYyEWZwMRxNPGcOE2AFRP/J/QdoVzWLyB6PZH458Y3aSWbiDO
dGQ7NVVXFuBzWna7nIxa+x8rrR0qzoBUBgBpYWk6K1HBCoEJLaruxCt9sjAD4RGD
kYLN5x5ZlDQWChWiEy7Rw3IATt0qKvQdo94mmiHFWhmjcfrdL9ISONAXfPNWA4fX
xd2B6OczaSgYMwkX4DDrC82PMNCz62WX3l3QQbsu5I5UXUhynlEt3S6LhxvrSrt4
8WmXieEzlICzKfLXPhcNOgkD3jI6+/EgvQOylYN0FGlOGk5qWSrBSIKZXZo3vjsD
4wRBDb+5EWOqzq+LOWjQOknd5hdOym6La0Km/CKCnJQ7iIYhs8cR/QB9sUzaYHNH
f7HoY3ZW1ANbLOcP+KBbF+uOHOVJLlT34Vmdu7HmX7EaKkPByKd8vg/wtdCCqH2f
TCpMKgdDG6hVm8wPvcGnXg6+CDiOgu4vlhGy0rhecIexXC2FXKOgJ2UtHyFGEJ+b
SK5W7qyEVU4ETHOlwA+P
=jPy/
-----END PGP SIGNATURE-----

--=-qia7nQyBxzea5FfrtOpC--

