Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751601Ab2LPXAe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2012 18:00:34 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:40275 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750713Ab2LPXAd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2012 18:00:33 -0500
Date: Mon, 17 Dec 2012 10:00:22 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Chris Mason <chris.mason@fusionio.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Stefan Behrens <sbehrens@giantdisaster.de>,
        Josef Bacik <jbacik@fusionio.com>,
        Linus <torvalds@linux-foundation.org>
Subject: linux-next: build failure after merge of the btrfs tree
Message-Id: <20121217100022.7d751dc9075d60a33d636a23@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__17_Dec_2012_10_00_22_+1100_Z7=XO33jOK2Ef9.7"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__17_Dec_2012_10_00_22_+1100_Z7=XO33jOK2Ef9.7
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Chris,

After merging the btrfs tree, today's linux-next build (powerpc
ppc64_defconfig) failed like this:

fs/btrfs/ioctl.c: In function 'btrfs_ioctl':
fs/btrfs/ioctl.c:3940:7: error: case label does not reduce to an integer co=
nstant

Caused by commit 0aa7cbc7585a ("Btrfs: add support for device replace ioctl=
s").

I have used the btrfs tree from next-20121214 for today (which was empty).

I have to say that these btrfs commits have come to linux-next very late
in the game (i.e. some of them have author dates back in September and
October and yet they only appeared in linux-next today).  Also, the
committer of this commits is Josef Bacik <jbacik@fusionio.com> but there
is not Signed-off-by him.  There are other commits that are committed by
you, Chris, that also do not have a Signed-off-by you.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__17_Dec_2012_10_00_22_+1100_Z7=XO33jOK2Ef9.7
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQzlKGAAoJEECxmPOUX5FElLYQAIonBZBsXhJHf7tsCnQOAyPr
ksgMyTgWcUTWujjWNYCtj3KToIX/1aYVyLYVEQsKTRO0fwh+wR4QQGR3G6QE0B6A
UtRRCtwS9DEWz89UlpNXemAW0uPOjdDlDy7zeOB9yQQwNQmMORNDDHeuHWxI3eJ7
KI4aM7vDMts8wC5Ce2jgpq8nRsLL7fwOwOUoze/MquvY2UzDXwmxrwediOn/6BVr
5XPGs/92V85ln5pkdsEekY28poF1HWIZhvR60cIR/lXjcZU+LgmI+fsiu4otOB5G
I5RJfF+PNlEzADXOeKTLsOTEEgnrWz+kxo21G/X1xo4fF7FxE1j4tJWxlRD/7+5r
C9oS3jiBVJCQytSK86rxHnxjYvYt2NKn2/hQ6qmOuIx8tup2L2YQsm/7wCsaIP/d
azbxLVmUHCUCy+rxSV05xmPyLOLyFcTuTOHMP8IU9SWE/g4K4NxjgFZi5g+H5Qgs
TgqqXherAer51Ce/aCAnx1se7R2+alxEQkS8aGe63mKEvZ1tYbh9+1KMZ2I5MVWP
JKC7jP6KG+LbmNpThtGP+x7yfvMHKAZzGAtuFjvD1sXB5T9G4St5XfyH4O8yCw1J
lvD7li6uZGsWe1fLj4xkpYjxWNKw8bI1HS/vEFvDcds43EDUKDmVkHLI0dXtH6Kc
FUyED5uqwJwEqoxta8C7
=ZHdb
-----END PGP SIGNATURE-----

--Signature=_Mon__17_Dec_2012_10_00_22_+1100_Z7=XO33jOK2Ef9.7--
