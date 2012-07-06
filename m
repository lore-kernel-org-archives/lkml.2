Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756384Ab2GFJ74 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 05:59:56 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:52148 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751010Ab2GFJ7z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 05:59:55 -0400
From: Pekka Enberg <penberg@kernel.org>
To: mingo@kernel.org
Cc: linux-kernel@vger.kernel.org, Pekka Enberg <penberg@kernel.org>
Subject: [PATCH] perf, x86: Fix "intel_perfmon_event_map" formatting
Date: Fri,  6 Jul 2012 12:59:46 +0300
Message-Id: <1341568786-7045-1-git-send-email-penberg@kernel.org>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use tabs for "intel_perfmon_event_map" formatting in perf_event_intel.c.

Signed-off-by: Pekka Enberg <penberg@kernel.org>
---
 arch/x86/kernel/cpu/perf_event_intel.c |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index 26b3e2f..4548294 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -21,14 +21,14 @@
  */
 static u64 intel_perfmon_event_map[PERF_COUNT_HW_MAX] __read_mostly =
 {
-  [PERF_COUNT_HW_CPU_CYCLES]		= 0x003c,
-  [PERF_COUNT_HW_INSTRUCTIONS]		= 0x00c0,
-  [PERF_COUNT_HW_CACHE_REFERENCES]	= 0x4f2e,
-  [PERF_COUNT_HW_CACHE_MISSES]		= 0x412e,
-  [PERF_COUNT_HW_BRANCH_INSTRUCTIONS]	= 0x00c4,
-  [PERF_COUNT_HW_BRANCH_MISSES]		= 0x00c5,
-  [PERF_COUNT_HW_BUS_CYCLES]		= 0x013c,
-  [PERF_COUNT_HW_REF_CPU_CYCLES]	= 0x0300, /* pseudo-encoding */
+	[PERF_COUNT_HW_CPU_CYCLES]		= 0x003c,
+	[PERF_COUNT_HW_INSTRUCTIONS]		= 0x00c0,
+	[PERF_COUNT_HW_CACHE_REFERENCES]	= 0x4f2e,
+	[PERF_COUNT_HW_CACHE_MISSES]		= 0x412e,
+	[PERF_COUNT_HW_BRANCH_INSTRUCTIONS]	= 0x00c4,
+	[PERF_COUNT_HW_BRANCH_MISSES]		= 0x00c5,
+	[PERF_COUNT_HW_BUS_CYCLES]		= 0x013c,
+	[PERF_COUNT_HW_REF_CPU_CYCLES]		= 0x0300, /* pseudo-encoding */
 };
 
 static struct event_constraint intel_core_event_constraints[] __read_mostly =
-- 
1.7.7.6

