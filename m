Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751217Ab1GTIZv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jul 2011 04:25:51 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:38749 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751095Ab1GTIZu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jul 2011 04:25:50 -0400
Date: Wed, 20 Jul 2011 18:25:40 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Russell King <rmk@arm.linux.org.uk>
Cc: Kukjin Kim <kgene.kim@samsung.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jaecheol Lee <jc.lee@samsung.com>
Subject: Re: linux-next: manual merge of the s5p tree with the arm tree
Message-Id: <20110720182540.c53726975c8a0b3a48d609b1@canb.auug.org.au>
In-Reply-To: <20110720080441.GA28730@flint.arm.linux.org.uk>
References: <20110720113558.1fb8c2f8392f52c77becf46a@canb.auug.org.au>
	<20110720080441.GA28730@flint.arm.linux.org.uk>
X-Mailer: Sylpheed 3.2.0beta1 (GTK+ 2.24.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__20_Jul_2011_18_25_40_+1000_VOIUi4ju=zHM0w.S"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__20_Jul_2011_18_25_40_+1000_VOIUi4ju=zHM0w.S
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Russell,

On Wed, 20 Jul 2011 09:04:41 +0100 Russell King <rmk@arm.linux.org.uk> wrot=
e:
>
> On Wed, Jul 20, 2011 at 11:35:58AM +1000, Stephen Rothwell wrote:
> > BTW, Russell, commit 29cb3cd208dd above changed the return type of
> > exynos4_cpu_suspend() from void to int but did not add any return
> > statement ...
>=20
> That's fine - it ends with a call to panic() which is declared as a
> function which never returns.  Therefore, exynos4_cpu_suspend() itself
> never returns.

Ah, yes.  Unfortunately, the s5p tree changes removed the panic.  So, I
guess the merge needs some other fixup.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__20_Jul_2011_18_25_40_+1000_VOIUi4ju=zHM0w.S
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOJpEEAAoJEDMEi1NhKgbsC2cIAJlrAyXuQpx8O7Guu3hX8rfe
hU2CPH2/0sexYMtQ/6W9MvAt0e/R6tupwTt+fuNil30coXScZouzPCx0zGJ1pN9F
jNElcH4j69VrWThURZnGuQlanXRFzs8CC9/yc6i81So3xJn04G7VsaJNGzWj+FTj
z/BlXOI9VMbv9jFD5XrYqfdFM77mrtjw+jEyMdLB5xcWrIUjAthz9XZEj1LmD8EA
VsDvS9M1L0b5owfM+F2qs2raRWlt6prP4wEW1J5J9tt4X6Ss1GErHVy+MdBwGsTm
5v9cZCURSOLoqd3dI8OPIfPazM/sIKpi1QriMiZtHMEQjDnwnNyJ7vwvn2XqvjE=
=2b4A
-----END PGP SIGNATURE-----

--Signature=_Wed__20_Jul_2011_18_25_40_+1000_VOIUi4ju=zHM0w.S--
