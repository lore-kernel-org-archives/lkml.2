Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932261Ab2EWGCs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 02:02:48 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:59885 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752742Ab2EWGCq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 02:02:46 -0400
Date: Wed, 23 May 2012 16:02:33 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Richard Weinberger <richard@nod.at>,
        "Anna-Maria Gleixner" <anna-maria@glx-um.de>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: linux-next: manual merge of the signal tree with the tip tree
Message-Id: <20120523160233.b7f40462715f9e092493517b@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta7 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__23_May_2012_16_02_33_+1000_VmIpvqxR7dkH2DD="
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__23_May_2012_16_02_33_+1000_VmIpvqxR7dkH2DD=
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Al,

Today's linux-next merge of the signal tree got a conflict in
arch/um/Kconfig.common between commit 875c9d09b5a6 ("um: Use generic time
config") from the tip tree and commit 985a94a96d29 ("um: Remove
CONFIG_IRQ_RELEASE_METHOD") from the signal tree.

Just context changes.  I fixed it up (see below) and can carry the fix as
necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/um/Kconfig.common
index 806185d,43ef890..0000000
--- a/arch/um/Kconfig.common
+++ b/arch/um/Kconfig.common
@@@ -53,11 -52,10 +53,6 @@@ config GENERIC_BU
  	default y
  	depends on BUG
 =20
- # Used in kernel/irq/manage.c and include/linux/irq.h
- config IRQ_RELEASE_METHOD
- 	bool
- 	default y
-=20
 -config GENERIC_CLOCKEVENTS
 -	bool
 -	default y
 -
  config HZ
  	int
  	default 100

--Signature=_Wed__23_May_2012_16_02_33_+1000_VmIpvqxR7dkH2DD=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPvH15AAoJEECxmPOUX5FEGhYQAJbCft7qvrMLQWv/Ild0dUBZ
O0NmpUJRJkqs9+XjP84znThe9MWTfsKYVFZkLE34997fseOzD+vAsveK5vjKxTY0
XyIJVti8Im3yeikqsSb63zovYnuq8iqfZLWXUoYxYN8ft1+pDcIamcRlj2qiMJ7t
nB8RBXBwLCzL1WV15NiMQDSaIxmvW2HEg5Yf9KwhkJWrQNqizhTSnGZk3bHG4DYG
0d8fLDMWlI01/LfJ4wlRrpBbGm4H9n5CF6pe+hnd1jComqwRDANbUy+bjiWOYejF
Q+UFmsVW4vh6Q/l0dPPWigijKLa4dKer/2ypwRHeGIiB6uIsJsXXzLD6xkmPCewZ
GEO/955/HS0HaJ4XFv56AlBxtL4Ks1vQatvI3Trw0aoHPot4uGeFVUgN4Suk9pv2
tDdFQDMON3VOm4mngPalhJwf28quYdB7muwud7SoZ3ySEQbI4c2z3WLQjNu0x2wX
ylCY9o49hvWTy9YEavHV1lDwubs+XctZ7YdPJgjofP/fPg9QKoFscDha1sP1GKi5
y1zL0FEpDMWrjICYUkzgI1JqVVr7ya9YhCwtFoQypIHpi4CKqueV5wwayP6rUMlP
1pc706ILUmGKireABPw5AQcytutogjAEFBuG/sEfvCLQKMDX7yvdU4SwiA2w0mWO
/4VN3Ul03R/kZHn/wx6+
=Husw
-----END PGP SIGNATURE-----

--Signature=_Wed__23_May_2012_16_02_33_+1000_VmIpvqxR7dkH2DD=--
