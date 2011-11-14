Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755520Ab1KNRii (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Nov 2011 12:38:38 -0500
Received: from mail-pz0-f42.google.com ([209.85.210.42]:48830 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751406Ab1KNRih (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Nov 2011 12:38:37 -0500
Subject: Re: Proposed change to mtd read functions (Was Re: [PATCH v2 07/16]
 mtd/docg3: add OOB layout to mtdinfo)
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Mike Dunn <mikedunn@newsguy.com>
Cc: David Woodhouse <dwmw2@infradead.org>,
        Ivan Djelic <ivan.djelic@parrot.com>,
        Robert Jarzmik <robert.jarzmik@free.fr>, linux-kernel@vger.kernel.org,
        linux-mtd@lists.infradead.org
Date: Mon, 14 Nov 2011 19:38:53 +0200
In-Reply-To: <4EC1592D.4060304@newsguy.com>
References: <1320912342-30147-1-git-send-email-robert.jarzmik@free.fr>
	 <1320912342-30147-8-git-send-email-robert.jarzmik@free.fr>
	 <4EBECB89.2020102@newsguy.com> <87vcqoiavr.fsf@free.fr>
	 <1321188825.2273.4.camel@koala>
	 <1321189398.2021.5.camel@shinybook.infradead.org>
	 <1321191352.2273.14.camel@koala> <87ehxchta0.fsf@free.fr>
	 <4EC020A2.9070003@newsguy.com> <1321216077.26585.11.camel@koala>
	 <4EC1592D.4060304@newsguy.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-L9pWqu7VAc66rwwzFTUC"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Message-ID: <1321292344.24797.57.camel@sauron.fi.intel.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-L9pWqu7VAc66rwwzFTUC
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2011-11-14 at 10:08 -0800, Mike Dunn wrote:
> This would be better than the cumulative error count over the entire bloc=
k,
> because the highest count on any one page is more significant, I think.

Yeah, although in the previous proposal I also assumed something like
that, not "cumulative".

Just a side note - take my suggestions with a grain of salt - I do not
actively work on MTD any longer so may mislead you :-)

> >  So the SW which does not care, will not
> > require any changes.
> >
> > I am not sure if you'll need to mtd interfaces from mtd->func(...) to
> > mtd_func(mtd, ...) for this or not, though.
>=20
>=20
> I don't (yet) see why I would need to.=20
>=20
> Just adding the argument to mtd->read(), mtd->read_oob(),  would be a sim=
ple
> change, but large in scope, affecting all users of the mtd interface.  An=
y
> advice on how to proceed?

Add the argument without implementing its support, amend all users and
make them compile.

>   Should it be one big patchset, with individual
> patches for changes to mtd, nand, one_nand, mtdchar, each driver, ... ?
>   If it
> is not all merged at once, the build will be broken for the unpatched
> components.  Or is that acceptable, and the patches can be submitted piec=
emeal,
> starting with, say, mtd, nand, nandsim, mtdram, mtdchar?  Or should we
> temporarily create a branch from l2-mtd until we're satisfiled that this =
is all
> stable?

We can create a branch regardless, if you find this useful.

I guess one big patch should be OK. If it causes issues we can later
think how to split it.

--=20
Best Regards,
Artem Bityutskiy

--=-L9pWqu7VAc66rwwzFTUC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJOwVItAAoJECmIfjd9wqK0slcP/j2e4Ob/6401s5NY/FMx+2LE
hyEsaCA84GTnFU+Dnd5QBHkuvgL1RTOJGZh+/YXPgITUN0vTZjkzGxHs5CxVoTYJ
/NCWYmRYw4opuiCttcfhYVJqh3rLZxje04mQFqyhJdaZ+4leX3FKZSvjMxfxCcEh
ZxZq6J+skdzWZbD1UjnUydIwW9+WTf4WJS3hm6DvMcBgvqOjXXa8R/Zxij8KRYCB
H+NqhGLZWs+b3ckipLcH2lS4D4rP77lSniICEc2TgivMbL8ayO6WJ9U268ufVFq3
/Tz6aUpwPtm7aTAZpnVBKTKxiVgkPFYA2Bh+rVgDn77Vw4IzCiFsKkkoUm6cwumP
W7NpKBJaMd5fF3I8iFJidZgWMCLPg8xvctyMrLdDHmm63Z/5vGD1LgJQB+ylYeXY
SRp8rSMkBvVVAly1lTvCTORVpR7TYTr16bnC8jLmYkFVhiETfIu6SzJBL/L7HBIK
pnaox7kQqq6QDAqsWlSsQIqpmxTafFFYCwlXWDIquOEZbGyof3AdrSR3gJgrpX83
FNgrwt3M5x2npfsHBg2nrpYKXbYUlOYGLmrYh/ztU+49rquwNwVHfwGcs7ATVtiT
GPrwWFkFAgtZOcP6p3vG3s81sj6ZfCBAfpabRmxWlPl12lJTpXhFA+JRX+h6qphD
KqWmeb5z5uvq//XdBUxy
=e/+Z
-----END PGP SIGNATURE-----

--=-L9pWqu7VAc66rwwzFTUC--

