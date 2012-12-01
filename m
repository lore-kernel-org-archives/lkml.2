Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751952Ab2LALTA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Dec 2012 06:19:00 -0500
Received: from terminus.zytor.com ([198.137.202.10]:43009 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751386Ab2LALS6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Dec 2012 06:18:58 -0500
Date: Sat, 1 Dec 2012 03:18:20 -0800
From: tip-bot for Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Message-ID: <tip-f2d9cae9ea9e0228f6eb4d4c5ab4f548d0270d1a@git.kernel.org>
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
Subject: [tip:perf/urgent] perf powerpc: Use uapi/
 unistd.h to fix build error
Git-Commit-ID: f2d9cae9ea9e0228f6eb4d4c5ab4f548d0270d1a
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Sat, 01 Dec 2012 03:18:26 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f2d9cae9ea9e0228f6eb4d4c5ab4f548d0270d1a
Gitweb:     http://git.kernel.org/tip/f2d9cae9ea9e0228f6eb4d4c5ab4f548d0270d1a
Author:     Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
AuthorDate: Wed, 31 Oct 2012 11:21:28 -0700
Committer:  David Howells <dhowells@redhat.com>
CommitDate: Mon, 19 Nov 2012 22:10:41 +0000

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
index c50985e..e2ba8f0 100644
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
