Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756755Ab2AMAuD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 19:50:03 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:45114 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756690Ab2AMAuB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 19:50:01 -0500
Date: Fri, 13 Jan 2012 11:49:51 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Russell King <rmk@arm.linux.org.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>
Subject: linux-next: manual merge of the arm-current tree with Linus' tree
Message-Id: <20120113114951.7b7f131514437454e5682aa8@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__13_Jan_2012_11_49_51_+1100_.JWQvWMDaYkmYrkL"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__13_Jan_2012_11_49_51_+1100_.JWQvWMDaYkmYrkL
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Russell,

Today's linux-next merge of the arm-current tree got a conflict in
arch/arm/mach-exynos/common.c between (I think) commit 237c78beb8a9
("Merge branch 'depends/rmk/for-linus' into samsung/dt") from Linus' tree
and commit 588ac27d3419 ("ARM: 7273/1: EXYNOS: Fix build error which was
from common.c and old cpu.c") from the arm-current tree.

So this arm-current fi is superceded by the merge above that is now in
Linus' tree.

I fixed it up by ignoring the arm-current version.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__13_Jan_2012_11_49_51_+1100_.JWQvWMDaYkmYrkL
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJPD3+vAAoJEECxmPOUX5FEEl8P/jcffwKGEEpabEMkKUYXyb5w
H+JKVEm2AmPEo7fiqBqyg52ILWYhKPi7KGJFPvLa8m0J83nESs7iDieBk5rwrrT8
IBpKV9XUSUdFw9QmnJ2RnrhwoFor/4JFdoAyXRBewOgpbDyvkqL769izDa+wXUNT
fEKMCkCcKv2g3ncn7rSRuEQLJ3/GPObQ/IvexihUhHblxahqcACXhAvxWjH3wR7K
h7es1a0BxhEmMavRcJEH/yW3jJhy0k1U776OPWINIyI1jcXjLMvmDctnIdlgoYHy
D//5MRyEsx9tvgy7y/13FCbTbhUnCeIX8Kixq6MEgwTkTcZe+uf4vwFwRZXm2H+o
0qTHHkvIid2G8Vh1s4FVxbnGF+Ea4DTQ7XZuC9kmwbmm5wq/EGkIM9qzLfVa5hWf
tRopOlAUpL5ofTGWsXQpbdSapDhi+8yLtgytCpal+zt+7AHAqYzndF7mHV7aWiGL
LV0A0tTAyt3D6vkX9ZdKezb/rY75nD4z+bwoOSnKBFWytqGsKYiK8MqOeiYPJee3
qvCp19TjBkzdXWQMlpsKnrlrGnkTUNK81SagDHA28Nm7h8HMY16qpqZeifLM6RI5
i0j87UvScbROXulk7cQqUzmrqM5VdVnTwOqi9xu/GBa7jhPdLIlihfgco+bizel/
v+7WquZh8Bbjhj1YjCen
=zI5O
-----END PGP SIGNATURE-----

--Signature=_Fri__13_Jan_2012_11_49_51_+1100_.JWQvWMDaYkmYrkL--
