Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932576Ab2GBSnj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 14:43:39 -0400
Received: from mga09.intel.com ([134.134.136.24]:48960 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932422Ab2GBSnh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 14:43:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="160639823"
From: Andi Kleen <andi@firstfloor.org>
To: x86@kernel.org
Cc: a.p.zijlstra@chello.nl, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 5/5] perf, x86: Spell Romley correctly.
Date: Mon,  2 Jul 2012 11:43:18 -0700
Message-Id: <1341254598-1379-6-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1341254598-1379-1-git-send-email-andi@firstfloor.org>
References: <1341254598-1379-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Romley is spelled Romley, not Romely.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/kernel/cpu/perf_event_intel.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index b255da3..81a4915 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -1956,7 +1956,7 @@ __init int intel_pmu_init(void)
 		break;
 
 	case 42: /* SandyBridge */
-	case 45: /* SandyBridge, "Romely-EP" */
+	case 45: /* SandyBridge, "Romley-EP" */
 		memcpy(hw_cache_event_ids, snb_hw_cache_event_ids,
 		       sizeof(hw_cache_event_ids));
 
-- 
1.7.7.6

