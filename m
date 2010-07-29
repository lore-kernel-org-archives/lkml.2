Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753563Ab0G2DE2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 23:04:28 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:40549 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752981Ab0G2DE0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 23:04:26 -0400
Date: Thu, 29 Jul 2010 13:04:16 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jason Wessel <jason.wessel@windriver.com>,
        John Stultz <johnstul@us.ibm.com>
Subject: linux-next: build failure after merge of the tip tree
Message-Id: <20100729130416.452c2f93.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__29_Jul_2010_13_04_16_+1000_nGP4EwAObIZlBTsJ"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__29_Jul_2010_13_04_16_+1000_nGP4EwAObIZlBTsJ
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the tip tree, today's linux-next build (x86_64 allmodconfig)
failed like this:

kernel/debug/kdb/kdb_main.c: In function 'kdb_summary':
kernel/debug/kdb/kdb_main.c:2457: error: 'xtime' undeclared (first use in t=
his function)

Caused by commit 0fb86b06298b6cd3205cac2e68a499f269282dac ("imekeeping:
Make xtime and wall_to_monotonic static") from the tip tree interacting
with commit 5d5314d6795f3c1c0f415348ff8c51f7de042b77 ("kdb: core for kgdb
back end (1 of 2)") which was merged before v2.6.35-rc1.

I have used the tip tree from next-20100727 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__29_Jul_2010_13_04_16_+1000_nGP4EwAObIZlBTsJ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMUO+wAAoJEDMEi1NhKgbsN/sH/RlbT5Cc7WRpvqjbo5Iy3kF0
cSTjBeISnq+KrRCyl3/+h0Jvomi2FBaOohB1KNVmVwOygoO2pBQwrVOmTWCNeVAp
o+unossNd8fb8/MXqh+CjrKFjPpbR13oCh5x4w2GXCpy3RVUQyBnuSOZu6SZ+syX
HOItV4+YM8JP6v/mMr227g48mYyITAiwaR7ZNlhVMfbGwIHDDFE29jdBPXoJdBTm
fVrhuHxUiMwyGlAbLdUwQ3cf/o1m8vlaeksJBCEsJm08ZykYSmE7kjHCJwSYVLdp
ZXtn+XpKpU5EgKsDZp9XbC+7xMsysV1Fb43s50hzI5zo/ke6ik/l+YD+ZGe2pmg=
=MC0f
-----END PGP SIGNATURE-----

--Signature=_Thu__29_Jul_2010_13_04_16_+1000_nGP4EwAObIZlBTsJ--
