Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423294Ab2KNTJq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 14:09:46 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:28292 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161203Ab2KNTJo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 14:09:44 -0500
X-Authority-Analysis: v=2.0 cv=dvhZ+ic4 c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=Lr1B8SWfeMAA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=pb1N-NycqVwA:10 a=VwQbUJbxAAAA:8 a=BrzwyhrlA-5o3Xemz4UA:9 a=QEXdDO2ut3YA:10 a=yVW-L3cgpkQVlwxH9wEA:9 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-Id: <20121114185333.818952665@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 14 Nov 2012 13:53:33 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 0/4] [GIT PULL][3.8] tracing: Updated patches
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable


Ingo,

This includes the updates to the formating issues to the patches
that were in the original patch set, and which I had dropped from
my last pull request. I added this on top of my last git pull request.

I also included Shan's dead comment removal.

Please pull the latest tip/perf/core tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
tip/perf/core

Head SHA1: 1c7d66732458dc187008e3f5b2f71e019e320fc2


David Sharp (2):
      tracing,x86: Add a TSC trace_clock
      tracing: Format non-nanosec times from tsc clock without a decimal po=
int.

Shan Wei (1):
      tracing: Kill unused and puzzled sample code in ftrace.h

Yoshihiro YUNOMAE (1):
      tracing: Show raw time stamp on stats per cpu using counter or tsc mo=
de for trace_clock

----
 arch/alpha/include/asm/Kbuild      |    1 +
 arch/arm/include/asm/Kbuild        |    1 +
 arch/arm64/include/asm/Kbuild      |    1 +
 arch/avr32/include/asm/Kbuild      |    1 +
 arch/blackfin/include/asm/Kbuild   |    1 +
 arch/c6x/include/asm/Kbuild        |    1 +
 arch/cris/include/asm/Kbuild       |    1 +
 arch/frv/include/asm/Kbuild        |    1 +
 arch/h8300/include/asm/Kbuild      |    1 +
 arch/hexagon/include/asm/Kbuild    |    1 +
 arch/ia64/include/asm/Kbuild       |    1 +
 arch/m32r/include/asm/Kbuild       |    1 +
 arch/m68k/include/asm/Kbuild       |    1 +
 arch/microblaze/include/asm/Kbuild |    1 +
 arch/mips/include/asm/Kbuild       |    1 +
 arch/mn10300/include/asm/Kbuild    |    1 +
 arch/openrisc/include/asm/Kbuild   |    1 +
 arch/parisc/include/asm/Kbuild     |    1 +
 arch/powerpc/include/asm/Kbuild    |    1 +
 arch/s390/include/asm/Kbuild       |    1 +
 arch/score/include/asm/Kbuild      |    1 +
 arch/sh/include/asm/Kbuild         |    1 +
 arch/sparc/include/asm/Kbuild      |    1 +
 arch/tile/include/asm/Kbuild       |    1 +
 arch/um/include/asm/Kbuild         |    1 +
 arch/unicore32/include/asm/Kbuild  |    1 +
 arch/x86/include/asm/trace_clock.h |   20 +++++++++
 arch/x86/kernel/Makefile           |    1 +
 arch/x86/kernel/trace_clock.c      |   21 ++++++++++
 arch/xtensa/include/asm/Kbuild     |    1 +
 include/asm-generic/trace_clock.h  |   16 ++++++++
 include/linux/ftrace_event.h       |    6 +++
 include/linux/trace_clock.h        |    2 +
 include/trace/ftrace.h             |   73 ---------------------------------
 kernel/trace/trace.c               |   39 +++++++++++++-----
 kernel/trace/trace.h               |    4 --
 kernel/trace/trace_output.c        |   78 ++++++++++++++++++++++++--------=
----
 37 files changed, 176 insertions(+), 111 deletions(-)

--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQEcBAABAgAGBQJQo+xzAAoJEOdOSU1xswtM9WoIAKWNH6R1q9qMvHr667cdYV3+
ZPK/0QPg3yIqObEImuan9TmL8YZLp4LrPEMQXfasou1oOr5DCAPrS7qM4Afl0qSb
ZrLBp92Q4aFN6jvEUG39P36HFAxnnm26BtkwwiBxHb67yIYQzRyQTv8xpELekIDM
fbqJUsrPTGReRSgEzpfahQ6sJ/FuoKSXLMyg/KG/YLV78wTuuf3OjUXpLjXz9ybs
poU7pP3DT0Nb37gohoedTsdbFJyO2EsRKesJ09YhobTnybnJ9+NaesSw3tFu+hNC
6eGJvYKYGgCGumwkvRoEF5YsurPOI/7onkIbRwTpvfNWA/FxuRjNiVwUR0NPlLE=
=+d4a
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
