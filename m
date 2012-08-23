Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932545Ab2HWSRH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 14:17:07 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:33109 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757421Ab2HWSRB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 14:17:01 -0400
X-Authority-Analysis: v=2.0 cv=Vb91zSV9 c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=arzNZJyKpNQA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=DO-cjFcLfnAA:10 a=meVymXHHAAAA:8 a=VwQbUJbxAAAA:8 a=oRQYNoTUQprxsF4ufnsA:9 a=QEXdDO2ut3YA:10 a=zoHQUeVVVcffc6VMsgcA:9 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-Id: <20120823181537.510961094@goodmis.org>
User-Agent: quilt/0.60-1
Date: Thu, 23 Aug 2012 14:15:37 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 0/4] [GIT PULL] ftrace: Use of __fentry__
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

Head SHA1: d57c5d51a30152f3175d2344cb6395f08bf8ee0c


Steven Rostedt (4):
      ftrace: Make recordmcount.c handle __fentry__
      ftrace: Add -mfentry to Makefile on function tracer
      ftrace: Do not test frame pointers if -mfentry is used
      ftrace/x86: Add support for -mfentry to x86_64

----
 Makefile                             |    6 +++++-
 arch/x86/Kconfig                     |    1 +
 arch/x86/include/asm/ftrace.h        |    7 ++++++-
 arch/x86/kernel/entry_64.S           |   32 +++++++++++++++++++++++++++---=
--
 arch/x86/kernel/x8664_ksyms_64.c     |    6 +++++-
 kernel/trace/Kconfig                 |    5 +++++
 kernel/trace/trace_functions_graph.c |    5 ++++-
 scripts/recordmcount.h               |    4 +++-
 8 files changed, 56 insertions(+), 10 deletions(-)

--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJQNnOYAAoJEIy3vGnGbaoAJFAQAJPQkwAvFbGlugYxrx5DajHJ
YvHBFgXbZE3xSfCUeiUMCLyJA2k79q8yLz6r+a8F5a2eNLNXuOXTb0X7/9wyi7AB
w+w/Dd9+eN98mi3W9GNPcAEErHUTViayOJjxrWIX9B4sE6Io10lAXaYqEhaDKJzd
U9dZZ8jh/C2vh0KbwJQj4APvmUIYpUJSxVYWP8qcdoCSUP6QrtbumrKNGSdt3nQM
4+n3L4jV8r1dDMf6qLYNHQlADacE+1JJaUi4R2WUdHaXRrSIgHbCP7gsnoaENyVA
pnQH72lKdvClPsnutIei0eO9FqJJv4jQazvfQenCO/Rpj25AvoL3Q+kV3Cubugxs
++l1S0IQR1THQDRnLUu7EocTJ8imFqYQ2/l7YlPqWSvcWMb2T02RCcBb+07oYN+l
qRi2JZ/BMy/gdoCvDBq9dQN3tCns6FVSChnJV7W3ddqGh7G8VDyZeMz/0wMzOebA
g4K8PN4BI8a04PCiwBNUkQ5N2PUcjmnVVecJBeQlAUtgcUSfcO/A51BFtAKDuuho
J3K8Eb/sq7qSlCQvupO4sWZJkHVGV+Cnmotm1zA8l/lCOcudu0PUJpwjWKqOJO0c
FJwtIgZL2/Arjq7L0ShkEsIZS+91h4bGoEtYvzYaLVQ1FdRO22uDzhDhNrr6bwi7
iKlN9jLM4S2EmvxNkD6L
=Tx/z
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
