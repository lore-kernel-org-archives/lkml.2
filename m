Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754676Ab0CQLxO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 07:53:14 -0400
Received: from va3ehsobe002.messaging.microsoft.com ([216.32.180.12]:31574
	"EHLO VA3EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753831Ab0CQLxE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 07:53:04 -0400
X-SpamScore: -4
X-BigFish: VPS-4(zz936eMab9bhzz1202hzzz32i6bh2a8h87h63h)
X-Spam-TCS-SCL: 2:0
X-FB-SS: 5,
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0KZFCZS-02-31A-02
X-M-MSG: 
From: Robert Richter <robert.richter@amd.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Ingo Molnar <mingo@elte.hu>, Stephane Eranian <eranian@google.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Robert Richter <robert.richter@amd.com>
Subject: [PATCH 2/4] perf/core: correct files in MAINTAINERS entry
Date: Wed, 17 Mar 2010 12:49:11 +0100
Message-ID: <1268826553-19518-3-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.7.0
In-Reply-To: <1268826553-19518-1-git-send-email-robert.richter@amd.com>
References: <1268826553-19518-1-git-send-email-robert.richter@amd.com>
X-OriginalArrivalTime: 17 Mar 2010 11:52:37.0763 (UTC) FILETIME=[57061D30:01CAC5C8]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This corrects the file entries for perf_events. The following files
are catched now:

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
 
-- 
1.7.0


