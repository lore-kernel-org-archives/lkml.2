Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756719Ab1JQRER (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 13:04:17 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:52648 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753476Ab1JQQ7t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 12:59:49 -0400
X-Authority-Analysis: v=1.1 cv=Aw1K5MWCW/IlYLbVHOK2DHmxtnIeftPoAvmBFvlQMWA= c=1 sm=0 a=vhdKIqpQuCYA:10 a=taZY2NAhKxIA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=meVymXHHAAAA:8 a=idGAMlH7VvsUJbHs6YgA:9 a=QEXdDO2ut3YA:10 a=DHQQ7jDAcw4A:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=1RYEe79mk3PgpC4AAWwA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20111017165947.748741715@goodmis.org>
User-Agent: quilt/0.48-1
Date: Mon, 17 Oct 2011 12:04:57 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Andrew Jones <drjones@redhat.com>
Subject: [PATCH 02/17][RFC] ktest: Create outputdir if it does not exist
References: <20111017160455.498567257@goodmis.org>
Content-Disposition: inline; filename=0002-ktest-Create-outputdir-if-it-does-not-exist.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Andrew Jones <drjones@redhat.com>

Signed-off-by: Andrew Jones <drjones@redhat.com>
Link: http://lkml.kernel.org/r/1313155932-20092-2-git-send-email-drjones@re=
dhat.com
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 tools/testing/ktest/ktest.pl |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/tools/testing/ktest/ktest.pl b/tools/testing/ktest/ktest.pl
index e087cb4..253e9a2 100755
--- a/tools/testing/ktest/ktest.pl
+++ b/tools/testing/ktest/ktest.pl
@@ -2850,9 +2850,11 @@ for (my $i =3D 1; $i <=3D $opt{"NUM_TESTS"}; $i++) {
=20
     chdir $builddir || die "can't change directory to $builddir";
=20
-    if (!-d $tmpdir) {
-	mkpath($tmpdir) or
-	    die "can't create $tmpdir";
+    foreach my $dir ($tmpdir, $outputdir) {
+	if (!-d $dir) {
+	    mkpath($dir) or
+		die "can't create $dir";
+	}
     }
=20
     $ENV{"SSH_USER"} =3D $ssh_user;
--=20
1.7.6.3



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJOnF8DAAoJEIy3vGnGbaoAkIAP/2MYdnaq6JVsJvqBKiFugI6E
4VEnfI0Ks81lF2flgJ5mYD3luf6xTPuojJnyteq7tZlu3crdc4ycqh7Eg9znXQZw
Z+Rkxfeoe/EzgfMR503FIjds+1Os7df7yti/f1/GVgiam+mFEVy48xeVo1+Ac6pM
6xXkiS2P22z70sAk/O9+28t1KZXrRbpp/9K1+xyzRGYypv/iYS+F9awIgHpHHUg5
m945QRo2wIHnw/5H3ldPWKXGRY0ifcR6foShCJ/WmVSIvA4OxGa0OXv+kR5Bn1Rn
rd7VI+bbhP1IbZ0B60clANnrAUXOiiyaZdCz6I0Dm9bSmMeVcnBpMktOVE8hUJ17
4zZuPd7ugTAUp6Ub2rLO+Lq6cpfVSupjXpRyC550voOckAFHwtVzI1z3e4LkVMa1
d9EZM1myxaMBb9JSyNNyOINYXmE7301/5iAcCnOGPKDsUdNVEjirYWck127xZR3T
F0BBi7XMcoSReRgUYMZSxVW7QcaeYFOsIyBlQnIgwnb2pePfyEXwQiIv7a6fMXi7
pNbO+5aVBWkq5DKpFqtV32XSmrOLTC+IWY7hZ06Zfc9YXePa5KMsEHa3QjVhIm6W
DGhhvAUtbL9G4J5Kz30SFtjPoToovep0GeYaL0Ac7DOcvmFc7EA07viZxIwX6i41
YPyC7d2ppdmlavj6yznl
=Fd+e
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
