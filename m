Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756233Ab0JSFN3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 01:13:29 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:49075 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750822Ab0JSFN2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 01:13:28 -0400
Date: Tue, 19 Oct 2010 16:13:19 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next: build failure after merge of the tip tree
Message-Id: <20101019161319.92ffcd0d.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__19_Oct_2010_16_13_19_+1100_cidXoX12Rls_7c5s"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__19_Oct_2010_16_13_19_+1100_cidXoX12Rls_7c5s
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the tip tree, today's linux-next build (x86_64 allmodconfig)
failed like this:

/bin/sh: /scratch/sfr/x86_64_allmodconfig/scripts/recordmcount: No such fil=
e or directory

I use O=3D/scratch/sfr/x86_64_allmodconfig in this build.  The same
happened yesterday, but it fixed itself when I rebuilt for other
reasons.  Andrew has also reported this so I applied the patch you
suggested.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__19_Oct_2010_16_13_19_+1100_cidXoX12Rls_7c5s
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMvSjvAAoJEDMEi1NhKgbshboH/jJLNJK1OMJGHQv0K+3Kbfxl
lKxiNVcL/GV4/5Dcnj7QRNB5LVHqw04W0hewQkS7GuGYDEab/KzBkMM5vurugSbd
vNljCSoddcmQs29q5TjlmKo1q8ps/m7b1GRAZB+t8mV0J0rWVC64bszhIBj/huXt
om/OuJTsFb5go8v9kOij8o5VO5HjArCWPnVS/In3C/K+o46ml6/CQ1SQv+AIr6q+
FWYLh7Lp1mEDMFz0HRPz7CE/7vnvpTnO9KhuLmAAQtQ2SZOVYtRAETGX8ZQbbwYs
ueUto/gZaAgIuICMsDpl/aNCjn/Yp50hyMA2E5zCcfuWSDEjuKER8xg5P/XsT8Q=
=QJcf
-----END PGP SIGNATURE-----

--Signature=_Tue__19_Oct_2010_16_13_19_+1100_cidXoX12Rls_7c5s--
