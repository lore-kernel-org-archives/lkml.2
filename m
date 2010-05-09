Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753998Ab0EIXer (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 May 2010 19:34:47 -0400
Received: from ozlabs.org ([203.10.76.45]:35332 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752742Ab0EIXep (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 May 2010 19:34:45 -0400
Subject: Re: [Bug #15589] 2.6.34-rc1: Badness at fs/proc/generic.c:316
From: Michael Ellerman <michael@ellerman.id.au>
Reply-To: michael@ellerman.id.au
To: Christian Kujau <lists@nerdbynature.de>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>, adobriyan@gmail.com,
       schwab@linux-m68k.org, linuxppc-dev@ozlabs.org
In-Reply-To: <alpine.DEB.2.01.1005091519130.3067@bogon.housecafe.de>
References: <10aqDnTJcLO.A.mLE.48y5LB@chimera>
	 <HqroMXsT-CJ.A.DnG.m_y5LB@chimera>
	 <alpine.DEB.2.01.1005091519130.3067@bogon.housecafe.de>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-Cx+W6AuJMtKF04V8Q+IB"
Date: Mon, 10 May 2010 09:34:42 +1000
Message-ID: <1273448082.1431.1.camel@concordia>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-Cx+W6AuJMtKF04V8Q+IB
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, 2010-05-09 at 15:27 -0700, Christian Kujau wrote:
> On Sun, 9 May 2010 at 23:17, Rafael J. Wysocki wrote:
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=3D15589
> > Subject		: 2.6.34-rc1: Badness at fs/proc/generic.c:316
> > Submitter	: Christian Kujau <lists@nerdbynature.de>
> > Date		: 2010-03-13 23:53 (58 days old)
> > Message-ID	: <<alpine.DEB.2.01.1003131544340.5493@bogon.housecafe.de>>
> > References	: http://marc.info/?l=3Dlinux-kernel&m=3D126852442903680&w=
=3D2
>=20
> The bug is still present in -rc6, but Michael Ellerman has a patch[0]=20
> which made the warning go away.
>=20
> @Michael: will you post your patch with a Sign-Off, so that it can be=20
>           pushed into mainline?

No, Benh and I decided it's better to just drop those properties all
together. But it's too late in this cycle for a patch like that just to
fix a warning - so we'll do that patch for 35.

cheers

--=-Cx+W6AuJMtKF04V8Q+IB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAkvnRo8ACgkQdSjSd0sB4dJLUACcDOW1oY8pgDWviiKGYNWTrwBe
SbEAn0P0EwEVSV6wG6nfN044aNwlDxI6
=npWM
-----END PGP SIGNATURE-----

--=-Cx+W6AuJMtKF04V8Q+IB--

