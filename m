Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760692Ab2CNQ17 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 12:27:59 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:9750 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757771Ab2CNQ1M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 12:27:12 -0400
X-Authority-Analysis: v=2.0 cv=d9t3OGfE c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=UBy9sU4F98IA:10 a=mFvYZs74wYAA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=wggVRkVUAAAA:8 a=pGLkceISAAAA:8 a=meVymXHHAAAA:8 a=ModKofmDp5VbibEo4kwA:9 a=QEXdDO2ut3YA:10 a=jEp0ucaQiEUA:10 a=MSl-tDqOz04A:10 a=jeBq3FmKZ4MA:10 a=vnPd1pFj0s_YLaBJma8A:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20120314162709.651136632@goodmis.org>
User-Agent: quilt/0.50-1
Date: Wed, 14 Mar 2012 12:26:35 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 6/6] perf: Add ifdef to remove unused enum switch warnings
References: <20120314162629.118638243@goodmis.org>
Content-Disposition: inline; filename=0006-perf-Add-ifdef-to-remove-unused-enum-switch-warnings.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Jiri Olsa <jolsa@redhat.com>

Fix for unused symbols in switch warnings.

Link: http://lkml.kernel.org/r/20120313230302.GA1514@m.redhat.com

Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/ftrace_event.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
index dd478fc..5f3f3be 100644
--- a/include/linux/ftrace_event.h
+++ b/include/linux/ftrace_event.h
@@ -144,12 +144,14 @@ struct event_filter;
 enum trace_reg {
 	TRACE_REG_REGISTER,
 	TRACE_REG_UNREGISTER,
+#ifdef CONFIG_PERF_EVENTS
 	TRACE_REG_PERF_REGISTER,
 	TRACE_REG_PERF_UNREGISTER,
 	TRACE_REG_PERF_OPEN,
 	TRACE_REG_PERF_CLOSE,
 	TRACE_REG_PERF_ADD,
 	TRACE_REG_PERF_DEL,
+#endif
 };
=20
 struct ftrace_event_call;
--=20
1.7.8.3



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJPYMbdAAoJEIy3vGnGbaoAGCkQAKpJauLx8Km38eebcWRM+80E
hbbQf8qcumopykM2A+6xPLdxKAijxqneEFJNgKQ4vmfh0wqSRpyX09+YwO5L9qSG
K0GXglIBts5qslP9rWsc0fbb/hQhfGhKp7ehDAt0nzkwgicrGTJvO1LOFGSq3KZg
B99Vt3oUEPJbbhmLiEUwEilNL0hBOEHr2gAqA7WwkPvoPozMeStuhqoqKkHxbfML
E1rPCtZf0cjQTN/ou47KtpCFjJ3gueSqjeZ3Vz8iNs4dpacILVhrF1Y1fv/gWOdv
UkPhv614G6dUS9u+3ONPg2aRwOD7qjugsu9K9POKM+m8o+hkpAg5CSt19u+yMSgW
jHRFkTK0Cg7cyN+7WiL2+kGYJ3h4Hy7MsXU++/y4T8vtWCEeqC1XQ1Vth10lXYE7
c4D8LZpBKGi2WhPASFmulLn52c6Dz15Rn/YCKAwVY+YUomHgBtXCb02u7g92XsqV
8JC82WXrE9U9G5iSEXgeeBf+SfTiTxm4omCymVvJGXgjd4IXlEvaNK+f+p2xcJNI
k4a/pVXW7j2uov3e2q+9IbIc/JyzVnrLWVxVjYwgPPayRG2Zi5GO2NnTN4ZihJsn
QBpF/p08DpEelPpMmWAM66lCOrTsSti4kRDhbqjBGHbM9u4mrWI2u1vkuAPQIl0B
x9/5BWujX9oWI1rqBcK5
=xLVq
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
