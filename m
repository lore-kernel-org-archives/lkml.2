Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753140Ab3ACAmT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2013 19:42:19 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:24949 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753046Ab3ACAmO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2013 19:42:14 -0500
X-Authority-Analysis: v=2.0 cv=YruNtvkX c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=ZB0RQ1o5OYEA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=XL2J_widmGwA:10 a=VwQbUJbxAAAA:8 a=soNwBRu5iwg4pfr6yhEA:9 a=QEXdDO2ut3YA:10 a=drg-bJiWQtysQV5tfCoA:9 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130102225035.140076434@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 02 Jan 2013 17:50:35 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 0/3] [GIT PULL][3.8] tracing: Minor fixes for 3.8
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable


Ingo,

As it's still an early -rc, it would be good to get these fixes into
mainline before the next release.

Thanks,

-- Steve

Please pull the latest tip/perf/urgent tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
tip/perf/urgent

Head SHA1: f9dd9809c1426ccc7e997201b9b839c96ac810ec


Jovi Zhang (1):
      tracing: Verify target file before registering a uprobe event

Steven Rostedt (2):
      ftrace: Be first to run code modification on modules
      tracing: Fix sparse warning with is_signed_type() macro

----
 include/linux/ftrace_event.h |    2 +-
 kernel/trace/ftrace.c        |    2 +-
 kernel/trace/trace_uprobe.c  |    6 +++++-
 3 files changed, 7 insertions(+), 3 deletions(-)

--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQEcBAABAgAGBQJQ5NPfAAoJEOdOSU1xswtMvG0H/2N9Kmo5ZBBAgEbbmib0KJei
CtM7eulCQzBksUeDcNcK95T1YlnFDYiWpqArDWihj8rK/zbh9PkPT/ishtkABz1R
Am9P0ROzUxNKUVVVmwsKXNw2GMadUCAaiINv9AyskFjyI34q6qOcMj15q2XNCAeN
TonXwWq1hlWHHjYD0rT+zWEnItPJFGquEMYfuLUw3dBnb+0llVA47RpV3KdkHRsI
D4wn0gjoHIJIlTMUX2yGMD+uujKnPQ8HgviTAzIMT+yhkSsrVAhmVzswu0YrC4t2
bwAey+6D68Qk9mY/yrgjKOYFZuspylaRsYYeFNs9y6mi6hi1cbosh3Wu1A5kyQw=
=tMr3
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
