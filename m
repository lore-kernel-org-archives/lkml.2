Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753947Ab0CZDHi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 23:07:38 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:45447 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753848Ab0CZDHh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 23:07:37 -0400
From: Ben Hutchings <ben@decadent.org.uk>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: airlied@linux.ie, linux-kernel@vger.kernel.org, akpm@linux-foundation.org
In-Reply-To: <20100326104042T.fujita.tomonori@lab.ntt.co.jp>
References: <1269401628.18314.264.camel@localhost>
	 <20100326104042T.fujita.tomonori@lab.ntt.co.jp>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-pq7ZsQUAcaQgf46hCMOl"
Date: Fri, 26 Mar 2010 03:07:26 +0000
Message-ID: <1269572846.8653.39.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
Subject: Re: [PATCH 1/2] sis-agp: Remove SIS 760, handled by amd64-agp
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on shadbolt.decadent.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-pq7ZsQUAcaQgf46hCMOl
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2010-03-26 at 10:41 +0900, FUJITA Tomonori wrote:
> On Wed, 24 Mar 2010 03:33:48 +0000
> Ben Hutchings <ben@decadent.org.uk> wrote:
>=20
> > SIS 760 is listed in the device tables for both amd64-agp and sis-agp.
> > amd64-agp is apparently preferable since it has workarounds for some
> > BIOS misconfigurations that sis-agp doesn't handle.
> >=20
> > Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
> > ---
> >  drivers/char/agp/sis-agp.c |    8 --------
> >  1 files changed, 0 insertions(+), 8 deletions(-)
>=20
> Looks fine to me. Hopefully, amd64-agp can handle all SIS 760 systems.
>=20
> Can we confirm that this can fix bugs reported in Debian's bug
> tracking system (which you mentioned earlier)?
[...]

The bug involves amd64-agp screwing with a device that is already bound
to sis-agp.  This patch should be sufficient to work around that.  But
the second patch, to amd64-agp, should actually fix it.  This is not
confirmed but I can try to get the bug submitters to test it.

Ben.

--=20
Ben Hutchings
Once a job is fouled up, anything done to improve it makes it worse.

--=-pq7ZsQUAcaQgf46hCMOl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIVAwUAS6wk6ue/yOyVhhEJAQIhWxAAwmis5bxmSEPgLGQaePu9/RdHce5wrFDd
pcB/4FCYywbbvEyLwqdhd89tD6a1tM2JZU3TnDiE378xWh7vAVKpT44GfsgGZIeN
Gs8FYahqHM6lj+RGh4tQqB6vW4BnJeN+nBjLNZeuaGSCSnD1tD8W+X5MXvv01aF5
8qfshGrrcHTCSTmHEsHBZXy9QlMba1P+WBvuPRKjHA/GmBTRth9Yn1BTPGoYkZz6
rwffRw5hEiVbLg0876Paisu1GbHPzXe9zRL4mRWcJaiOvkaB7JHLFPb1a8vBpQNt
I79T6aJMXpO/1hc2qlss0KgDedQbcxjIOkB2vIfU5wabBNKUG5syIrQjx6KHBQfd
GJYzD7yrSPs4zYgcR7VZM+Z4/KEZ3b+wnKTeVtndtncL9pXhjUo4o1Z3gF+Xc9/T
ghMtXEgKuEASMpuc3cTGl3vYrSooZI5TOyxdLQonz7qQ+2LOBfDYAQ2I/myYEHua
WG2bc1WyG0qYP1VMBJfvSsBOBz2bvZuVV62zHAHZxlLFhaEOMv85FTK7v3vqKU2M
URVHbhIWvpUHS54AwLrgQXB8uYEI1r2qHCB2HbFsUm6MKsMDVpvoMA24UnQyiO7a
wepxrBd1yGyskKNeEx5YnMyzLunGEVn6GZo7cDNcbjjspfqdAffcQsStcsKMaLpq
bwuanRJ0dkc=
=WufM
-----END PGP SIGNATURE-----

--=-pq7ZsQUAcaQgf46hCMOl--
