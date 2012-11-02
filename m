Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758637Ab2KBQrN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 12:47:13 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:48968 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753017Ab2KBQrL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 12:47:11 -0400
Date: Fri, 2 Nov 2012 09:48:12 -0700
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: acme@ghostprotocols.net, a.p.zijlstra@chello.nl, paulus@samba.org
Cc: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: [PATCH] perf: powerpc: Use uapi/unistd.h to fix build error
Message-ID: <20121102164812.GA25300@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12110216-8974-0000-0000-0000108120B3
X-IBM-ISS-SpamDetectors: 
X-IBM-ISS-DetailInfo: BY=3.00000294; HX=3.00000198; KW=3.00000007;
 PH=3.00000001; SC=3.00000008; SDB=6.00187854; UDB=6.00042545; UTC=2012-11-02
 16:47:06
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Date: Wed, 31 Oct 2012 11:21:28 -0700
Subject: [PATCH] perf: powerpc: Use uapi/unistd.h to fix build error

Use the 'unistd.h' from arch/powerpc/include/uapi to build the perf tool.

Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
---
 tools/perf/perf.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/perf/perf.h b/tools/perf/perf.h
index 054182e..f4952da 100644
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
-- 
1.7.1

