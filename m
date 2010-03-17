Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754726Ab0CQMKi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 08:10:38 -0400
Received: from hera.kernel.org ([140.211.167.34]:34925 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754691Ab0CQMKg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 08:10:36 -0400
Date: Wed, 17 Mar 2010 12:09:51 GMT
From: tip-bot for Robert Richter <robert.richter@amd.com>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, hpa@zytor.com,
       mingo@redhat.com, robert.richter@amd.com, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, eranian@google.com,
       linux-kernel@vger.kernel.org, robert.richter@amd.com,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1268826553-19518-3-git-send-email-robert.richter@amd.com>
References: <1268826553-19518-3-git-send-email-robert.richter@amd.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf/core: Correct files in MAINTAINERS entry
Message-ID: <tip-141c4296cb630a7ed4c3730913bc3c0617ef9753@git.kernel.org>
Git-Commit-ID: 141c4296cb630a7ed4c3730913bc3c0617ef9753
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 17 Mar 2010 12:09:52 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  141c4296cb630a7ed4c3730913bc3c0617ef9753
Gitweb:     http://git.kernel.org/tip/141c4296cb630a7ed4c3730913bc3c0617ef9753
Author:     Robert Richter <robert.richter@amd.com>
AuthorDate: Wed, 17 Mar 2010 12:49:11 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 17 Mar 2010 13:06:58 +0100

perf/core: Correct files in MAINTAINERS entry

This corrects the file entries for perf_events. The following
files are caught now:

 $ xargs | eval ls $(cat) | sort -u
 kernel/perf_event*.c
 include/linux/perf_event.h
 arch/*/kernel/perf_event*.c
 arch/*/kernel/*/perf_event*.c
 arch/*/kernel/*/*/perf_event*.c
 arch/*/include/asm/perf_event.h
 arch/*/lib/perf_event*.c
 arch/*/kernel/perf_callchain.c

 arch/alpha/include/asm/perf_event.h
 arch/arm/include/asm/perf_event.h
 arch/arm/kernel/perf_event.c
 arch/frv/include/asm/perf_event.h
 arch/frv/lib/perf_event.c
 arch/parisc/include/asm/perf_event.h
 arch/powerpc/include/asm/perf_event.h
 arch/powerpc/kernel/perf_callchain.c
 arch/powerpc/kernel/perf_event.c
 arch/s390/include/asm/perf_event.h
 arch/sh/include/asm/perf_event.h
 arch/sh/kernel/cpu/sh4a/perf_event.c
 arch/sh/kernel/cpu/sh4/perf_event.c
 arch/sh/kernel/perf_callchain.c
 arch/sh/kernel/perf_event.c
 arch/sparc/include/asm/perf_event.h
 arch/sparc/kernel/perf_event.c
 arch/x86/include/asm/perf_event.h
 arch/x86/kernel/cpu/perf_event_amd.c
 arch/x86/kernel/cpu/perf_event.c
 arch/x86/kernel/cpu/perf_event_intel.c
 arch/x86/kernel/cpu/perf_event_p6.c
 include/linux/perf_event.h
 kernel/perf_event.c

Signed-off-by: Robert Richter <robert.richter@amd.com>
Cc: Stephane Eranian <eranian@google.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <1268826553-19518-3-git-send-email-robert.richter@amd.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 MAINTAINERS |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 14d5c4c..e3aa850 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4295,13 +4295,13 @@ M:	Paul Mackerras <paulus@samba.org>
 M:	Ingo Molnar <mingo@elte.hu>
 M:	Arnaldo Carvalho de Melo <acme@redhat.com>
 S:	Supported
-F:	kernel/perf_event.c
+F:	kernel/perf_event*.c
 F:	include/linux/perf_event.h
-F:	arch/*/kernel/perf_event.c
-F:	arch/*/kernel/*/perf_event.c
-F:	arch/*/kernel/*/*/perf_event.c
+F:	arch/*/kernel/perf_event*.c
+F:	arch/*/kernel/*/perf_event*.c
+F:	arch/*/kernel/*/*/perf_event*.c
 F:	arch/*/include/asm/perf_event.h
-F:	arch/*/lib/perf_event.c
+F:	arch/*/lib/perf_event*.c
 F:	arch/*/kernel/perf_callchain.c
 F:	tools/perf/
 
