Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932346Ab1J1LUw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Oct 2011 07:20:52 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:65409 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932242Ab1J1LUt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Oct 2011 07:20:49 -0400
X-Authority-Analysis: v=1.1 cv=dCTC1p3vNTdx1H6U0HtbMKjJ9bTEtPwCLJ4qOUv6lx4= c=1 sm=0 a=vhdKIqpQuCYA:10 a=ATFRSapDumwA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=gnj8GDxqMiKf3zo8JvYA:9 a=QEXdDO2ut3YA:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=AdKii74MTqtOEPo9Ql4A:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20111028112043.880563301@goodmis.org>
User-Agent: quilt/0.48-1
Date: Fri, 28 Oct 2011 07:16:18 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 20/21] ktest: Add variable ${PWD}
References: <20111028111558.173726794@goodmis.org>
Content-Disposition: inline; filename=0020-ktest-Add-variable-PWD.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Steven Rostedt <srostedt@redhat.com>

Adding the variable ${PWD} that equals `pwd` makes the config files
much simpler.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 tools/testing/ktest/ktest.pl |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/tools/testing/ktest/ktest.pl b/tools/testing/ktest/ktest.pl
index 652446d..9d9ee32 100755
--- a/tools/testing/ktest/ktest.pl
+++ b/tools/testing/ktest/ktest.pl
@@ -136,6 +136,9 @@ my %force_config;
 # do not force reboots on config problems
 my $no_reboot =3D 1;
=20
+# default variables that can be used
+chomp ($variable{"PWD"} =3D `pwd`);
+
 $config_help{"MACHINE"} =3D << "EOF"
  The machine hostname that you will test.
 EOF
--=20
1.7.6.3



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJOqpAMAAoJEIy3vGnGbaoAhu8QAOt8LVQC2UJl1LgFOkXpiGcZ
TGixP6zTbyEzji1Aff+Y8sinBnzhxD7046btVcb0w4woIfdWoy+6zLNVUkZV2Hya
Vezu99voP+HqXrA6T1ZYIMr+i8VmcYeb3cQL2DJSsJkRLB6DvACLpzcV0WA8etts
9XBsCHPF/9id9pq8btS/ENixfjmcJ8BH44wf7BkN9vYRBGLPULont6JgXppu0y7N
gzqesljrtuuL9wtwDUpGFiXuExhfzdZLDB2y02o2faelH4RzPEuXX6tCROt+SdxL
ty1lrjYkFIeSkGsxz7KSORWE6F0uxjn5sKhX5FDvy/ysHw4cDBj1GrCNg9hU2rZi
WVfMxEUL2NdpcaNQKuB3BPEyNv7BW54t8sAzDYuPDA5eAZin4R+atr5zNmttx02e
zFTMoUI0gl+ddoe1WXUuO3Q/Nra1ncs0tvcqzxFukOuUDVC3Q9uaP1cvc7nVwu2k
HgBAws6CoSOAtB/sZPInk8ZxwzInWOhTRxf1rnCmPOPKTE6k3x1Z8tATKp9ATrJ3
vVWp+Zd8vL8xIM8Orc9f2ourD0pK4zx5ENWowQlafc7ZkK7xDlJLUYY/5DvHANqn
iul1pyzJN7I2TS130LPf4p8ixvQgqbnxZVXJktsygYNNuxrLhvjyicyvF7GNegai
dsaThNDCXxuA+PtTkApp
=t1tL
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
