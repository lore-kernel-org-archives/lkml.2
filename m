Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751504Ab1JQRur (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 13:50:47 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:63213 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751154Ab1JQRuZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 13:50:25 -0400
X-Authority-Analysis: v=1.1 cv=Aw1K5MWCW/IlYLbVHOK2DHmxtnIeftPoAvmBFvlQMWA= c=1 sm=0 a=vhdKIqpQuCYA:10 a=SynPNRHhxoAA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=hD80L64hAAAA:8 a=VwQbUJbxAAAA:8 a=pGLkceISAAAA:8 a=meVymXHHAAAA:8 a=2TICIzPm5_ciRUbzbvsA:9 a=QEXdDO2ut3YA:10 a=DHQQ7jDAcw4A:10 a=v3rLFGiuRE8A:10 a=MSl-tDqOz04A:10 a=jeBq3FmKZ4MA:10 a=3ahqdCAx0qoexaMLyigA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20111017175023.109360819@goodmis.org>
User-Agent: quilt/0.48-1
Date: Mon, 17 Oct 2011 13:49:39 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Geunsik Lim <geunsik.lim@samsung.com>
Subject: [PATCH 1/2] ftrace: Fix README to state tracing_on to start/stop tracing
References: <20111017174938.842273454@goodmis.org>
Content-Disposition: inline; filename=0001-ftrace-Fix-README-to-state-tracing_on-to-start-stop-.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Geunsik Lim <geunsik.lim@samsung.com>

tracing_enabled option is deprecated.
To start/stop tracing, write to /sys/kernel/debug/tracing/tracing_on
without tracing_enabled. This patch is based on Linux 3.1.0-rc1

Signed-off-by: Geunsik Lim <geunsik.lim@samsung.com>
Link: http://lkml.kernel.org/r/1313127022-23830-1-git-send-email-leemgs1@gm=
ail.com
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index f86efe9..cea1605 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -2720,9 +2720,9 @@ static const char readme_msg[] =3D
 	"# cat /sys/kernel/debug/tracing/trace_options\n"
 	"noprint-parent nosym-offset nosym-addr noverbose\n"
 	"# echo print-parent > /sys/kernel/debug/tracing/trace_options\n"
-	"# echo 1 > /sys/kernel/debug/tracing/tracing_enabled\n"
+	"# echo 1 > /sys/kernel/debug/tracing/tracing_on\n"
 	"# cat /sys/kernel/debug/tracing/trace > /tmp/trace.txt\n"
-	"# echo 0 > /sys/kernel/debug/tracing/tracing_enabled\n"
+	"# echo 0 > /sys/kernel/debug/tracing/tracing_on\n"
 ;
=20
 static ssize_t
--=20
1.7.6.3



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJOnGrfAAoJEIy3vGnGbaoAP4AQAMnPvG/QSAzD4ooQC/K6ReL3
Ww9OB/z0yA199izmGy6M0mOpYhIBlmm37d2aT4ULAMldg0y7NsJDW+42sAx6wvHc
twKijNGLhe2TsPRR+ccxssH05A6OeKmOcofouwXUN93eNZal6JdHvrQsEXJts0HB
Fq33StR1AX1dL/VyLY5icEs7ck7WgCcgDDWyAu6T4/pf4czX3DcfBtcWAM3Aofgg
SKNH/WqClp/K4hVN1zhyvkkMOyC+6KY/gSzkH2/D9/g+LAdKnwbKz6om+UmuON3P
HLeceMHtWbvJgYqIDweZib9nbJxxAbHE+IRSE0ntHQwvW8z12zsIPlg1feM33GBZ
wMolQG01j2dLd7XPgKyTfHnZ87MO2bFIoWsdBaCasyhT03MIgysE/iAQmcTs5lbC
8fuO+LPOWfiOgne+JTk9j26O30BVzc2P900cJyWFKhC5eaDSmWzqkb0ZNOyWJ43l
+3l5eJO0MozJQP0SW9O5/v0q6+eCJqoFdjrGhjSWdl6a/at/LnmHMDDY3Ac78MeA
eZCfoPmULwnFw82eKbSi/jh7y/LexuhlgLeuXBuiZl2S5C3MYTAoKewKo3tAt/Th
xOEdWl0Vi8LGoS//EXkxWEMnZ96pjcuVQahW/bAm73yy78UlJTq4qx62NRepY02u
I2/7OPuYf2TAa1qNTQ5d
=vBtI
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
