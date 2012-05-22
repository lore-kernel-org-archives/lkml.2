Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756359Ab2EVIZw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 04:25:52 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:43593 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752881Ab2EVIZr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 04:25:47 -0400
Date: Tue, 22 May 2012 18:25:42 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Ingo Molnar <mingo@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the final tree
Message-Id: <20120522182542.655b939d96a8eb67390abb9a@canb.auug.org.au>
In-Reply-To: <20120521091257.GF31407@gmail.com>
References: <20120521185412.aca92107d0a8c4fdd8474e34@canb.auug.org.au>
	<20120521091257.GF31407@gmail.com>
X-Mailer: Sylpheed 3.2.0beta7 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__22_May_2012_18_25_42_+1000_nN+Zq4L5_19BZt1y"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__22_May_2012_18_25_42_+1000_nN+Zq4L5_19BZt1y
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Ingo,

On Mon, 21 May 2012 11:12:57 +0200 Ingo Molnar <mingo@kernel.org> wrote:
>
> * Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>=20
> > Hi all,
> >=20
> > After merging the final tree, today's linux-next build (i386 defconfig)
> > failed like this:
> >=20
> > Invalid absolute R_386_32 relocation: jiffies
>=20
> Hm, that's our fault: seems like a linker bug fallout, one which=20
> we fixed in -tip.
>=20
> > I am not sure what caused this (it may even been a bad merge=20
> > on my part).  I have left it broken for today.
>=20
> While we've fixed this, to simplify merge window integration of=20
> linux-next I've excluded tip:x86/trampoline from the linux-next=20
> branch for now, so this build failure should go away tomorrow.

Weirdly, I still got the same error today.  Any ideas?
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__22_May_2012_18_25_42_+1000_nN+Zq4L5_19BZt1y
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPu02GAAoJEECxmPOUX5FEcRcP/0geJlUURq8i4tABPnSxztmb
+K/7REdeoIBCAckCrXU/GOflnNMTlf5hGG1gVGDPjBol6uUow6eeIAhbcvELUYUp
0xjw/rsIb83m7bLIFDt0IGY8i9Vl4wZBj3QyEQSgZlDOf4TqIaqS4oyR1GYQl6Mh
rMVu+Nr6ALSWue9a2xuSmVgRYnfrgZEGlcedZALTJ+PeWdCPiZxTEQd37ERnlBWh
JJcZjNqC/JDNn9f0aTb36cygGMGrHFLqdv8lkJb86n2GPuzSWRrXOg/ZkKDdqDMA
ZZq9GqMa9xZfwbeV8msyeBBruS1uNNhK+RHQT5qPXRm3K3h4dJvGTuS5pignrTiq
5RXUHGgX8x1GHSQE2M17+sSWC9SNLY7SJa1/1eKl4rHJC6a4NK/ng+u0IdxJ8QRq
K1V9y2jzU6XIyZIZxuZG7AEezPbmevKPfxd/n+UAa8xTWvoZvQg/xbmW0IKLpyV/
f/BJCxEMm+Mj/7BMRmeMSSY3PwSWSZurqLYC3Q75saz8Q2L7DknUgbnncKOwj3WW
ZWrZzRzJ3QMj84Bxdh23S2SjC66mpteb80xrOD5Fw4wyNWBCC7MvOMMvKAt9Rl94
8Y4ONGrS7xJDSiAGKBIi8uLmLXS87kZn6J4j/5GzLFqB6QjAVYGnOuYFwoPbmeTn
7QkNJPHg9zz0mDg6rpg0
=Fmky
-----END PGP SIGNATURE-----

--Signature=_Tue__22_May_2012_18_25_42_+1000_nN+Zq4L5_19BZt1y--
