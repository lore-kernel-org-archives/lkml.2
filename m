Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933656Ab2LHPKy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2012 10:10:54 -0500
Received: from terminus.zytor.com ([198.137.202.10]:49817 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933588Ab2LHPKx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2012 10:10:53 -0500
Date: Sat, 8 Dec 2012 07:10:19 -0800
From: tip-bot for Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Message-ID: <tip-1483c2ae90738e7453bfe446a3bbcdd0ba9abf36@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        mingo@redhat.com, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, robert.richter@amd.com, dhowells@redhat.com,
        anton@au1.ibm.com, tglx@linutronix.de, sukadev@linux.vnet.ibm.com
Reply-To: mingo@kernel.org, hpa@zytor.com, mingo@redhat.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        robert.richter@amd.com, dhowells@redhat.com, anton@au1.ibm.com,
        sukadev@linux.vnet.ibm.com, tglx@linutronix.de
In-Reply-To: <20121107191818.GA16211@us.ibm.com>
References: <20121107191818.GA16211@us.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf powerpc: Use uapi/
 unistd.h to fix build error
Git-Commit-ID: 1483c2ae90738e7453bfe446a3bbcdd0ba9abf36
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Sat, 08 Dec 2012 07:10:33 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1483c2ae90738e7453bfe446a3bbcdd0ba9abf36
Gitweb:     http://git.kernel.org/tip/1483c2ae90738e7453bfe446a3bbcdd0ba9abf36
Author:     Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
AuthorDate: Wed, 31 Oct 2012 11:21:28 -0700
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 14 Nov 2012 16:53:39 -0300

perf powerpc: Use uapi/unistd.h to fix build error

Use the 'unistd.h' from arch/powerpc/include/uapi to build the perf tool.

Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Acked-by: David Howells <dhowells@redhat.com>
Cc: Anton Blanchard <anton@au1.ibm.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Robert Richter <robert.richter@amd.com>
Cc: linuxppc-dev@ozlabs.org
Link: http://lkml.kernel.org/r/20121107191818.GA16211@us.ibm.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/perf.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/perf.h b/tools/perf/perf.h
index 0047264..f53ee0b 100644
--- a/tools/perf/perf.h
+++ b/tools/perf/perf.h
@@ -26,7 +26,7 @@ void get_term_dimensions(struct winsize *ws);
 #endif
 
 #ifdef __powerpc__
-#include "../../arch/powerpc/include/asm/unistd.h"
+#include "../../arch/powerpc/include/uapi/asm/unistd.h"
 #define rmb()		asm volatile ("sync" ::: "memory")
 #define cpu_relax()	asm volatile ("" ::: "memory");
 #define CPUINFO_PROC	"cpu"
