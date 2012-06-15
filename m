Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753981Ab2FOBDk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 21:03:40 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:6641 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752063Ab2FOBDj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 21:03:39 -0400
X-Authority-Analysis: v=2.0 cv=T6AOvo2Q c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=Ciwy3NGCPMMA:10 a=GxmbMeF7QUsA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=VwQbUJbxAAAA:8 a=iYqKeNel2LBCnDX-ZSkA:9 a=QEXdDO2ut3YA:10 a=Q0AB-IKcduk--GhCmWsA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20120615010123.722084844@goodmis.org>
User-Agent: quilt/0.60-1
Date: Thu, 14 Jun 2012 21:01:23 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 0/3] [GIT PULL][v3.6] tracing: simple updates
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable


Ingo,

I understand that I'm currently on Thomas's "most loved" list, I figured
I would send out these simple changes. Nothing that should cause me
another brown paper bag fix in this.

Please pull the latest tip/perf/core tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
tip/perf/core

Head SHA1: 7374e82771c6d5a9af2080be46f64a5826c7efb1


Borislav Petkov (1):
      ftrace: Remove a superfluous check

Steven Rostedt (2):
      tracing: Add comments for the other bits of ftrace_event_call.flags
      tracing: Register the ftrace internal events during early boot

----
 include/linux/ftrace_event.h |    3 +++
 kernel/trace/ftrace.c        |    8 ++------
 kernel/trace/trace_output.c  |    2 +-
 3 files changed, 6 insertions(+), 7 deletions(-)

--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJP2onlAAoJEIy3vGnGbaoAV/0QAMqNiKu7hMmj3R8tTpAD5WjK
VGSpyQRBGXWgG6TABVFPZeMJZ+9PUHLIrS9FtUpE7a0OYninaKTvcCh7vRniK2Hp
LZV7SUZohSeXD545PIZzCXNRnwTmVt0rvJ5VIdPnc53+jZNO3AWtIA4HP9+gLxTN
z2J2z3rlxZmoQxc72cezeWCgO6+mjLut6UETlmfo7rVfXeSOkK0oF/PMEoaF9QUK
RHQExBQGFo3pYRXdbDzw0MbtzP4L/Yy6jtvAoP13svIGprcjg1EdnnSeBakp5Vja
cpkutUmRZULvTkWVaLxZ9NtF64GZpyESuona+URz8Z+B5IlnEWom6YnF9y4+74zX
c1trPrKq3TKGXAmUUNMmaI0RccCKdkNlXrfvDIvJ8QJZqEVtDQilGqIwbLkoAKEg
UvjrU6llOdCHcaMb2NsF0fN4x7NNTfHOja5vSiYSNIe/Pqt3pxl4XPhXtV6awxPD
qA0Lzwkig+sERaONnu0+xxz/hKIjTblSahxYtGj9Hso18ihFTMbHucfaaWCQDI3M
NFgYFV1UYW2nPp38uYWKa+pU794Ybs6sCto6frYUJlujimK1uZL6iJv/EyVgJ474
r/Rx6+Tm0mLvm+d0S6mONJadDqDMLzVu+K9IQHf7wypy8TLEWrYMZpSnibWF7l2a
dZxQxqi5WyIZI5JE/Gau
=SHBT
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
