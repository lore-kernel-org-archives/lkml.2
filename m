Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759480Ab2JTBEh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 21:04:37 -0400
Received: from terminus.zytor.com ([198.137.202.10]:36269 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755490Ab2JTBEg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 21:04:36 -0400
Date: Fri, 19 Oct 2012 18:04:18 -0700
From: tip-bot for David Miller <davem@davemloft.net>
Message-ID: <tip-77626081849c9050b20670e5d832aca54c966936@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        mingo@redhat.com, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, davem@davemloft.net, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, mingo@redhat.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        tglx@linutronix.de, davem@davemloft.net
In-Reply-To: <20121017.010656.383828471689899431.davem@davemloft.net>
References: <20121017.010656.383828471689899431.davem@davemloft.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf tools: Fix build on sparc.
Git-Commit-ID: 77626081849c9050b20670e5d832aca54c966936
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 19 Oct 2012 18:04:24 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  77626081849c9050b20670e5d832aca54c966936
Gitweb:     http://git.kernel.org/tip/77626081849c9050b20670e5d832aca54c966936
Author:     David Miller <davem@davemloft.net>
AuthorDate: Wed, 17 Oct 2012 01:06:56 -0400
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 17 Oct 2012 11:45:58 -0300

perf tools: Fix build on sparc.

More UAPI stuff.

Signed-off-by: David S. Miller <davem@davemloft.net>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/20121017.010656.383828471689899431.davem@davemloft.net
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/perf.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/perf/perf.h b/tools/perf/perf.h
index 87f4ec6..8421c20 100644
--- a/tools/perf/perf.h
+++ b/tools/perf/perf.h
@@ -57,7 +57,7 @@ void get_term_dimensions(struct winsize *ws);
 #endif
 
 #ifdef __sparc__
-#include "../../arch/sparc/include/asm/unistd.h"
+#include "../../arch/sparc/include/uapi/asm/unistd.h"
 #define rmb()		asm volatile("":::"memory")
 #define cpu_relax()	asm volatile("":::"memory")
 #define CPUINFO_PROC	"cpu"
