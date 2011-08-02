Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751474Ab1HBGPB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 02:15:01 -0400
Received: from mga02.intel.com ([134.134.136.20]:60781 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750759Ab1HBGO4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 02:14:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,305,1309762800"; 
   d="scan'208";a="34518004"
From: Youquan Song <youquan.song@intel.com>
To: linux-kernel@vger.kernel.org, mingo@elte.hu, peterz@infradead.org
Cc: ming.m.lin@intel.com, anhua.xu@intel.com, chaohong.guo@intel.com,
        kent.liu@intel.com, Youquan Song <youquan.song@linux.intel.com>,
        Youquan Song <youquan.song@intel.com>
Subject: [PATCH] perf, x86: Add model 45 SandyBridge support
Date: Tue,  2 Aug 2011 14:01:35 +0800
Message-Id: <1312264895-2010-1-git-send-email-youquan.song@intel.com>
X-Mailer: git-send-email 1.6.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support to Romely-EP SandyBridge.

Signed-off-by: Youquan Song <youquan.song@intel.com>
Signed-off-by: Anhua Xu <anhua.xu@intel.com>
Signed-off-by: Lin Ming <ming.m.lin@intel.com>
---
 arch/x86/kernel/cpu/perf_event_intel.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index 45fbb8f..f88af2c 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -1590,6 +1590,7 @@ static __init int intel_pmu_init(void)
 		break;
 
 	case 42: /* SandyBridge */
+	case 45: /* SandyBridge, "Romely-EP" */
 		memcpy(hw_cache_event_ids, snb_hw_cache_event_ids,
 		       sizeof(hw_cache_event_ids));
 
-- 
1.6.4.2


