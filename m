Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757390Ab2CUQDm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 12:03:42 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:22949 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757057Ab2CUQCq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 12:02:46 -0400
X-Authority-Analysis: v=2.0 cv=Wf+OmjdX c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=UBy9sU4F98IA:10 a=50L13LDiEbIA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=1dANM8d6pweLQJ5EtkoA:9 a=QEXdDO2ut3YA:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=Pk9JPWfmGRUPhWBsLogA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20120321160244.156294414@goodmis.org>
User-Agent: quilt/0.50-1
Date: Wed, 21 Mar 2012 12:01:29 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 4/5] ktest: Fix SWITCH_TO_GOOD to also reboot the machine
References: <20120321160125.496052559@goodmis.org>
Content-Disposition: inline; filename=0004-ktest-Fix-SWITCH_TO_GOOD-to-also-reboot-the-machine.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Steven Rostedt <srostedt@redhat.com>

When the option SWITCH_TO_GOOD is set, it will be called when the system
needs to reboot to the good server. But currently, this keeps the reboot
from happening. The SWITCH_TO_GOOD is just a way to get to a new kernel,
it may not mean to not reboot.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 tools/testing/ktest/ktest.pl |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/tools/testing/ktest/ktest.pl b/tools/testing/ktest/ktest.pl
index 1143e6c..e7fed79 100755
--- a/tools/testing/ktest/ktest.pl
+++ b/tools/testing/ktest/ktest.pl
@@ -1116,7 +1116,6 @@ sub reboot_to_good {
=20
     if (defined($switch_to_good)) {
 	run_command $switch_to_good;
-	return;
     }
=20
     reboot $time;
--=20
1.7.8.3



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJPafukAAoJEIy3vGnGbaoAQzwP/0eo8zphDPR3lx178UKm/gM4
Z1b2r2qT/nwtROmDQy6npRmUFaImZ/QAIXXOhb7fTHh2Z9b1RrtFPI+sKstaPM/0
upNPaoE9+1qT3+z6QC/jLx1IIzFDBCCUdzBafOdCMwTybhsvRjk/M4XJqzmB2ijg
6ectPeuKIwoN1Y3/+I4ni1RKTh/lYk/Un95m1NAMOmNOhTxGBhiW8GGJY8X1taYL
ICWyhL66xqBNXxv8X6+d3/aFGATZnmBNZZepo1QVogMruPt2bCfuBdKERD7to4oH
3j+WzfpVQxywdQgP36ExHFV6Q6tuz4pVtkBGhLXEkKHHkpmrU1dYfQcf9Il7bC3b
l3vX2f+IQPn83wFYbiYOn0GUoPvJx74X21twLl+kssltRmma9S+LUplTVbTOc/Hm
kOL1YNGroO5UzPDNY7Op6bzuRM1f37WZCBj+5xQHPD6hIYoNYiBoV3qCVkRKoG/0
nlUu5g8kgJkK+SP17krM1DKPvjRPsp5b/usW9kGh8qTGDvQB5FVCyY30eOZGhhEm
JpeCwgNbBXZ+fXt4pBzgCx7lLEIwKAD5elqoI37HnpNvhzMQAaDKZlvxeiko9TZm
3JHS6DboAC4xh0B947fN89iD2UMhTkX91MsbFls6GcxsH9OfL4fF+zQ703mV77SS
cv0FZpA0tW/AVxb0qYZK
=tWQg
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
