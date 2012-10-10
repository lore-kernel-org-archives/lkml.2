Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755448Ab2JJDG4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 23:06:56 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:52560 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753290Ab2JJDGx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 23:06:53 -0400
Date: Wed, 10 Oct 2012 14:06:44 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Michel Lespinasse <walken@google.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next: manual merge of the kmemleak tree with Linus' tree
Message-Id: <20121010140644.0235454126ca50b7f60d1f59@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__10_Oct_2012_14_06_44_+1100_b_W8ttHqbt8vB852"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__10_Oct_2012_14_06_44_+1100_b_W8ttHqbt8vB852
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Catalin,

Today's linux-next merge of the kmemleak tree got a conflict in
mm/kmemleak.c between commit 85d3a316c714 ("kmemleak: use rbtree instead
of prio tree") from Linus' tree and commit 48786770bf3b ("kmemleak: do
not leak object after tree insertion error") from the kmemleak tree.

The kmemleak tree commit has been there since April, should it have
progressed by now?  Its fix is also included in the above commit from
Linus' tree.

I just used the version from Linus' tree and can carry the fix as
necessary (no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__10_Oct_2012_14_06_44_+1100_b_W8ttHqbt8vB852
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQdOZEAAoJEECxmPOUX5FEgj8P/31Zo6LbpGzLI+BZX0qZtzVy
McPoTzoQLm6qTn8dwU4mv4Jx/hEIjF703XER6KNX49LC5lVqFbCWrW0Sb0G79hsK
zT4w4l2lpH+Bu+HIW8bM4DM1tRhchcTif1ZXWpizvKzCs42nFjC9A05gitqfm9du
JEryF9SA35GPDJQJEvAK25lvOp6kiOD8NaeyGwA/mE1MiGol4whgJJpJ1CJwplcK
asjOs1K/JPhsui/+n5M9dy7o2emLZeOyWagbfxttsZmnQSR4pL7Sduv/JyBhFaAE
KodzI8wdczwe2JdIsJEI+7EwH4rOUItNCb1d5sSvpVl9p8i84/T/6hRskjb9s7qR
1M4KDwDXRUUYLnjuozI3t+w0PABqF2daNA6/PKZDqGNWZd0G0+u3j8bSUv1zFxiM
4Gr/lGhWRrbk25tYLCQbqaCj0MaXkCOrAWiOAw0KVI4FK2UNGUjvtue7l1vIKjVX
Za/QJ1bMB4fgXb6mikp/ao7IQVZXtecDaDXXhIJ3B12HVCS9F56ccm5UUfAL8Fvy
xYIWx955QKV/R2z593bmZmLcLbZmbvnKb+WQuhI75mNz64yCVtQDMCxNqt2i6n0A
Ud9yRoZZYqXvkoXEJ0ex/N4FE2vpLWjGVnWtueR5hFQDoBcalt3sYZhh4Nypu9U/
cLEKPKMlujkQt1OMsjNW
=Tg4a
-----END PGP SIGNATURE-----

--Signature=_Wed__10_Oct_2012_14_06_44_+1100_b_W8ttHqbt8vB852--
