Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752368Ab0HYGrs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Aug 2010 02:47:48 -0400
Received: from mga09.intel.com ([134.134.136.24]:34472 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752326Ab0HYGrp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Aug 2010 02:47:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,267,1280732400"; 
   d="scan'208";a="651036861"
Subject: [PATCH] perf: Fix build warning
From: Lin Ming <ming.m.lin@intel.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 25 Aug 2010 14:49:09 +0800
Message-ID: <1282718949.16443.75.camel@minggr.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixes build warning introduced by the callchain rework

arch/x86/kernel/cpu/perf_event.c:1574: warning: ‘perf_callchain_entry_nmi’ defined but not used

Signed-off-by: Lin Ming <ming.m.lin@intel.com>
---
 arch/x86/kernel/cpu/perf_event.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index acc52af..bcddac6 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -1571,9 +1571,6 @@ const struct pmu *hw_perf_event_init(struct perf_event *event)
  * callchain support
  */
 
-static DEFINE_PER_CPU(struct perf_callchain_entry, perf_callchain_entry_nmi);
-
-
 static void
 backtrace_warning_symbol(void *data, char *msg, unsigned long symbol)
 {


