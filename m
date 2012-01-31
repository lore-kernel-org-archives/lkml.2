Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754411Ab2AaNVx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 08:21:53 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:61220 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753200Ab2AaNVw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 08:21:52 -0500
Message-ID: <1328016225.28171.7.camel@sauron.fi.intel.com>
Subject: Re: [PATCH 0/3] platform: add platform_devm_request_and_ioremap()
 common API
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Barry Song <21cnbao@gmail.com>
Cc: Barry Song <Barry.Song@csr.com>, Greg Kroah-Hartman <gregkh@suse.de>,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        workgroup.linux@csr.com
Date: Tue, 31 Jan 2012 15:23:45 +0200
In-Reply-To: <1328015763.28171.2.camel@sauron.fi.intel.com>
References: <1328004002-24646-1-git-send-email-Barry.Song@csr.com>
	 <1328008455.956.30.camel@sauron.fi.intel.com>
	 <CAGsJ_4yVTaZQOE2dB4A3L6WCLE78b4eBPaOcDDJ7RH+0LN=R_A@mail.gmail.com>
	 <1328015763.28171.2.camel@sauron.fi.intel.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-ZmP5SANqvNfJKRfXZHtw"
X-Mailer: Evolution 3.2.3 (3.2.3-1.fc16) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-ZmP5SANqvNfJKRfXZHtw
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2012-01-31 at 15:16 +0200, Artem Bityutskiy wrote:
> On Tue, 2012-01-31 at 20:57 +0800, Barry Song wrote:
> > > If yes, I think it would be nice of you to give a credit to coccinell=
e
> > > and its authors for developing this awesome tool in every commit
> > > message.
> >=20
> > devm_request_and_ioremap() is still something new by commit
>=20
> Ah, ok. But it would be cool if you could create a coccinell semantic
> patch for this, although I should admit this is not very easy, but a lot
> of fun.

To promote the idea further. If you manage to create a semantic patch
for this, then you will just generate your patches automatically. You
will also be able to make it more probable that people will use this new
api by adding your semantic patch to scripts/coccinelle/api.

I do not know how many people run coccinelle, but I recently started to
check all incoming MTD patches with coccinelle before applying them. A
little bit of scripting and this becomes easy to do.

--=20
Best Regards,
Artem Bityutskiy

--=-ZmP5SANqvNfJKRfXZHtw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJPJ+thAAoJECmIfjd9wqK0scIP/R5HGcfZERRauUrwiwKuB3h+
TstSL7bhHcf7LDafx5+ON7NT6hLwsduYzj7FMsvO4+vNbQcD83XCL/1eMDDHc59W
cpiQfqreeEcguLVV1gPKevdQaZY36PVs791QPIfzWlgD5279BrDRvr1Nvk8fUb/N
XUw7Ogbpqa1u8tTRomIhDcCwVrvszoqA8zTn6XdfTQiUG7NH9EmcFp4G94VrUEya
/Y7o8JpH3Wk9tEY1V5cniVjeFOwz81QDstLof3sBPrsLRwOPBV6V9LAjM5J8Q0Uz
HO85QOWP/72sHhlvrU3xfrzAwdRMw8Ww7MnWCZ8YKD+nspzcdX1GomYIhNlAWHS5
LKuKLZyRcuW2FWUKl7z+iGIDJxEq+Qnv+p54YxRHp6/aJvNyTThTuKPLyRvZYetf
lV1I5s7TLDU749R5hpBWuyKCvY7MEWwfcsoE/hrV2OR14WSQvodzlUC13zJ8gmTW
7lY+JWKnC1o/rkgiSCQaYLC7tbkQQ2ibg9gUcDAPh9zz1n9JB65KCjVeWOTwsyqc
cI2sVGLKAcVFzyx22e7eNtGC43tIVX26ALsGJ9LORr/kTdQB+yYM/fzgkuLu0Pbb
wugQXfRR6wWoRODIIAxvBAmI8um9JvZz6CFUL7gPTKlLwX+8DQQkDSm5xMRGUAR/
3KtlrjjQDMmjWKT41OMM
=h6Fr
-----END PGP SIGNATURE-----

--=-ZmP5SANqvNfJKRfXZHtw--

