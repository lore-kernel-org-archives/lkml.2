Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753225Ab2JRAvO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 20:51:14 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:40561 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753074Ab2JRAvN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 20:51:13 -0400
Date: Thu, 18 Oct 2012 11:51:04 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: LKML <linux-kernel@vger.kernel.org>
Cc: linux-next@vger.kernel.org, Linus <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next: stats for v3.7-rc1
Message-Id: <20121018115104.453468c6332984d93cbe8d3a@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__18_Oct_2012_11_51_04_+1100_2ovdA+0eq+ZFn3ca"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__18_Oct_2012_11_51_04_+1100_2ovdA+0eq+ZFn3ca
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Well here are this merge windows' stats:

(No merge commits counted, next-20121001 is the first linux-next after
v3.6)

Commits in v3.7-rc1 (relative to v3.5): 10409
Commits in next-20121001:		10459
Commits with the same SHA1:		 8068
Commits with the same patch_id:		  540	(1)
Commits with the same subject line:	   87	(1)

(1) not counting those in the lines above.

So commits in -rc1 that were "in" next-20121001:	8695	83.5%
						(down from 86.4% last time)
Commits in -rc1 that were not in next-20120722:		1714	16.5%

Again, not too bad, but it would be nice to figure out where the last lot
came from.  I have the "git log --oneline --no-walk" list if someone wants =
them.

Some break down of the onlines list:
	grep for media gives 281 commits
		 drm gives 278
		 btrfs gives 122
		 rbd gives 61
		 scsi gives 58
		 uapi gives 56

As for the 1764 commits left in linux-next ... 1255 are in the kvmtool
tree (most of these are in the tip tree as well - this has been pending a
merge to Linus since before 3.2 ...)

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__18_Oct_2012_11_51_04_+1100_2ovdA+0eq+ZFn3ca
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQf1J4AAoJEECxmPOUX5FEpwoP/1ClDAX4lvH5rnwud9pQrOv9
nJEwSn4C+Ygq5WhEXlruANrWvwyApMaSBqpHuXilHI6Gu91YTfEcRrxtNo9CCFRj
LLpC7DZAzvqm3skx+1L7nipwl8cCBIp4A1tOKpeKYRit08ZdTpq3mg67jpRT6NgX
oLbrZxklsAYTcQJssrKDVYHkybtaK9PyZqB6LLWf2JU7f9BRU2j3Vz/FP/fgK8MT
AhMBD6HgkKTPx9SfQMOwZ2Jv7nur60KmgkT2FdCp8pv0/dd0+4mko/oJyJRHDshR
n0LuH7UmT933le6lDDB109HBfLw2ePmhSwZ3X4nZYMwfvhn1UZIvawVbjJjm0rQ/
8o7kfNpCQLTk8Dkcr3Wj23x1zAzwwLkdx81b2bUZMt7wK1A+tytZ3nDDbi2IV8v3
MA8T0ald3InRK9B1Qr0cxyEtTeFM8aaVkalEcjLmjz4btWOrhrP1OHgHlakADImZ
roQAmhxi90t3sHg7H/iChmqqaGsB+Pn6XEjInlD++hVDk3T9jk25BDjTbNVO1E3B
DvLfJRJhPJDd9VZAnPokAJRx+F0nAwbYzfMwq2F9JCTtPJkrPz+ZM92q/uhrZz0E
jALBY+S9c1zFCCzOjOcX7PNJ5Gk+xiMe7bgzNVne97oZ5wvSv34RFZeN51nAH0Z/
ZrtDoG8/Z//d31dR6yuh
=72+z
-----END PGP SIGNATURE-----

--Signature=_Thu__18_Oct_2012_11_51_04_+1100_2ovdA+0eq+ZFn3ca--
