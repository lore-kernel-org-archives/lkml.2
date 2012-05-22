Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756831Ab2EVMGi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 08:06:38 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:13129 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753013Ab2EVMGf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 08:06:35 -0400
X-Authority-Analysis: v=2.0 cv=OMylLFmB c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=Ciwy3NGCPMMA:10 a=ojS1ScDp60wA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=ayC55rCoAAAA:8 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=pFGuiOkWf-wGog64chIA:9 a=QEXdDO2ut3YA:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=6bIXAmp0VbN4VSASsO0A:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20120522120632.110648349@goodmis.org>
User-Agent: quilt/0.60-1
Date: Tue, 22 May 2012 08:05:39 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 8/8] ktest: Add README to explain what is in the examples directory
References: <20120522120531.460108326@goodmis.org>
Content-Disposition: inline; filename=0008-ktest-Add-README-to-explain-what-is-in-the-examples-.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Steven Rostedt <srostedt@redhat.com>

Add a README that explains what the different example configs in the
ktest example directory are about.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 tools/testing/ktest/examples/README |   32 ++++++++++++++++++++++++++++++++
 1 file changed, 32 insertions(+)
 create mode 100644 tools/testing/ktest/examples/README

diff --git a/tools/testing/ktest/examples/README b/tools/testing/ktest/exam=
ples/README
new file mode 100644
index 0000000..a12d295
--- /dev/null
+++ b/tools/testing/ktest/examples/README
@@ -0,0 +1,32 @@
+This directory contains example configs to use ktest for various tasks.
+The configs still need to be customized for your environment, but it
+is broken up by task which makes it easier to understand how to set up
+ktest.
+
+The configs are based off of real working configs but have been modified
+and commented to show more generic use cases that are more helpful for
+developers.
+
+crosstests.conf - this config shows an example of testing a git repo again=
st
+    lots of different architectures. It only does build tests, but makes
+    it easy to compile test different archs. You can download the arch
+    cross compilers from:
+  http://kernel.org/pub/tools/crosstool/files/bin/x86_64/
+
+test.conf - A generic example of a config. This is based on an actual conf=
ig
+     used to perform real testing.
+
+kvm.conf - A example of a config that is used to test a virtual guest runn=
ing
+     on a host.
+
+snowball.conf - An example config that was used to demo ktest.pl against
+     a snowball ARM board.
+
+include/  -  The include directory holds default configs that can be
+    included into other configs. This is a real use example that shows how
+    to reuse configs for various machines or set ups. The files here
+    are included by other config files, where the other config files define
+    options and variables that will make the included config work for the
+    given environment.
+
+
--=20
1.7.10



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJPu4FIAAoJEIy3vGnGbaoAppAQAJiyfxXeYAPL1hIT6JeAvLg+
ca4bEmUWRc17IyCp/gjDxtuaW/NrccgIy9NW2V4Mq0/uqKMYyi2Z+2JzN2UBYF65
KokRAtwE+3Qc0sAbInwQ0mXyDT6wyGq4qq7wN/JULEp8A0z6mw85P2yNNwvFSFf/
62qdLmYJ+GxFSCdiIclSFemwRhlyr3PWUi0FojU+47Ur0d2mlTZ1hcnQk/V+18BY
UHjT97aVt+jxZIP0uowW4R4iJPjEfZGU/FmIAJ+46QIDgbsUGb/ZZfEPbkgw0+Hj
3ppT1abJKK+0R1fr1ZWRFEpu6KT9c2K8H7EysAbc0S57t4XD40RxtypiUF1ECjLJ
0yhGngZpXjLFb64ILFpigPhecEYmkbgeSIfL928uh+1WkUlNVw/yRZP5RwcG9hf5
nH07aA2H9GWB8xmL9WSRQ6iIARWjmT1qY3p22jEvJ4ttrcdUkH5CvZIdzCt4GxkC
AiKkafTjzB2j1tpV4AWZh6an4RJNAHEO6DzIvDHhwqMXX2voi52BX0LjnZHPB/ES
k42HiDjuyt0bFIYgxmz9AyI78sI4qvjYReFqoaz4RgSLtOR7qWWqjx4nw380n5R+
aBCjsOlnRgAq3OYZ6fKxtM6G0+HkPuCrZ5KIG6NF6tut3VXUDiTpEupNeLsaEFxx
17Kg3CEdJ8P6YHpGQuo0
=Bhgc
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
