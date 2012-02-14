Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759157Ab2BNDkK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 22:40:10 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:63772 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755062Ab2BNDkI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 22:40:08 -0500
X-Authority-Analysis: v=2.0 cv=MaXuSuDf c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=UBy9sU4F98IA:10 a=FAhICIwCD3kA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=VwQbUJbxAAAA:8 a=uzs63usq13Mj95I1G9kA:9 a=QEXdDO2ut3YA:10 a=Q2dqm6fvsLfs2mMeFy4A:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20120214033909.904564921@goodmis.org>
User-Agent: quilt/0.50-1
Date: Mon, 13 Feb 2012 22:39:09 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 0/9] [GIT PULL] tracing: cleanups, updates, and fixes
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

Head SHA1: 47b0edcb599ea6eb9ef16d3a08932a0e01485293


Geunsik Lim (2):
      ftrace: sched_switch plugin is deprecated
      ftrace: Append wakeup_rt description of ftrace doc

Jiri Olsa (1):
      ftrace: Change filter/notrace set functions to return exit code

Johannes Berg (1):
      printk/tracing: Add console output tracing

Steven Rostedt (4):
      tracing/softirq: Move __raise_softirq_irqoff() out of header
      tracing/rcu: Add trace_##name##__rcuidle() static tracepoint for insi=
de rcu_idle_exit() sections
      x86/tracing: Denote the power and cpuidle tracepoints as _rcuidle()
      cpuidle/tracing: Denote the tracepoints as being in rcu_idle_exit() s=
ection

Thomas Meyer (1):
      tracing/trivial: Use kcalloc instead of kzalloc to allocate array

----
 Documentation/trace/ftrace.txt     |    7 ++++++
 arch/x86/kernel/process.c          |   24 ++++++++++----------
 drivers/cpuidle/cpuidle.c          |    8 +++---
 include/linux/ftrace.h             |    4 +-
 include/linux/interrupt.h          |    7 +-----
 include/linux/tracepoint.h         |   22 +++++++++++++++---
 include/trace/events/power.h       |    2 +
 include/trace/events/printk.h      |   41 ++++++++++++++++++++++++++++++++=
++++
 kernel/irq/chip.c                  |    2 +
 kernel/printk.c                    |    5 ++++
 kernel/softirq.c                   |    6 +++++
 kernel/trace/ftrace.c              |   17 ++++++++------
 kernel/trace/trace.c               |    6 ++--
 kernel/trace/trace_events_filter.c |    7 ++---
 kernel/trace/trace_syscalls.c      |    4 +-
 15 files changed, 118 insertions(+), 44 deletions(-)

--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJPOdeSAAoJEIy3vGnGbaoAaF4QAL9YkoUv/i0kFzkrbUSPAaJg
A9ugLZIj7oHYAsdISjvf7O6AAx5SR707MtFMT+cqpzMsGBEtVND/LQXnzSAg09CF
Y8/Fs5R7AqYVXHHoshR3m4aSRii7g4RGBBXT8JMC7jbts1lbxv9LI6/UDg3upOYp
r9G61wt9DQlFUVa1Umz/uMxHriAF2LaycJljWjEswsuOPB3+242aRcGQxFQ2ZQ+x
dbf5JluDbQKpDI21ehc0ZqgAW/OKAM6Ba8lhisFea3nW4ibHju9l9Vva6hFM6Dcu
15+614/mAtu5jtA+BuBrkVzFf+gegY+I6Q2RM5krmc6lovb5ijZyeiisNgCixsxR
FF4f5XZdXDpiBMr/xB+6dh10vMXCInrIH296xP0Ef9ohUVayG0WEiwnKSf7C6W7T
qklLgi6odMFs2ybknaRPyaWF2Mm/NjdiuiMGbnn/CJFfjn2/fF3MwJtKjljYrDAG
0DifFABFfmTQ7tg4uYFRRKgnLkJdrTXtvumkDoXu6iVncy9p2TcPxWKG1GXhhdno
AoPDkKL/YpFkbCFDHFTiJ5UZklOO3/FAahSAlqua9ld54NijB6JQCA7MaCHrnP9l
hW1XiKs0bFyTXKXUE1cgekpZtL4T+0gipihI7H+3X7Mv3j5eJbhLBYj8BOWSUgIh
pl2wAcwI5ZS5iyxipIjR
=q3I7
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
