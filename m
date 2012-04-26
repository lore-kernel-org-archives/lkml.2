Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754821Ab2DZRiI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 13:38:08 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:23344 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754407Ab2DZRhT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 13:37:19 -0400
X-Authority-Analysis: v=2.0 cv=XbcLPfF5 c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=Ciwy3NGCPMMA:10 a=8apk_w49DpYA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=VwQbUJbxAAAA:8 a=5YiUFmR22IEXmetKv9gA:9 a=QEXdDO2ut3YA:10 a=ALpBDCJN47TJb4xfdOIA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20120426173404.666092637@goodmis.org>
User-Agent: quilt/0.60-1
Date: Thu, 26 Apr 2012 13:34:04 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 0/2 v2] [GIT PULL] tracing: updates for 3.5
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable


Ingo,

Although only two patches are in this, it really contains the 5 patches
that I pushed out earlier. As only patch 4/5 changed, instead of
spamming LKML with the same patches 1-3, I'm only reposting 4 and 5.

Patch 5 just came along for the ride (same as the previous post).

Patch 4 (here it's patch 1) was update as per Masami's suggestions (again).

Thanks!

-- Steve

Please pull the latest tip/perf/core-2 tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
tip/perf/core-2

Head SHA1: e2017387836dcb963fcbefa767f9f20282349c75


Steven Rostedt (2):
      ftrace/x86: Have arch x86_64 use breakpoints instead of stop machine
      ftrace/x86: Remove the complex ftrace NMI handling code

----
 arch/x86/Kconfig              |    1 -
 arch/x86/include/asm/ftrace.h |    3 +
 arch/x86/kernel/ftrace.c      |  511 +++++++++++++++++++++++++++----------=
----
 arch/x86/kernel/nmi.c         |   10 +-
 arch/x86/kernel/traps.c       |    8 +-
 include/linux/ftrace.h        |    6 +
 6 files changed, 364 insertions(+), 175 deletions(-)

--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJPmYfJAAoJEIy3vGnGbaoAIlQP/3Lye/539e7LO+VRrE+cPdx+
QeEfSRsqmALS/2cFZcu+GLQsrAF9NH4yvp5Lhq9qJFbiyaNLcsJD1bOKR/TiZ/x8
bFJ4ugVAk7ZeGzH/HCePaC8PLOO2+B7Gcqpl66I+09/dbez5V7SNRI0cZ2Z1GueE
1o+B87TZ9ZuPJylsh8vmm4ShytenMJ8HHSOxN8pIbUPmEQE5JuansF6NxN1XrOW3
KQtwM6cr8c/j+vJ6gu/wDCF/obotXF7OvX7+BC/oEwi0ZbDQUsRJK2ZTnNkHZCHT
XKqBvY8rdr0OErhZkyQWhO0tYkQwrdzmGEUkMpJ0AUtypqfCcaBZZ0RD+FbqBmUg
7GrLaBikEmBXjlRIf9QjsvPDx3+Y8IOGtH7E7/4D6lAnqhvZj/F5kUqG0vWSzTHP
Ks5rbWx9MHauAwz+nc6x4Huotybh0iiVM3ioi8grlroFHV0diG+o5tJRCr9aIBJK
MizgFeGYeEi+cc2R99BM2n0ClFMdhi/yizpBZF5ZvwRnhz9E8it/wtYjHaw74HOq
2eAR0yPptgQ9wCcsoeGZUhZjYXdjfy9V3hyZ3OcXUf0+zt+0CQgz5lkn+ThuecvG
wkw1YTmcASqMCJQ+fk8NKNr6o+cVVw+17FD9K4Cy8JvpoUZjWAXDJEI0yNtxBZmd
ntScoVNR8NaeIqn2j5Dr
=7sBM
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
