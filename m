Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933045Ab1LFJh6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 04:37:58 -0500
Received: from terminus.zytor.com ([198.137.202.10]:34698 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932901Ab1LFJh4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 04:37:56 -0500
Date: Tue, 6 Dec 2011 01:37:22 -0800
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Message-ID: <tip-w0z98as3kwy9bo1o3k2mmuvi@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] MAINTAINERS: Update tip.git related git trees
Git-Commit-ID: 75fc2d3797c47f5f70ca71c41c342c352845cd06
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 06 Dec 2011 01:37:29 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  75fc2d3797c47f5f70ca71c41c342c352845cd06
Gitweb:     http://git.kernel.org/tip/75fc2d3797c47f5f70ca71c41c342c352845cd06
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Mon, 5 Dec 2011 17:27:08 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 6 Dec 2011 08:09:40 +0100

MAINTAINERS: Update tip.git related git trees

Update the six major subsystem trees hosted in the tip tree to
the new location (or add the location if it was missing).

Acked-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/n/tip-w0z98as3kwy9bo1o3k2mmuvi@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 MAINTAINERS |   13 +++++++++----
 1 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 4475602..9706a21 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3118,6 +3118,7 @@ F:	include/linux/hid*
 
 HIGH-RESOLUTION TIMERS, CLOCKEVENTS, DYNTICKS
 M:	Thomas Gleixner <tglx@linutronix.de>
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git timers/core
 S:	Maintained
 F:	Documentation/timers/
 F:	kernel/hrtimer.c
@@ -3627,7 +3628,7 @@ F:	net/irda/
 IRQ SUBSYSTEM
 M:	Thomas Gleixner <tglx@linutronix.de>
 S:	Maintained
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git irq/core
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git irq/core
 F:	kernel/irq/
 
 ISAPNP
@@ -4115,7 +4116,7 @@ F:	drivers/hwmon/lm90.c
 LOCKDEP AND LOCKSTAT
 M:	Peter Zijlstra <peterz@infradead.org>
 M:	Ingo Molnar <mingo@redhat.com>
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/peterz/linux-2.6-lockdep.git
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git core/locking
 S:	Maintained
 F:	Documentation/lockdep*.txt
 F:	Documentation/lockstat.txt
@@ -5102,6 +5103,7 @@ M:	Peter Zijlstra <a.p.zijlstra@chello.nl>
 M:	Paul Mackerras <paulus@samba.org>
 M:	Ingo Molnar <mingo@elte.hu>
 M:	Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git perf/core
 S:	Supported
 F:	kernel/events/*
 F:	include/linux/perf_event.h
@@ -5181,6 +5183,7 @@ F:	drivers/scsi/pm8001/
 
 POSIX CLOCKS and TIMERS
 M:	Thomas Gleixner <tglx@linutronix.de>
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git timers/core
 S:	Supported
 F:	fs/timerfd.c
 F:	include/linux/timer*
@@ -5696,6 +5699,7 @@ F:	drivers/dma/dw_dmac.c
 TIMEKEEPING, NTP
 M:	John Stultz <johnstul@us.ibm.com>
 M:	Thomas Gleixner <tglx@linutronix.de>
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git timers/core
 S:	Supported
 F:	include/linux/clocksource.h
 F:	include/linux/time.h
@@ -5720,6 +5724,7 @@ F:	drivers/watchdog/sc1200wdt.c
 SCHEDULER
 M:	Ingo Molnar <mingo@elte.hu>
 M:	Peter Zijlstra <peterz@infradead.org>
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git sched/core
 S:	Maintained
 F:	kernel/sched*
 F:	include/linux/sched.h
@@ -6647,7 +6652,7 @@ TRACING
 M:	Steven Rostedt <rostedt@goodmis.org>
 M:	Frederic Weisbecker <fweisbec@gmail.com>
 M:	Ingo Molnar <mingo@redhat.com>
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git perf/core
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git perf/core
 S:	Maintained
 F:	Documentation/trace/ftrace.txt
 F:	arch/*/*/*/ftrace.h
@@ -7397,7 +7402,7 @@ M:	Thomas Gleixner <tglx@linutronix.de>
 M:	Ingo Molnar <mingo@redhat.com>
 M:	"H. Peter Anvin" <hpa@zytor.com>
 M:	x86@kernel.org
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/x86/linux-2.6-x86.git
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86/core
 S:	Maintained
 F:	Documentation/x86/
 F:	arch/x86/
