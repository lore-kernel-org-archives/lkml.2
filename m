Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757853Ab2DYStd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 14:49:33 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:25546 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757545Ab2DYStc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 14:49:32 -0400
X-Authority-Analysis: v=2.0 cv=XbcLPfF5 c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=Ciwy3NGCPMMA:10 a=2hK0Ar2thLgA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=VwQbUJbxAAAA:8 a=0dGHxREcy1wiCHyw8uMA:9 a=-fBbc2RduHrAxWH8VooA:7 a=QEXdDO2ut3YA:10 a=vIyzJclzbyhRbZHRLbYA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20120425184830.325105778@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 25 Apr 2012 14:48:30 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 0/5] [GIT PULL] tracing: updates for 3.5
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable


Ingo,

Please pull the latest tip/perf/core tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
tip/perf/core

Head SHA1: 61463fad01fe416ab55d56a970a707b33d081436


Dan Carpenter (1):
      tracing: Remove an unneeded check in trace_seq_buffer()

Steven Rostedt (3):
      tracing: Add percpu buffers for trace_printk()
      ftrace/x86: Have arch x86_64 use breakpoints instead of stop machine
      ftrace/x86: Remove the complex ftrace NMI handling code

Vaibhav Nagarnaik (1):
      ring-buffer: Add per_cpu ring buffer control files

----
 arch/x86/Kconfig              |    1 -
 arch/x86/include/asm/ftrace.h |    4 +
 arch/x86/kernel/ftrace.c      |  512 +++++++++++++++++++++++++++----------=
----
 arch/x86/kernel/nmi.c         |   10 +-
 arch/x86/kernel/traps.c       |    9 +-
 include/linux/ftrace.h        |    6 +
 include/linux/kernel.h        |   13 +-
 include/linux/ring_buffer.h   |    6 +-
 kernel/trace/ring_buffer.c    |  248 +++++++++++---------
 kernel/trace/trace.c          |  379 ++++++++++++++++++++++--------
 kernel/trace/trace.h          |    4 +-
 kernel/trace/trace_printk.c   |    4 +
 12 files changed, 813 insertions(+), 383 deletions(-)

--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJPmEc2AAoJEIy3vGnGbaoA7yQQANLPMQv/mrfpQWtinQVu20M6
A/9xoiHtiGaQWywSDJXNjG42Z0m8pGiNvX9a3jxTt/I1RuAx8h3DnYZFMBW3FP/Y
MDRRfoPTjgsLL+mLfgg8HKk1akzQyPIM5zOiqamYaPBE3cJTZnRNofsXP6UFBGQX
DSdGU2CFwPjxTUWhHEqfAGkK0LtS4wAbw1MxEVOHeDZCV+bwX76RuNXPtj3qwV94
A6oZnfRByfsQFOzFEhFTWEBAqIivr/lTVLHF8ZcrwGmb+5/IG9NYkQTzKK7Qxw9j
RDvJOZYM5jYvRXoYbu68Ju8oICVIKBq8q+2/vmRv5ql2rTzNH6SV2XZLeJFyUmLi
k64E00jVHbMy/QwVddiEyoJDHPh1wApAzJ8JJHvtFV1dyp3j01ZmO/kxP5oFwZY3
0YV15LpdgWicG4Urs6SrU3BPya6gAlSc2pWg7WbVYiJET9vc0w7jQCVTnpvEcOlb
yV6Qqyz1cXAqBGfl8nuOVanbO8TUUOE9iBCSHKaaSPpNKkW26Cw4lcYG/KDVzMBQ
YO8aoopHD2hQUwe5Kb4pOqWd9w8gEGgtCqAuzMvlKg+fL2bondXnetdZBi4SkGDU
i14mjhpw2fW+3Cs+/waA2rZcdZ5WB1N+2C2xDZn/a+34znGbS437d+0UT7HXaGMQ
M4+i6uFwIMqbXvM2rXDd
=XbfL
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
