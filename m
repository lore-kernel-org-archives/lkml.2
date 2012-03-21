Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757535Ab2CUQCv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 12:02:51 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:22949 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756302Ab2CUQCp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 12:02:45 -0400
X-Authority-Analysis: v=2.0 cv=Wf+OmjdX c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=UBy9sU4F98IA:10 a=1FcMX4QMhhwA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=nn75H-gwKS6pqWpxH3UA:9 a=CSCtKOopxP_FWJCOBm0A:7 a=QEXdDO2ut3YA:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=i-RPdZmPsE5vI7kBlwwA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20120321160243.202533032@goodmis.org>
User-Agent: quilt/0.50-1
Date: Wed, 21 Mar 2012 12:01:26 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 1/5] ktest: Add INSTALL_MOD_STRIP=1 when installing modules
References: <20120321160125.496052559@goodmis.org>
Content-Disposition: inline; filename=0001-ktest-Add-INSTALL_MOD_STRIP-1-when-installing-module.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Steven Rostedt <srostedt@redhat.com>

To keep the modules from bloating the target's filesystem
strip them during the install.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 tools/testing/ktest/ktest.pl |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/testing/ktest/ktest.pl b/tools/testing/ktest/ktest.pl
index 9507c4b..2b63190 100755
--- a/tools/testing/ktest/ktest.pl
+++ b/tools/testing/ktest/ktest.pl
@@ -1643,7 +1643,7 @@ sub install {
 	return;
     }
=20
-    run_command "$make INSTALL_MOD_PATH=3D$tmpdir modules_install" or
+    run_command "$make INSTALL_MOD_STRIP=3D1 INSTALL_MOD_PATH=3D$tmpdir mo=
dules_install" or
 	dodie "Failed to install modules";
=20
     my $modlib =3D "/lib/modules/$version";
--=20
1.7.8.3



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJPafujAAoJEIy3vGnGbaoAV1AP/RRWp6RkfnXUutl8N0gy2ZQr
x38z+pKIWa1AfK3WmNMqm22COH7BbEJD8pKS7lQ6wCsU+/jJTk/y/4naZoJt9/Sr
Ubt8nzY8kvzmmu9aEZMC3NZRr1p77pdE5CIZwLuA25D7d1Mjj6xfwllbyyVejXjT
BM9dYelxNIdYt67+KvxfH+tUSchfewIucqdVytIEKKkWfX5l4A8gJm5HHdTmWj/a
fSPZZ0zOAwtdsq4pXFk77fsrJ8tlkr1zlsOCpCl+fhNbVabC0hZ6kM6dybEmmUaG
pc07nHl8aydtaZKfp+dLhsJ4RDRIFlQh9n1lErTazGE/Gr6N/VXJMQrVcJqdLXsc
pT5JIGqPBwKWK17sTk0CbB+cgObyUj9hd7o0wf0IyHmnAN6PDw9YjImMGeG5WaML
zdiF9F8Ul/3ElJAvjS+2FYvALIbiDNYLTPk7x+cE2Kf8BMZEu0dX2ysT8MyRtP+1
U3QF7PVB3UR5acue7lg/x4LKCTDWYr7SoR6oHIwbzrLRnpN0WjcuB2JmyhqUbhHk
iYpxHhPoiyGed6DzqheB0XH/JicbaoDXFDpc7u0w5u8q37TfMkLaTOyD1xCZ7ovQ
lw0weAiO5C1Z2C3Z6z4fJRGzlIGZ7naHufz5uEIeHYagtM9DkX8GDVTWtDT9wBkV
HZmbmiKINGc2ZU7G6gP/
=J8JJ
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
