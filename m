Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757400Ab1KPPUz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 10:20:55 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:58536 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756382Ab1KPPUy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 10:20:54 -0500
From: Mike Frysinger <vapier@gentoo.org>
Organization: wh0rd.org
To: uclinux-dist-devel@blackfin.uclinux.org
Subject: Re: [uclinux-dist-devel] [PATCH] MAINTAINERS: update maintainers for blackfin arch and drivers.
Date: Wed, 16 Nov 2011 10:20:50 -0500
User-Agent: KMail/1.13.7 (Linux/3.1.0; KDE/4.6.5; x86_64; ; )
Cc: Joe Perches <joe@perches.com>, Sonic Zhang <sonic.adi@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
References: <1321429708-13862-1-git-send-email-sonic.adi@gmail.com> <1321449126.16478.2.camel@Joe-Laptop>
In-Reply-To: <1321449126.16478.2.camel@Joe-Laptop>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart16732484.K5ChJD6224";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201111161020.53989.vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart16732484.K5ChJD6224
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Wednesday 16 November 2011 08:12:06 Joe Perches wrote:
> On Wed, 2011-11-16 at 15:48 +0800, Sonic Zhang wrote:
> > --- a/MAINTAINERS
> > +++ b/MAINTAINERS
> >=20
> >  BLACKFIN ARCHITECTURE
> > +M:	Bob Liu <lliubbo@kernel.org>
> >  M:	Mike Frysinger <vapier@gentoo.org>
> >  L:	uclinux-dist-devel@blackfin.uclinux.org
> >  W:	http://blackfin.uclinux.org
> >=20
> >  BLACKFIN RTC DRIVER
> > -M:	Mike Frysinger <vapier.adi@gmail.com>
> >  L:	uclinux-dist-devel@blackfin.uclinux.org
> >  W:	http://blackfin.uclinux.org
> >  S:	Supported
> >  F:	drivers/rtc/rtc-bfin.c
> > =20
> >  BLACKFIN SDH DRIVER
> > -M:	Cliff Cai <cliff.cai@analog.com>
> >  L:	uclinux-dist-devel@blackfin.uclinux.org
> >  W:	http://blackfin.uclinux.org
> >  S:	Supported
> >=20
> >  BLACKFIN WATCHDOG DRIVER
> > -M:	Mike Frysinger <vapier.adi@gmail.com>
> >  L:	uclinux-dist-devel@blackfin.uclinux.org
> >  W:	http://blackfin.uclinux.org
> >  S:	Supported
>=20
> Drivers or arches without specific people to maintain
> them really should not have "S: Supported".
> These should really be "S: Orphan".

all the drivers are still maintained.  use the L: option to find the=20
maintainer.
=2Dmike

--nextPart16732484.K5ChJD6224
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iQIcBAABAgAGBQJOw9TVAAoJEEFjO5/oN/WBSVkP+QE9HD9r7b0LPYuXXK+Q5Qfl
KMEauycZi2tcScYGeU00SK3E19VvRLUAjTHdSp4xQw+aBuV0QIVa8EcXw/9F1h/v
2LCATW1b0AdHBmK+ies+kIzb0gACZExrH/y0uRRRYYfGNJCiYQdylFK2V2I8lrFo
hP/5NFz8EATMDAGJ37RAdTAr+JXC9HgxMOrygjPdeQgyRCO3GBEjGcldF48kBbCq
MSi74DCDaqNkjj67xjgQPC6v9E7aN1rv+SGZPCfoRZTGP24s07j8SIl/InH4h6Tt
mtTjKN83MOOoThLhZNw//fzsbER5QiMoL8gRiEINZPIXuuEBkhRACkiYYR05BDPc
Q1wi3fF1UQ9fiWRQyrJ8gEJzfDCn4jvPn7KRhpf8hUqoGoJZsO9zV9JPwLzPLS07
L9vm8PUswTQZ8Kl10WZ7T+J94Nd5qjZOXK8LYIo64dX3OTN3qvNhtjlaMOzko9Ft
pNSA0d8OKoDTlw5oF4+yrWJplMr6llkGU4imXfKEMTzvKKnjMmynCUUswymIwPeD
YqK6FTNjU1cyDcEX6GXaQVH22IJ1mY6htSraLqsHJ5Zv9XDfYUfhJgEFuwIwgIBW
5l3oFjKQkUIZ2FyMnQ3VtSgeF/9w8eKz1U5gHXfOj/bgKKtZX6Z+rJn9oDOeDM1E
RflWeSm7t3UYIZtOfdg6
=Gbeu
-----END PGP SIGNATURE-----

--nextPart16732484.K5ChJD6224--
