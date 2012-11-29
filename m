Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932754Ab2K2BYf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 20:24:35 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:23994 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755191Ab2K2BYc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 20:24:32 -0500
X-Authority-Analysis: v=2.0 cv=cuMZYiEi c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=0M3RpHGs21MA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=lMhyl2yyHt0A:10 a=VwQbUJbxAAAA:8 a=HYJGp3UvLETLjfFpNAAA:9 a=QEXdDO2ut3YA:10 a=N5_8tFBaOen348GdzOYA:9 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20121129012340.602023062@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 28 Nov 2012 20:23:40 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 0/3] [GIT PULL] tracing: Some more updates
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable


Ingo,

This is based off of my last pull request on tip/perf/core.

Please pull the latest tip/perf/core-2 tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
tip/perf/core-2

Head SHA1: bf3071f5a054db9e5bab873355d27a7330ce5187


Anton Vorontsov (1):
      tracing: Remove unneeded checks from the stack tracer

Dave Jones (1):
      tracing: Remove unnecessary WARN_ONCE's from tracing_buffers_splice_r=
ead

Hiraku Toyooka (1):
      tracing: Add a resize function to make one buffer equivalent to anoth=
er buffer

----
 kernel/trace/trace.c       |   60 +++++++++++++++++++++++-----------------=
----
 kernel/trace/trace_stack.c |    4 ---
 2 files changed, 31 insertions(+), 33 deletions(-)

--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQEcBAABAgAGBQJQtrlMAAoJEOdOSU1xswtMALoH/2He7ZbuFPPiDY5EEM2Au53t
7JyfhDupLn3Flv2pA3ztSjI0CquZlN4MuJ6w4MrToXcaxK9v+ucGu01KNr04FgPS
v4kTuWK8Oxro3/VilsehVmj+BKEwkQUpfVyOMgVPkTlqhAVCaW5WPOiVbzODLZ0w
HDTQOwzrGLnjukHOAD/yKvqRJZPx5Eu49M/I37PNPE9f/v282r1fBoS6/2tF89Ip
dMhOkjbtNzLTUvFmf2/sUu4tUrMogwU+Wlf6AeNMWMI3JgDnvVG61e2KYPvArbfP
MhTThOyxXEqioFBB7nFuUVOnCBT69E0W4/ZvgP+aIiOScH0qhQrzYALPyQYyF1A=
=+JMe
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
