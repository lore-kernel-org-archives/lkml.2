Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755728Ab1DUXtW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 19:49:22 -0400
Received: from mga02.intel.com ([134.134.136.20]:16478 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755417Ab1DUXtV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 19:49:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,252,1301900400"; 
   d="scan'208";a="632346832"
From: Andi Kleen <andi@firstfloor.org>
To: a.p.zijlstra@chello.nl
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH] PERF: Add Xeon E7 support
Date: Thu, 21 Apr 2011 16:48:35 -0700
Message-Id: <1303429715-10202-1-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Enable Westmere support for Xeon E7 (aka Westmere EX)

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/kernel/cpu/perf_event_intel.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index 4b1ef79..21fb254 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -1427,6 +1427,7 @@ static __init int intel_pmu_init(void)
 
 	case 37: /* 32 nm nehalem, "Clarkdale" */
 	case 44: /* 32 nm nehalem, "Gulftown" */
+	case 47: /* 32 nm Xeon E7 */
 		memcpy(hw_cache_event_ids, westmere_hw_cache_event_ids,
 		       sizeof(hw_cache_event_ids));
 		memcpy(hw_cache_extra_regs, nehalem_hw_cache_extra_regs,
-- 
1.7.4.2

