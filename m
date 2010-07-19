Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967170Ab0GSXIV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jul 2010 19:08:21 -0400
Received: from mga01.intel.com ([192.55.52.88]:44650 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967083Ab0GSXIS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jul 2010 19:08:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.55,229,1278313200"; 
   d="scan'208";a="587751046"
Message-Id: <20100719230205.523204988@sbs-t61.sc.intel.com>
User-Agent: quilt/0.47-1
Date: Mon, 19 Jul 2010 16:05:51 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [patch 4/5] x86: Add xsaveopt cpufeature
References: <20100719225747.372816924@sbs-t61.sc.intel.com>
Content-Disposition: inline; filename=xsaveopt_cpu_feature.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add cpu feature bit support for the XSAVEOPT instruction.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---
 arch/x86/include/asm/cpufeature.h |    1 +
 1 file changed, 1 insertion(+)

Index: tip-linux-2.6/arch/x86/include/asm/cpufeature.h
===================================================================
--- tip-linux-2.6.orig/arch/x86/include/asm/cpufeature.h
+++ tip-linux-2.6/arch/x86/include/asm/cpufeature.h
@@ -165,6 +165,7 @@
 #define X86_FEATURE_ARAT	(7*32+ 1) /* Always Running APIC Timer */
 #define X86_FEATURE_CPB		(7*32+ 2) /* AMD Core Performance Boost */
 #define X86_FEATURE_EPB		(7*32+ 3) /* IA32_ENERGY_PERF_BIAS support */
+#define X86_FEATURE_XSAVEOPT	(7*32+4) /* "xsaveopt" Optimized Xsave */
 
 /* Virtualization flags: Linux defined, word 8 */
 #define X86_FEATURE_TPR_SHADOW  (8*32+ 0) /* Intel TPR Shadow */


