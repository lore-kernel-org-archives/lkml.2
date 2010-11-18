Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756557Ab0KRM22 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 07:28:28 -0500
Received: from ozlabs.org ([203.10.76.45]:49638 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756210Ab0KRM21 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 07:28:27 -0500
Subject: Re: Build regressions/improvements in v2.6.37-rc2
From: Michael Ellerman <michael@ellerman.id.au>
Reply-To: michael@ellerman.id.au
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        Linux Kernel Development <linux-kernel@vger.kernel.org>
In-Reply-To: <AANLkTi=NTGOv+EF_y=__=+P1ud7vqjvoaELPNi6ZhqbE@mail.gmail.com>
References: <alpine.DEB.2.00.1011172027440.14551@ayla.of.borg>
	 <AANLkTi=NTGOv+EF_y=__=+P1ud7vqjvoaELPNi6ZhqbE@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-0lJbuUkcbdUK/N+KMnH+"
Date: Thu, 18 Nov 2010 23:28:26 +1100
Message-ID: <1290083306.22575.12.camel@concordia>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-0lJbuUkcbdUK/N+KMnH+
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2010-11-17 at 20:32 +0100, Geert Uytterhoeven wrote:
> On Wed, Nov 17, 2010 at 20:28, Geert Uytterhoeven <geert@linux-m68k.org> =
wrote:
> > Below is the list of build error/warning regressions/improvements in
> > v2.6.37-rc2[1] compared to v2.6.36[2].
>=20
> > Thanks to the linux-next team for providing the build service.
> >
> > [1] http://kisskb.ellerman.id.au/kisskb/head/3363/ (97 out of 108 confi=
gs)
> > [2] http://kisskb.ellerman.id.au/kisskb/head/3461/ (75 out of 108 confi=
gs)
>=20
> Would it be possible to make sure tagged versions are always built for
> all 108 configs?
> Currently the coverage depends on how soon Linus pushes a new commit.

Hmm. Not in a five minute hack no. I'll think about it though.

cheers


--=-0lJbuUkcbdUK/N+KMnH+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAkzlG+oACgkQdSjSd0sB4dIDowCfSt3a+y1h0s5I6uzTMIOX29Ox
eJcAn2R0OwF99HQu3lqbx/vT4l9q+rsg
=ZCPl
-----END PGP SIGNATURE-----

--=-0lJbuUkcbdUK/N+KMnH+--

