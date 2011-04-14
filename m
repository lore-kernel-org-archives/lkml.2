Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753943Ab1DNAFf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 20:05:35 -0400
Received: from ozlabs.org ([203.10.76.45]:54125 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752572Ab1DNAFe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 20:05:34 -0400
Subject: Re: Build regressions/improvements in v2.6.39-rc3
From: Michael Ellerman <michael@ellerman.id.au>
Reply-To: michael@ellerman.id.au
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        Tony Breeds <tony@bakeyournoodle.com>
In-Reply-To: <BANLkTinT09RGg5XDUGy76Kpa8yX3DNUoQw@mail.gmail.com>
References: <alpine.DEB.2.00.1104131835280.32045@ayla.of.borg>
	 <20110413.103233.193707113.davem@davemloft.net>
	 <BANLkTinT09RGg5XDUGy76Kpa8yX3DNUoQw@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-F2glOxCkJz1ka/oH2qrF"
Date: Thu, 14 Apr 2011 10:05:33 +1000
Message-ID: <1302739533.12513.32.camel@concordia>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-F2glOxCkJz1ka/oH2qrF
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2011-04-13 at 19:38 +0200, Geert Uytterhoeven wrote:
> On Wed, Apr 13, 2011 at 19:32, David Miller <davem@davemloft.net> wrote:
> > From: Geert Uytterhoeven <geert@linux-m68k.org>
> > Date: Wed, 13 Apr 2011 18:35:45 +0200 (CEST)
> >
> >> 47 regressions:
> >>   + build/linus_sparc64-allmodconfig_sparc64/usr/include/linux/ethtool=
.h: error: expected specifier-qualifier-list before '__u32': 104, 90, 21, 2=
82, 389, 460, 521, 444, 96, 297, 82, 57, 291, 258, 231, 482, 209, 510, 265,=
 113 =3D> 104, 538, 90, 21, 523, 552, 266, 445, 292, 96, 82, 512, 563, 57, =
259, 283, 298, 484, 390, 231, 209, 462, 574, 113
> >
> > I do allmodconfig builds on sparc64 systems every single day using
> > various versions of gcc-4.4, gcc-4.5, and gcc-4.6
> >
> > And I never ever see this build error.  Never.
> >
> > If you're using a cross build environment, maybe something isn't quite
> > right with that?
>=20
> As it mentions `/usr/include/linux/ethtool.h', it seems to be an
> include that's part of the
> cross build environment.
>=20
> I'm just using the logs from the linux-next build service...

Which is just using the cross compilers that Tony builds ...

I'll have a look and see if we can work out what the problem is.

cheers

--=-F2glOxCkJz1ka/oH2qrF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAk2mOk0ACgkQdSjSd0sB4dJmcQCgnVrhnrPFGCUc3PGTwM0/WwZc
px4AoKg5ptWdIvqRZ1Xh7YAEd7V3E5Tq
=2YCl
-----END PGP SIGNATURE-----

--=-F2glOxCkJz1ka/oH2qrF--

