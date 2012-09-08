Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754636Ab2IHL4q (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Sep 2012 07:56:46 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:10456 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754320Ab2IHL4m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Sep 2012 07:56:42 -0400
X-Authority-Analysis: v=2.0 cv=Vb91zSV9 c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=zohW71QBCJQA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=tmB2mkYsrq0A:10 a=VwQbUJbxAAAA:8 a=So1vgxFugdTeBTRJBTYA:9 a=QEXdDO2ut3YA:10 a=yunKqkquyJGSzlD8fqEA:9 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-Id: <20120908115515.211175517@goodmis.org>
User-Agent: quilt/0.60-1
Date: Sat, 08 Sep 2012 07:55:15 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 0/7] [GIT PULL][v3.7] tracing: Updates and fixes (for 3.7 queue)
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

Head SHA1: d73177789872d52ab916c749357b883d56208e21


Andi Kleen (1):
      perf: Enable function tracing for perf core

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
 arch/x86/kernel/cpu/Makefile |    1 -
 arch/x86/kernel/entry_32.S   |    3 +--
 arch/x86/kernel/entry_64.S   |    4 ++++
 arch/x86/kernel/kprobes.c    |   43 ++++++++++++++++++++++++++++++--------=
----
 kernel/Makefile              |    2 +-
 kernel/events/Makefile       |    4 ----
 kernel/kprobes.c             |    3 ---
 kernel/trace/Kconfig         |    5 +++++
 kernel/trace/Makefile        |    6 +-----
 kernel/trace/trace_events.c  |    4 +++-
 10 files changed, 46 insertions(+), 29 deletions(-)

--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJQSzJzAAoJEIy3vGnGbaoArVgQAL1MdgEy6EcycNA1Y2YCVW6K
4Z92t/+4WnY9jEFBGcAhn/3iesI0JDF+LICsIw2kYb1SLpru2TdXrBPsja/nZNRa
yJQqG5VgD+vnMB9JFPxsuWuUs6pvP1efzlYrIiD5FfaIFnuJ6TaCalAyW75AsSnS
zPpdaJO1grCf2WBZLXbmK8YXoBIAQf/lEbXIwSZnK5L34iP8C2YRLtmEYB4Y1hUt
NLJc1B9aZ4yhCIa2ooUskD5vvongCtEhVRZfBpMFAKm6+1kxUpM9X+XHRzE1WgGu
dngTYEmyvtfK7XFy2joh2BrCb9rZ+zGw4mi/DieP42jib3E/O+UoX3+8d7x92jfI
UI2VvMWCYfz9WVvMOUWyGApkXQiv1Kj8PDHNjcdu6WCmL+9NUp8kkmYBdmiPA20a
lMdjkzE9OcIJqyA1noL4bgLZgNWcZ9BZ1ccwlJxzmfBX2RiCMHKhff+qjbVJ6s7k
Tw/OKhRQ2BNWiIBv7pCISbdF2ckK2xxuRnI2LRiY4DgWYticu8eXsheNSg9ij9wz
fZQ3qIKOG11ZGHNth6CD/P9KTS0tKm3kUbT94mfjUxoFYGgTqCZdIww6AfEu27Hb
sMRKRHJC104YUtrO9AR+bKs32smpq1gTvvcoU/XBZwaXp8uwagAtnjL+JIhifv89
eO6VumdgY5/aoSIUm16s
=IIoB
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
