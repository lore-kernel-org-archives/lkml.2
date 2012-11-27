Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752991Ab2K0X6J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 18:58:09 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:51767 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750909Ab2K0X6H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 18:58:07 -0500
Date: Wed, 28 Nov 2012 10:57:58 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: James Morris <jmorris@namei.org>, linux-next@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: linux-next: unusual update of the security tree
Message-Id: <20121128105758.1f6c6bba9cef4c780e4b3602@canb.auug.org.au>
In-Reply-To: <CA+55aFxxq9a8ZQfcMC1=cKO90zu6hqvfJipt1t0tJy1ypYw30w@mail.gmail.com>
References: <20121128101635.d5e864dffc4252ef9d5e1664@canb.auug.org.au>
	<20121128102800.97a1a4d895f0bfaf72b80272@canb.auug.org.au>
	<CA+55aFxxq9a8ZQfcMC1=cKO90zu6hqvfJipt1t0tJy1ypYw30w@mail.gmail.com>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__28_Nov_2012_10_57_58_+1100_J.eqN0lAGg+7St.l"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__28_Nov_2012_10_57_58_+1100_J.eqN0lAGg+7St.l
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, 27 Nov 2012 15:30:31 -0800 Linus Torvalds <torvalds@linux-foundatio=
n.org> wrote:
>
> On Tue, Nov 27, 2012 at 3:28 PM, Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
> >
> > If that is what happened, it may be worth always using the --no-ff flag
> > to git merge/pull to make sure that the top commit on your tree always
> > has you as the committer (and maybe SOB).
> >
> > Linus, does that make sense in general for maintainers?
>=20
> No. That just hides the real problem - back-merges of random points in hi=
story.
>=20
> Don't do them, people. EVER.

I was also thinking about the case where a developer does work based on
the maintainer's published tree and then the maintainer pulls that work
sometime later (when his published tree has not been updated in the mean
time).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__28_Nov_2012_10_57_58_+1100_J.eqN0lAGg+7St.l
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQtVOGAAoJEECxmPOUX5FEN0AP/ic131sVE73qtpSOJwolvNIS
vxEJ0KswMFHkBl2tGS0LYKO4wlNdaN64Bhxz04besoCtLmgsw0LHkVTdzS4c0syC
QKbHVEYDHa2rprYxXP0MEzm3ULdvHp6mDZjGOpp5IQscXy5aQJfw6BzrZl4fBai8
s1r6l1/bIhQHa3lfBq6oJsTHjvEco3WRG9/9IzccBBYBL8gQvgGtQrA1FfmRAUeZ
PNASugq2ucG4yGDXZC7kMDm1oArQaR17hfuqzGrhBxcMQUFmgUrZ0jreD9Lk9/y1
++scrW1GpeE8qS1CT0BRqc3zSwJmYxtIsHtcfCwH0WqS6tjDewwZg07ty3TdDLR8
mElprEOFWvYifJzBgqio7qlPdS7ligNViCdYvMpHcT26/stscdxVtsIKht4cADfY
JvvQYbrDeq0/PBk004kiabHi2FsJXGtHe1vBvrvv46E6KRaLuli+N/bmEDHbix7O
mG90NynGKXnlz6anY2bxPgY2sD9YRn54SdPuuR8gvaJzdsmVrbA72iMnvoAYxVRp
pgn/F6cn1Eglfyn2guwKOv/7mTryjseYXw47T6EOiQNw+vjTypyf9Dn04oILsThO
juMotth4rvz/+XpCFOWllK9IS/ThUyBK88CrHrtD0ocI7HR4tX37hn/6ZDq97ER2
7ivTkpuvNrFQMw0BmkFh
=9IbN
-----END PGP SIGNATURE-----

--Signature=_Wed__28_Nov_2012_10_57_58_+1100_J.eqN0lAGg+7St.l--
