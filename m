Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759240Ab2BNDl6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 22:41:58 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:52656 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759090Ab2BNDkJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 22:40:09 -0500
X-Authority-Analysis: v=2.0 cv=fNy7LOme c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=UBy9sU4F98IA:10 a=J6ZNmX-nvIMA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=hD80L64hAAAA:8 a=VwQbUJbxAAAA:8 a=pGLkceISAAAA:8 a=68eEZQRoAAAA:8 a=meVymXHHAAAA:8 a=A419fJqGtwU-UxSIdBAA:9 a=QEXdDO2ut3YA:10 a=T7Kugy-_emkA:10 a=v3rLFGiuRE8A:10 a=MSl-tDqOz04A:10 a=7YLhZ6jOsBkA:10 a=jeBq3FmKZ4MA:10 a=c4gI369t-3vvI9E8lfEA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20120214034007.862836421@goodmis.org>
User-Agent: quilt/0.50-1
Date: Mon, 13 Feb 2012 22:39:15 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Geunsik Lim <geunsik.lim@samsung.com>
Subject: [PATCH 6/9] ftrace: sched_switch plugin is deprecated
References: <20120214033909.904564921@goodmis.org>
Content-Disposition: inline; filename=0006-ftrace-sched_switch-plugin-is-deprecated.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Geunsik Lim <geunsik.lim@samsung.com>

Actually, sched_switch function tracer is merged into wakeup/wakeup_rt
Update 'mini-HOWTO' for ftrace(Kernel function tracer).
If we want to trace "sched:sched_switch" to trace sched_switch func,
We may utilize event option.(e.g: trace-cmd list -e | grep sched)
This patch is based on Linux-3.3.rc2-SMP-PREEMPT

Link: http://lkml.kernel.org/r/1328695537-15081-1-git-send-email-geunsik.li=
m@gmail.com

Cc: Randy Dunlap <rdunlap@xenotime.net>
Signed-off-by: Geunsik Lim <geunsik.lim@samsung.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index a3f1bc5..10d5503 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -2764,12 +2764,12 @@ static const char readme_msg[] =3D
 	"tracing mini-HOWTO:\n\n"
 	"# mount -t debugfs nodev /sys/kernel/debug\n\n"
 	"# cat /sys/kernel/debug/tracing/available_tracers\n"
-	"wakeup preemptirqsoff preemptoff irqsoff function sched_switch nop\n\n"
+	"wakeup wakeup_rt preemptirqsoff preemptoff irqsoff function nop\n\n"
 	"# cat /sys/kernel/debug/tracing/current_tracer\n"
 	"nop\n"
-	"# echo sched_switch > /sys/kernel/debug/tracing/current_tracer\n"
+	"# echo wakeup > /sys/kernel/debug/tracing/current_tracer\n"
 	"# cat /sys/kernel/debug/tracing/current_tracer\n"
-	"sched_switch\n"
+	"wakeup\n"
 	"# cat /sys/kernel/debug/tracing/trace_options\n"
 	"noprint-parent nosym-offset nosym-addr noverbose\n"
 	"# echo print-parent > /sys/kernel/debug/tracing/trace_options\n"
--=20
1.7.8.3



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJPOdeXAAoJEIy3vGnGbaoA6jwQAK+e8VzH4ZcvDNa57B37qyvI
QoIp0c9Oke+xzlR9j8BVpxa10hZN9Dfc1f45qUUur80j7YMfR1GTuJ1js1itNnnM
iehFuQDGBcj7wB5JTejmsc87QD3TR+5Y/uZz66y9SbARZGHAbOurNxTvaiGZhodr
5Jc/mUpCNPKH4Z9AxeaaXJYKNhUXuXHS87M8mXdVeRrRKyQZtocRIwBL7GTyfJyn
CwOeiG6FhMW+k5xEO0wSSaWxCLnEGGWiVc50Db/wQUwgMJ5iziyXz2EkLWEnHZwC
OXQ9y51bejn1pPwdvOJmxoAzTzAvWoB3wJYB65owYWwnKChCAlY2tzMMKZxrm8SQ
aRkZd/jw3tRl4qoytBYtCUgG20KvyYFFWq8wGl+/5p4DDwy2tMF5T3f+crpz9xRS
NlcrSk2QhuDDXP7VWJ63eGQK9Vvbbe15SeGDBJQFODMrJh/VFYzmIKJUh+KiBR52
OOdzhcsqmWMTndHQ17TfBdMJwQCdE0BE7rxlKdVAqeBVn6+vKOK9uY6Njg7lNc9f
RPXaa0PVI53KKC4Z+lIyE3fbnElHDQtuYMoAi1O54kFtAQRU+KweG8LBIFLri3iR
sZ1fsjE5wAv6q0UtLRciJ3QsnY/vdOi3oqmAX3EmdL13iSrGnmCWCUDn7hQ1mJh5
3eT+o0uKmoAXt4Lypk2d
=4gA7
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
