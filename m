Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932355Ab1J1LZv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Oct 2011 07:25:51 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:65124 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755460Ab1J1LUI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Oct 2011 07:20:08 -0400
X-Authority-Analysis: v=1.1 cv=dCTC1p3vNTdx1H6U0HtbMKjJ9bTEtPwCLJ4qOUv6lx4= c=1 sm=0 a=vhdKIqpQuCYA:10 a=_XxDMTH3fWgA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=meVymXHHAAAA:8 a=idGAMlH7VvsUJbHs6YgA:9 a=QEXdDO2ut3YA:10 a=DHQQ7jDAcw4A:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=zQ2IiNcEVt8mpEQmwGkA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20111028112004.625621555@goodmis.org>
User-Agent: quilt/0.48-1
Date: Fri, 28 Oct 2011 07:16:00 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrew Jones <drjones@redhat.com>
Subject: [PATCH 02/21] ktest: Create outputdir if it does not exist
References: <20111028111558.173726794@goodmis.org>
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

iQIcBAABAgAGBQJOqo/kAAoJEIy3vGnGbaoA7AIP+gKsqw6wmggtc3jdzxtFU9Wm
C7ZsY2OHD9jWArN2/cXzULsH94nox+4ZuhNQ+o1kB/+L7D/MDKq2WDGbXn5DBdGd
cwDAC/A6dniSZYF5bBTi8BEpuSAC/iUbZhqjwVojbl6n1oZU2VJt6NJ1u8FhH/H4
w1dVf+Zd4amEuGk844BVBsYF1j7gN+gGeehEYaLFoXZlxjfxsOXCC4bRTJoghspe
oEuP83dMhhDHmih5+5eUvjGAOVPIVKfAmql3Sou507VZV//tpGZq0refzJ8v5Fp8
2cVOTVwHvRMWm4TZ7dKl48JNz1K5tmOk1EBMeUHTMdIM9WmC63euM1v/OLY0cVTK
ICyAdnrkQLCrYjUIUyrzPKDRMPJ95C4xy40PSSerCGVNuDYrzy3F6zQ92MRn2t1K
S0SOOJty+91HudoiGv0D4eLW7tLGTRMrEfL7mTDYuQdSP8i6WAEjQEEBkJex0hg8
a7TmV+HXIXOlbBPSWhSFcNC2pa0AbdBS3evdRNBfN0m2uv7xRIUv07Ak/IuOlxNK
Whpl7h95COq+ptZk8iErzx+4LKBEChG9ZshTpSndMj+vTbWe3wftARiERvSD+b5J
0vyAYGXHqmMjqXsMtd8364dMYH2XT1sVM7RiMVOS9WxClBb8T7flNmsq2zA5XNaE
kfKIUbOZBGqvZT6t+JLr
=MSit
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
