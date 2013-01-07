Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753938Ab3AGODf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 09:03:35 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:15032 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751514Ab3AGODe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 09:03:34 -0500
X-Authority-Analysis: v=2.0 cv=O9a7TWBW c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=6sd7UHOt8RUA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=wHXte46PQD4A:10 a=VwQbUJbxAAAA:8 a=Gw6sF9SxajknVgT6c00A:9 a=QEXdDO2ut3YA:10 a=JjIWQd703T4XvF-Bd1AA:9 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130107140232.460273619@goodmis.org>
User-Agent: quilt/0.60-1
Date: Mon, 07 Jan 2013 09:02:32 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 0/2 v2] [GIT PULL][3.8] tracing: fixes
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable


Ingo,

This is the same as the last git pull I made (tip/perf/urgent) but
without the last patch, as there's some minor fixes required for that
patch.

Thanks,

-- Steve

Please pull the latest tip/perf/urgent-2 tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
tip/perf/urgent-2

Head SHA1: d417f1730039a7fe59b66c6ac04fdaf8d1cfa96f


Steven Rostedt (2):
      ftrace: Be first to run code modification on modules
      tracing: Fix sparse warning with is_signed_type() macro

----
 include/linux/ftrace_event.h |    2 +-
 kernel/trace/ftrace.c        |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQEcBAABAgAGBQJQ6tWyAAoJEOdOSU1xswtMGcMIAMBc841d1Io+17EXYwIzx4oQ
LOInC0nC/HD/yqky4OY17e75QN380q7zXfY3kpugRY1oWAKelxyms6gX3dhacUG4
F0B56unm3Q4GrJjqyJpseI1Yy41CUhwFe0eG96YuoVp0IYlJwmFLq90+MMs7vZ8l
TRpsSI/aYs7nedq4Lo/CDwuisbm/t40WYx6BHf0N9zdVYRU4MUBq26D1lMy+hsLL
uwrWpjfkFS46mhP/p88JeIVO3O4nHZe4d+5hv/GvpDqHW8+4jqO9XwQLM1DPfk9c
IjzfCPK4XU1LXZ+GboHMoBkHQdh7fHD6hSIZ/ldnJFlwv//Zaj+9133d02w3ZoE=
=xIdc
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
