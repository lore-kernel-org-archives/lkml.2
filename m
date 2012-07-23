Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753230Ab2GWGXh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 02:23:37 -0400
Received: from mga14.intel.com ([143.182.124.37]:2285 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753061Ab2GWGXg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 02:23:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="171817363"
From: "Yan, Zheng" <zheng.z.yan@intel.com>
To: a.p.zijlstra@chello.nl, eranian@google.com, mingo@elte.hu,
        andi@firstfloor.org, linux-kernel@vger.kernel.org
Cc: "Yan, Zheng" <zheng.z.yan@intel.com>
Subject: [PATCH 1/4] perf/x86: Fix typo in format definition of uncore PCU filter
Date: Mon, 23 Jul 2012 14:23:30 +0800
Message-Id: <1343024611-4692-1-git-send-email-zheng.z.yan@intel.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Yan, Zheng" <zheng.z.yan@intel.com>

The format definition of uncore PCU filter should be filter_band*
instead of filter_brand*.

Reported-by: Stephane Eranian <eranian@google.com>
Signed-off-by: Yan, Zheng <zheng.z.yan@intel.com>
---
 arch/x86/kernel/cpu/perf_event_intel_uncore.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel_uncore.c b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
index 19faffc..a5de59f 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_uncore.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
@@ -33,10 +33,10 @@ DEFINE_UNCORE_FORMAT_ATTR(filter_tid, filter_tid, "config1:0-4");
 DEFINE_UNCORE_FORMAT_ATTR(filter_nid, filter_nid, "config1:10-17");
 DEFINE_UNCORE_FORMAT_ATTR(filter_state, filter_state, "config1:18-22");
 DEFINE_UNCORE_FORMAT_ATTR(filter_opc, filter_opc, "config1:23-31");
-DEFINE_UNCORE_FORMAT_ATTR(filter_brand0, filter_brand0, "config1:0-7");
-DEFINE_UNCORE_FORMAT_ATTR(filter_brand1, filter_brand1, "config1:8-15");
-DEFINE_UNCORE_FORMAT_ATTR(filter_brand2, filter_brand2, "config1:16-23");
-DEFINE_UNCORE_FORMAT_ATTR(filter_brand3, filter_brand3, "config1:24-31");
+DEFINE_UNCORE_FORMAT_ATTR(filter_band0, filter_band0, "config1:0-7");
+DEFINE_UNCORE_FORMAT_ATTR(filter_band1, filter_band1, "config1:8-15");
+DEFINE_UNCORE_FORMAT_ATTR(filter_band2, filter_band2, "config1:16-23");
+DEFINE_UNCORE_FORMAT_ATTR(filter_band3, filter_band3, "config1:24-31");
 
 /* Sandy Bridge-EP uncore support */
 static struct intel_uncore_type snbep_uncore_cbox;
@@ -272,10 +272,10 @@ static struct attribute *snbep_uncore_pcu_formats_attr[] = {
 	&format_attr_thresh5.attr,
 	&format_attr_occ_invert.attr,
 	&format_attr_occ_edge.attr,
-	&format_attr_filter_brand0.attr,
-	&format_attr_filter_brand1.attr,
-	&format_attr_filter_brand2.attr,
-	&format_attr_filter_brand3.attr,
+	&format_attr_filter_band0.attr,
+	&format_attr_filter_band1.attr,
+	&format_attr_filter_band2.attr,
+	&format_attr_filter_band3.attr,
 	NULL,
 };
 
-- 
1.7.10.4

