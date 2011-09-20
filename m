Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754669Ab1ITIgQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 04:36:16 -0400
Received: from mail.gw90.de ([188.40.100.199]:46594 "EHLO mail.gw90.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754314Ab1ITIgP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 04:36:15 -0400
Subject: Re: [PATCH][RESENT] scripts/package/Makefile: Fix typo: s/an deb
 package/a deb package/
From: Paul Menzel <paulepanter@users.sourceforge.net>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org, Michal Marek <mmarek@suse.cz>
Date: Tue, 20 Sep 2011 10:36:09 +0200
In-Reply-To: <1313355486.3421.12.camel@mattotaupa>
References: <1313355486.3421.12.camel@mattotaupa>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-WzrCAqA5Xycrp/gX4YaN"
X-Mailer: Evolution 3.0.3- 
Message-ID: <1316507770.5059.4.camel@mattotaupa>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-WzrCAqA5Xycrp/gX4YaN
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Date: Sun, 14 Aug 2011 17:53:00 +0200
Subject: [PATCH] scripts/package/Makefile: Fix typo. s/an deb package/a deb=
 package/

CC: Michal Marek <mmarek@suse.cz>
CC: trivial@kernel.org
Signed-off-by: Paul Menzel <paulepanter@users.sourceforge.net>
---
 scripts/package/Makefile |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/scripts/package/Makefile b/scripts/package/Makefile
index bc6aa00..87bf080 100644
--- a/scripts/package/Makefile
+++ b/scripts/package/Makefile
@@ -141,7 +141,7 @@ perf-%pkg: FORCE
 help: FORCE
 	@echo '  rpm-pkg             - Build both source and binary RPM kernel pa=
ckages'
 	@echo '  binrpm-pkg          - Build only the binary kernel package'
-	@echo '  deb-pkg             - Build the kernel as an deb package'
+	@echo '  deb-pkg             - Build the kernel as a deb package'
 	@echo '  tar-pkg             - Build the kernel as an uncompressed tarbal=
l'
 	@echo '  targz-pkg           - Build the kernel as a gzip compressed tarb=
all'
 	@echo '  tarbz2-pkg          - Build the kernel as a bzip2 compressed tar=
ball'
--=20
1.7.6.3

--=-WzrCAqA5Xycrp/gX4YaN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAk54UHkACgkQPX1aK2wOHVh94wCfYnAlmCb34Huc3ASD185Tz6ag
G2oAnR5LMWYzMUw+NGx3lw9o3hNGdevX
=/eZv
-----END PGP SIGNATURE-----

--=-WzrCAqA5Xycrp/gX4YaN--

