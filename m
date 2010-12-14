Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756415Ab0LNLdy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 06:33:54 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:42677 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750935Ab0LNLdx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 06:33:53 -0500
Date: Tue, 14 Dec 2010 22:33:39 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: sedat.dilek@gmail.com
Cc: Sedat Dilek <sedat.dilek@googlemail.com>, Nick Piggin <npiggin@kernel.dk>,
        Nick Kossifidis <mickflemm@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Hutterer <peter.hutterer@who-t.net>
Subject: Re: linux-next: Tree for December 14 (New tree: vfs-scale)
Message-Id: <20101214223339.5bf5db49.sfr@canb.auug.org.au>
In-Reply-To: <AANLkTi=LG5Sbnu-_gHu5C0-mowBUAPWBmNHn0+e6LTyZ@mail.gmail.com>
References: <AANLkTi=LG5Sbnu-_gHu5C0-mowBUAPWBmNHn0+e6LTyZ@mail.gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__14_Dec_2010_22_33_39_+1100_Qqgd0VMwYoBmzD+4"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__14_Dec_2010_22_33_39_+1100_Qqgd0VMwYoBmzD+4
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Sedat,

On Tue, 14 Dec 2010 10:38:35 +0100 Sedat Dilek <sedat.dilek@googlemail.com>=
 wrote:
>
> [ QUOTE ]
> Hi all,
>=20
> [The mirroring on kernel.org is being slow again ...]
>=20
> Changes since 20101213:
>=20
> New tree: vfs-scale
>=20
> The vfs-scale tree gained a conflict against the fuse tree.
>=20
> The ieee1394 tree lost its build failure.
>=20
> The wireless tree gained conflicts against the wireless-current tree.
>=20
> The sound tree lost its conflict.
>=20
> The input tree gained a conflict against Linus' tree.
>=20
> The voltage tree gained a build failure so I used the version from
> next-20101213.
>=20
> The swiotlb-xen tree lost its build failure.
>=20
> The cleancache tree gained a conflict against the vfs-scale tree.
> [ /QUOTE ]
>=20
> First of all congrats to all involved parties so that the work of Nick
> was accepted as "vfs-scale" into linux-next!

The "Nick" associated with the vfs-scale tree is Nick Piggin (cc'd).

> I played yesterday with the new refreshed patchset (manually merged
> and fixed) against systemd-v15 with kgdb/kdb.
> Oh yes, there is a "dmesg" command :-) and with "btp $pid" I yesterday
> night saw a NULL dereference in the backtrace.
> Currently, I am compiling linux-next (next-20101214) and will take
> some pictures with my digicam.
>=20
> Some recommends (not that I want to teach you as GIT is for me new
> playground and I follow mostly the commit-messages, which not means I
> understand the complexity of the patchset), but ...
>=20
> 1. Please give commits a proper/sane "commit subject"
> "Build fix" or "Fixed build failure" is not saying much.
>=20
> 2. Add credits for people investing time to test and report
> Same commits did not have also credits for people reporting the build fai=
lures.
> A reference to LKML posting would be fine in the "commit-body" (sorry
> for my comparison with Email, do not know the GIT term).
>=20
> This all is not to punish you, it is for following and documenting the
> whole process.
>=20
> Peter Hutterer has a wonderful blog article "On commit messages"
> concerning this topic.
> If all of us would follow them, the working-together will be more fruitfu=
l.
>=20
> My 0.02EUR.
>=20
> - Sedat -
>=20
> [1] http://who-t.blogspot.com/2009/12/on-commit-messages.html

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__14_Dec_2010_22_33_39_+1100_Qqgd0VMwYoBmzD+4
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJNB1YTAAoJEDMEi1NhKgbsfusH/RBtNDxKtso8jDPsARFjcq30
yBl3SY6kakfGgqlAykzqG5NDpaAhejvf3MPb3rvRwI74saQ9ZVd2IWaGktqbOQLj
Rk9r1k18smA4LB9MzGLZnOREYEmTwtDnkAUM+rstb2tn2PWzkQIvXoby5yJ5NV8E
Uss9VGWIWdkfzUhFMZtm2ZQxwSRQjYI4kCakm6SAXRC42umv3U8/Re8Xwcd9+JlG
OUw/t+qzpCy7IMWc8x4NsvY1tfFW6s+BJUKC1pS/KJzo2uBz5i4bpUR05UqQdxkY
c2h6NU8e+OcT6DZF6TMP9aeScwONg5ordky9MP9CfZ1TZV0Xf8ufwt8FUJK6DM4=
=j4nb
-----END PGP SIGNATURE-----

--Signature=_Tue__14_Dec_2010_22_33_39_+1100_Qqgd0VMwYoBmzD+4--
