Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754795Ab1HNVmF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Aug 2011 17:42:05 -0400
Received: from mail.gw90.de ([188.40.100.199]:38274 "EHLO mail.gw90.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754546Ab1HNVmD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Aug 2011 17:42:03 -0400
X-Greylist: delayed 2631 seconds by postgrey-1.27 at vger.kernel.org; Sun, 14 Aug 2011 17:42:03 EDT
Subject: [PATCH] scripts/package/Makefile: Fix typo: s/an deb package/a deb
 package/
From: Paul Menzel <paulepanter@users.sourceforge.net>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org, Michal Marek <mmarek@suse.cz>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-btYkYwgJuCxSHxy9AZBv"
Date: Sun, 14 Aug 2011 22:58:06 +0200
Message-ID: <1313355486.3421.12.camel@mattotaupa>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-btYkYwgJuCxSHxy9AZBv
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

=46rom 8b502382775b22405ed32e1db9c8559acec4b4c7 Mon Sep 17 00:00:00 2001
From: Paul Menzel <paulepanter@users.sourceforge.net>
Date: Sun, 14 Aug 2011 17:53:00 +0200

Signed-off-by: Paul Menzel <paulepanter@users.sourceforge.net>
CC: Michal Marek <mmarek@suse.cz>
CC: trivial@kernel.org
---
 scripts/package/Makefile |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/scripts/package/Makefile b/scripts/package/Makefile
index fa4a0a1..7d55cb3 100644
--- a/scripts/package/Makefile
+++ b/scripts/package/Makefile
@@ -89,7 +89,7 @@ clean-dirs +=3D $(objtree)/tar-install/
 help: FORCE
 	@echo '  rpm-pkg         - Build both source and binary RPM kernel packag=
es'
 	@echo '  binrpm-pkg      - Build only the binary kernel package'
-	@echo '  deb-pkg         - Build the kernel as an deb package'
+	@echo '  deb-pkg         - Build the kernel as a deb package'
 	@echo '  tar-pkg         - Build the kernel as an uncompressed tarball'
 	@echo '  targz-pkg       - Build the kernel as a gzip compressed tarball'
 	@echo '  tarbz2-pkg      - Build the kernel as a bzip2 compressed tarball=
'
--=20
1.7.5.4

--=-btYkYwgJuCxSHxy9AZBv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAk5INtgACgkQPX1aK2wOHVisbQCfcxeSKt39I+wtXPOZxKzgdooL
aSUAniRJKztE3QbS+OpnKWuEF2WwznOk
=c0zp
-----END PGP SIGNATURE-----

--=-btYkYwgJuCxSHxy9AZBv--

