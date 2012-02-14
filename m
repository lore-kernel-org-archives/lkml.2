Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759284Ab2BNDkW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 22:40:22 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:58422 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759137Ab2BNDkK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 22:40:10 -0500
X-Authority-Analysis: v=2.0 cv=T9kOvo2Q c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=UBy9sU4F98IA:10 a=M5MS61warqwA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=hD80L64hAAAA:8 a=VwQbUJbxAAAA:8 a=pGLkceISAAAA:8 a=68eEZQRoAAAA:8 a=meVymXHHAAAA:8 a=myv_Yk9xFnth4SWAUDYA:9 a=QEXdDO2ut3YA:10 a=T7Kugy-_emkA:10 a=v3rLFGiuRE8A:10 a=MSl-tDqOz04A:10 a=7YLhZ6jOsBkA:10 a=jeBq3FmKZ4MA:10 a=zz4HsAYYGNUsNhryIuQA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20120214034008.199010807@goodmis.org>
User-Agent: quilt/0.50-1
Date: Mon, 13 Feb 2012 22:39:16 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Geunsik Lim <geunsik.lim@samsung.com>
Subject: [PATCH 7/9] ftrace: Append wakeup_rt description of ftrace doc
References: <20120214033909.904564921@goodmis.org>
Content-Disposition: inline; filename=0007-ftrace-Append-wakeup_rt-description-of-ftrace-doc.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Geunsik Lim <geunsik.lim@samsung.com>

Append and update the description about wakeup/wakeup_rt usage.

Link: http://lkml.kernel.org/r/1328695537-15081-2-git-send-email-geunsik.li=
m@gmail.com

Cc: Randy Dunlap <rdunlap@xenotime.net>
Signed-off-by: Geunsik Lim <geunsik.lim@samsung.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 Documentation/trace/ftrace.txt |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/Documentation/trace/ftrace.txt b/Documentation/trace/ftrace.txt
index 1ebc24c..6f51fed 100644
--- a/Documentation/trace/ftrace.txt
+++ b/Documentation/trace/ftrace.txt
@@ -226,6 +226,13 @@ Here is the list of current tracers that may be config=
ured.
 	Traces and records the max latency that it takes for
 	the highest priority task to get scheduled after
 	it has been woken up.
+        Traces all tasks as an average developer would expect.
+
+  "wakeup_rt"
+
+        Traces and records the max latency that it takes for just
+        RT tasks (as the current "wakeup" does). This is useful
+        for those interested in wake up timings of RT tasks.
=20
   "hw-branch-tracer"
=20
--=20
1.7.8.3



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJPOdeYAAoJEIy3vGnGbaoAjKwQAOgCfASYwdM7oh5mtud2+pNS
Kq+PQ96oWSaRt5+eFkJntOWHc4EwnMgIf8tvm51UAhB9bdKtX+8Hwjc3I+lKtMPE
wUk3lspdFrm4uJaKKlKqHC6moahvgnVR7bn9chEC+BaoMyq+CoUa/ruoRssCuWXH
Dcl7cC8p1g9CoQzmyTE6N9YJjE9EVW4P1XCIgGnsOVMQsxvyfE5AW3NCheVq+UO8
eF18fLJdVP4tviKUn9S8pbFL6XMnSjHnOMfC946iIPvew7n9yNGbMc+FMkY1lFf0
v/Pax6EWdN8KXSzJfC4FcPs5LaLTKiVaSMWHR/LtaPzJQQ3vvyYg7Cc38ZgPMwQT
56w6VmLLOk2h7ilgUkwYpJojmdl0hfgyOSHi0JYihlWbrJFTZLtibWbStyjthF4X
qyVsGSDn2Jak0U88AvqiATtPM4U95taEC//g7fsJnd4hRsXxLtQSwo/4hPIiri6U
vOBRTl/ywCDVCXVeKK/X7URtQnIKMjb7DjhXlGxrOUNG+EV3UnfqxsFebBTIDji+
jobVLAkB9Sjf+MsqoWjns0g/BWVTtk5WQPCBcip3URm24jtKzR8/aQaevpLtDy50
xqSOd5mQVp6PWQ4MNXgcADO2SJzIEZ3tYzeAw5n0KAkPUjRVXT3OlMV+AyvEZKBJ
4RBoLajsWwMbJdojBRCt
=b/+x
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
