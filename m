Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759297Ab2ESNha (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2012 09:37:30 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:33783 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757249Ab2ESNgi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2012 09:36:38 -0400
X-Authority-Analysis: v=2.0 cv=OMylLFmB c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=Ciwy3NGCPMMA:10 a=cgRAYoHPvEMA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=VwQbUJbxAAAA:8 a=z4-vK0M_khU3xeFmJKYA:9 a=QEXdDO2ut3YA:10 a=jeBq3FmKZ4MA:10 a=uDcoDS_A1fSSV5nPgtIA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20120519133636.183512296@goodmis.org>
User-Agent: quilt/0.60-1
Date: Sat, 19 May 2012 09:35:54 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH 3/3] tracing: Remove kernel_lock annotations
References: <20120519133551.942867137@goodmis.org>
Content-Disposition: inline; filename=0003-tracing-Remove-kernel_lock-annotations.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Richard Weinberger <richard@nod.at>

The BKL is gone, these annotations are useless.

Link: http://lkml.kernel.org/r/1320654202-4433-1-git-send-email-richard@nod=
.at

Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.c |    2 --
 1 file changed, 2 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index a44d4c6..b9a507c 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -763,8 +763,6 @@ update_max_tr_single(struct trace_array *tr, struct tas=
k_struct *tsk, int cpu)
  * Register a new plugin tracer.
  */
 int register_tracer(struct tracer *type)
-__releases(kernel_lock)
-__acquires(kernel_lock)
 {
 	struct tracer *t;
 	int ret =3D 0;
--=20
1.7.10



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJPt6HkAAoJEIy3vGnGbaoAsaIQAN/k1MOMX7Y2Cuwgju9ebVh5
WFZswGTwsqOlu0nm20OkD8dmpmQ0h+74zujECBNG1uzvtVXcBJlblkfzyCL4Qv7D
sVpjO0nkr8YYnyt+AcZHH5RugNWXuZtu43K3tyvpnLRZ4USNQWvY3y/lMIGnClZQ
0WNskPeBZOMZhwUeMTxVefEc0YjLSMsSZGcaYs9uPEk0UCs0hpI9dBAJTl9kgO9X
3MQzbbHvXrClMYV7JpD6DQ2e2H22MElHCdpQ5nD8e8LMFT7V+o16DfNCyLGc5wfR
DJeRGeqMpi4vpyvNcyWR71rQ2Yq2XQJn29Jw7sl1fBrKik6lvL0nrp5vLDrF9c32
gJjlR2VSuzbVIYZjcJALS+EFeUnERjkS9/4A73b87qqjsODt1EBwGOjkadTQ4GEl
grbLuCVUOEryelh4Ae0PwEEtXRv+zQGCPLQuQsUiRZyTwPexea6RtAq0hlqy4qx9
DDbkcras91B2d6mgo1DWq6pzbLUpWC+pB8yZ3nTDBqpPnzOS+OQg/6mKBwK37jdD
ASAZ1zBjMi1aQKFCZIZEHV9KOHetZlTaKGet2nNBymYSidoob+iwKo2/WhHjWJNo
3rgzsMKqkhiK2jowSohWbbjnMe19rFttMBr3dd8v01NIs0e9XUgboQpSRzyasjUV
sg/pnLcxUB+6MrS1MR/B
=mo6v
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
