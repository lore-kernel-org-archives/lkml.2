Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754716Ab2IYTUe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 15:20:34 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:19740 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753244Ab2IYTUb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 15:20:31 -0400
X-Authority-Analysis: v=2.0 cv=Hsb06jvS c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=BQFSgszhkQ8A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=mipF9tkXnpMA:10 a=VwQbUJbxAAAA:8 a=Z_Av35DhCVvG_r9FBl4A:9 a=QEXdDO2ut3YA:10 a=9w8EhH_V29CVInp97fMA:9 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-Id: <20120925191941.504217238@goodmis.org>
User-Agent: quilt/0.60-1
Date: Tue, 25 Sep 2012 15:19:41 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 0/2] [GIT PULL][v3.7] tracing: A couple more updates
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

Head SHA1: 8781915ad2716adcd8cd5cc52cee791fc8b00fdf


Ezequiel Garcia (1):
      trace: Move trace event enable from fs_initcall to core_initcall

Mandeep Singh Baines (1):
      tracing: Add an option for disabling markers

----
 kernel/trace/trace.c          |    6 ++-
 kernel/trace/trace.h          |    1 +
 kernel/trace/trace_events.c   |  108 +++++++++++++++++++++++++++----------=
----
 kernel/trace/trace_syscalls.c |    2 +-
 4 files changed, 79 insertions(+), 38 deletions(-)

--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQEcBAABAgAGBQJQYgP6AAoJEOdOSU1xswtM8XIH/RMOT4atYJVq7r90cFSHhD6B
/QU1XJ0jiwGB8QF1JYHD/GrJXITy4L5YB1dxLFJDiwHKCczKygLpvrhdH92yJT6C
J1x9hGHVll1IV/zAlOR4QnV7qoNgrI1iprUkmHa0H3eyYpLp8UGHUeQhQzJLjLmM
4ivKv+c1GRPXJYd6BvzkiXGuh3Ca0uY3ngcSPUKFerelWM8uzeblf0mwQ/3K3VZr
g3Yi7zvKTHkdBBUqu9jHF37r0GBitf1xP8U2ZXWJKXZ73/MA25xnSl+GWmRw6fpd
rr7qjWdWXjIbTBmKaY2O98/eeLampEz1D09djPIPtBjlsCgTqNn3i4DakadCOW4=
=Op+I
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
