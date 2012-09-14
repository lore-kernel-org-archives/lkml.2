Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755706Ab2INDCh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 23:02:37 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:5263 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752815Ab2INDCe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 23:02:34 -0400
X-Authority-Analysis: v=2.0 cv=Hsb06jvS c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=2Mh-cCeu28sA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=AIeXs8dyjyoA:10 a=VwQbUJbxAAAA:8 a=nhhxxhPc0NLWR9hTDX8A:9 a=QEXdDO2ut3YA:10 a=xCOesS7-aKD2YQXcbAkA:9 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-Id: <20120914030012.315074731@goodmis.org>
User-Agent: quilt/0.60-1
Date: Thu, 13 Sep 2012 23:00:12 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 0/6 v2] [GIT PULL][3.7] tracing: cleanups and fixes
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable


Ingo,

As I believe the -pg removal from perf was holding up the patch
set, although Frederic and I are working that out, I rebased my
patch set to remove that change, for a later time.

The rest holds fixes to bugs that are in your queue for 3.7.

Please pull the latest tip/perf/core tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
tip/perf/core

Head SHA1: c6aaf4d0bb86e2154ea31a33804cec300611255f


Josh Triplett (1):
      trace: Stop compiling in trace_clock unconditionally

Masami Hiramatsu (3):
      ftrace/x86: Adjust x86 regs.ip as like as x86-64
      kprobes/x86: Fix kprobes to collectly handle IP on ftrace
      kprobes/x86: Fix to support jprobes on ftrace-based kprobe

Steven Rostedt (1):
      ftrace/x86-64: Allow to change RIP in handlers

Yuanhan Liu (1):
      tracing: Skip printing "OK" if failed to disable event

----
 arch/x86/kernel/entry_32.S  |    3 +--
 arch/x86/kernel/entry_64.S  |    4 ++++
 arch/x86/kernel/kprobes.c   |   43 +++++++++++++++++++++++++++++++--------=
----
 kernel/Makefile             |    2 +-
 kernel/kprobes.c            |    3 ---
 kernel/trace/Kconfig        |    5 +++++
 kernel/trace/Makefile       |    6 +-----
 kernel/trace/trace_events.c |    4 +++-
 8 files changed, 46 insertions(+), 24 deletions(-)

--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQEcBAABAgAGBQJQUp5FAAoJEOdOSU1xswtM6M4H/3XL0tCO0Vk0ZPDtWi8YCJr/
aIa2JBXAa8lYdt19dX9kYWA/qKKP3xVw4dFAYcf/kRTADoyg4j93e9KR4HxJQ5F2
rvtwQHXykckd1BKiatxw+tDEk+B7LYOBFPRUNdlF0jCs3rESN6KDePv1We14ilZS
x6H33bPrUq017oNUZCjccR2MOFYiNQCG9h6WmSD1TMnB6fOMlX7fKNA5FEthykGL
C+pHdzLvrsUCc/9IDK1bgg8sAiiJiKOhnkYMce2RaxZUV3mkqfwRqOtQuRj+QANb
rYW5JQomC+QQasjUZw57w5aApuC1jPPYzrwydT13782ALZ0cCbEgBR5W7zqiY70=
=K8rW
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
