Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759212Ab2JaCE6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 22:04:58 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:52706 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755609Ab2JaCE5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 22:04:57 -0400
Date: Wed, 31 Oct 2012 13:04:39 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ben Hutchings <ben@decadent.org.uk>, Jiri Kosina <jkosina@suse.cz>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: linux-next: manual merge of the block tree with Linus' tree
Message-Id: <20121031130439.7242d3f12fa7002624c3b1e6@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__31_Oct_2012_13_04_39_+1100_QksZGX5yhTmn4+f5"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__31_Oct_2012_13_04_39_+1100_QksZGX5yhTmn4+f5
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jens,

Today's linux-next merge of the block tree got a conflict in
drivers/block/floppy.c between a set of common patches from Linus' tree
and commit b33d002f4b6b ("genhd: Make put_disk() safe for disks that have
not been registered") from the block tree.

I fixed it up (by using the block tree version) and can carry the fix as
necessary (no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__31_Oct_2012_13_04_39_+1100_QksZGX5yhTmn4+f5
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQkIc3AAoJEECxmPOUX5FEIGAP/3qLcNm8dRrsyIT8Lw1qaTMo
LFiqBHXowQz/p3XOvJJxDpuDGNUZs0Gb0PwCgYEAVU2rEUVn9fbFwb7VGu+t+TQj
UqU+b2Ej7mJju2K4Y++JrLdntTrfRSnr7FhgmokgAvyFqJeMDa6vUIe29i59q989
t8jXS+9Y7V9u5J8X4W/aZGqJ5wVyvn4BK6W8aXuRTa1MJLMrPnrW2kYOWBbdbjq9
Ydg/QBlIsdy7mFxvPt7pnpJ1U9xJlb9dwBdNBDgFGOjVdk+6oA/L4doS1na2fUxr
DNxZb3JeDX62H1RcSUhU81UIaG7saS+DzLNmoUGtxoaZmh6TYfF0k6lHJP1UsnSy
vwdQD1qEqhXmcEbZgGD0cLldpyzjTJsx/2h3CYSX4PQW/nTuGjzNwbnNq3OAUvDT
GUPtFv1F93cJu0uNJyHhwkeA8hDGYVOIMDLt50jv36ZsoKDvUe/NPXBOVxmN2yoo
XpQJPnSWbPmDtyhtNfIBm5zgUDTLv1O1e8qBc/yQQFwUbK8gwfe5YCVPUAIGiONa
xXwc3Qx8/70iMLBhnh3DW5MhG/cquYx6DedeCFIfpP9UGFabgyojQzWBtJy6rT5m
l2mthRqp1CEOZW4JBEFP3MBASlOiPXW7nUheFctlAzyk0P6KfHoqn6y6XvQKjocj
rUqTKuba6SkrE9U1knh6
=6V4o
-----END PGP SIGNATURE-----

--Signature=_Wed__31_Oct_2012_13_04_39_+1100_QksZGX5yhTmn4+f5--
