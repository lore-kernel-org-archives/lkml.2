Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758011Ab2AEDsj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 22:48:39 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:34876 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757903Ab2AEDsX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 22:48:23 -0500
X-Authority-Analysis: v=2.0 cv=Pb19d1dd c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=UBy9sU4F98IA:10 a=Vr4IMWU1Uq0A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=ivSq7K4QZ7bLU_QqGuAA:9 a=QEXdDO2ut3YA:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=clBASnBBxIwVD011rBsA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20120105034821.952385072@goodmis.org>
User-Agent: quilt/0.50-1
Date: Wed, 04 Jan 2012 22:47:59 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 04/20] ktest: Add default for ssh-user, build-target and target-image
References: <20120105034755.793909214@goodmis.org>
Content-Disposition: inline; filename=0004-ktest-Add-default-for-ssh-user-build-target-and-targ.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Steven Rostedt <srostedt@redhat.com>

When a user runs ktest without an argument, or the argument given
is not a config file that exists, ktest will ask the user a few
questions to create a simple ktest config file.

A few of the questions should have a default value set, that if anything
it will make it easier for the user to know what is suppose to
be in that value.

These new values are:

  SSH_USER, BUILD_TARGET and TARGET_IMAGE

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 tools/testing/ktest/ktest.pl |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/tools/testing/ktest/ktest.pl b/tools/testing/ktest/ktest.pl
index 6ef104e..05f429d 100755
--- a/tools/testing/ktest/ktest.pl
+++ b/tools/testing/ktest/ktest.pl
@@ -22,7 +22,6 @@ my %default;
=20
 #default opts
 $default{"NUM_TESTS"}		=3D 1;
-$default{"REBOOT_TYPE"}		=3D "grub";
 $default{"TEST_TYPE"}		=3D "test";
 $default{"BUILD_TYPE"}		=3D "randconfig";
 $default{"MAKE_CMD"}		=3D "make";
@@ -51,7 +50,14 @@ $default{"REBOOT"}		=3D "ssh \$SSH_USER\@\$MACHINE reboo=
t";
 $default{"STOP_AFTER_SUCCESS"}	=3D 10;
 $default{"STOP_AFTER_FAILURE"}	=3D 60;
 $default{"STOP_TEST_AFTER"}	=3D 600;
+
+# required, and we will ask users if they don't have them but we keep the =
default
+# value something that is common.
+$default{"REBOOT_TYPE"}		=3D "grub";
 $default{"LOCALVERSION"}	=3D "-test";
+$default{"SSH_USER"}		=3D "root";
+$default{"BUILD_TARGET"} 	=3D "arch/x86/boot/bzImage";
+$default{"TARGET_IMAGE"}	=3D "/boot/vmlinuz-test";
=20
 my $ktest_config;
 my $version;
--=20
1.7.7.3



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJPBR2GAAoJEIy3vGnGbaoA9h0P/3a1VWTTPo/yMGh1tOCcd92a
1C+C2RdZPT4yh6OiRzYjVBej3ydp3YWie5ut1r5K55wxNWeUchyjunigmooIIllG
1QedEKkqrCnboyiLSrmAdF+3++Y/zjbWJJiPFyA/hvwdOA1u1CGXI4Dh/kh078pZ
vb5+qS302ySS+2JgZjXwoazkcucqe7yRcyBat32PivqJw3alXgGDWFIw87xpUbwL
GHw19qV4mFIXFw3arDJfRAaPYSdyoXa7h2BGF12ozHP1tYnU7zQ2aE0lpPgcbXNs
FF6aQy9yd2FIlHt8jmx9NH9AWLnPKusrGGiEBbp+qMd7i3ksr43SDxUkiFAP4PkV
GhOmNxwdGXuBQJxeEzqD13SBFGjPWfgzIkruKcHt710zN0XqabkD4FYmPz44bJeY
L93RLPi4Tm++2l5lyLe+a8X+RzvJLU5nACTd7fgXYuGKoeBOBA2y0FemCvD2SYfZ
t7T6XOGY8NbK2UbLgChtqwYPrv84UWHHJJTq/DQJm1dqQ5GL0Tzmg2Vc1i51YAup
oRzBj1BUHyozqx0fjbBMikAQ9lIPIoHXhWMi0GwCl9UANFxwUP+EiOSKJQQtPuh1
zONpMvqyhDEFpogPszWzDyEb+FqDaNYcD+IYFmNLdo8y221vOtUDO17GxRGxfflJ
MIS7fwmfWLaHcuWCsNYq
=d8a/
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
