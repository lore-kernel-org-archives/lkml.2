Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752039Ab2LUNEf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 08:04:35 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:15866 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750828Ab2LUNE1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 08:04:27 -0500
X-Authority-Analysis: v=2.0 cv=O9a7TWBW c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=2MgAbcA0dZAA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=w1HOwYNKIRsA:10 a=VwQbUJbxAAAA:8 a=Re3M5oUVMbDVJFlU1uIA:9 a=QEXdDO2ut3YA:10 a=jUIOSBpmj8hrPTe0k5MA:9 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20121221130323.940466074@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 21 Dec 2012 08:03:23 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 0/3] [GIT PULL][3.9] tracing: various updates
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

Head SHA1: 8a18d22f0b00530e66e7d7c78d3b58f9d789ed7b


Fengguang Wu (1):
      tracing/syscalls: Make local functions static

Jovi Zhang (1):
      tracing: Verify target file before registering a uprobe event

Shan Wei (1):
      tracing: Use this_cpu_ptr per-cpu helper

----
 kernel/trace/blktrace.c       |    2 +-
 kernel/trace/trace.c          |    5 +----
 kernel/trace/trace_syscalls.c |   18 +++++++++---------
 kernel/trace/trace_uprobe.c   |    6 +++++-
 4 files changed, 16 insertions(+), 15 deletions(-)

--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQEcBAABAgAGBQJQ1F5YAAoJEOdOSU1xswtMyQEH/jbYoHzepX8rVXllg5rQFlNU
5VdKD5A+uKS997Adbjgr8b2tuJUsJyvXj8nKmsBTLJXyG9W+onz5Q/wMVOoBKZGQ
phT4nkvMGjxDzPcLqgBs1ZQR3LzPLdu0AmrmJY54iX0vfzOIrv9vHQBX5LlvVnO5
qpA/rRoK+ymWSUZXrAQOtD6ky2cO1TWRVweoTlR0gCLGe4AQm/5B6vt4jKDKSRZ5
U1SBwOwNmoOE7s0apvNVWnF06byM/Vi0og5mGjyHm8P6FWTI8mipdyWI1efmL/B5
wP+P+QFkbFyG3Nbxep8gW+ZytWasG3l9P42reCUlIT06EkdoCoNpsX3dAQrYhFA=
=FMLY
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
