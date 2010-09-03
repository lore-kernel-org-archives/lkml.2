Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755904Ab0ICIGo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 04:06:44 -0400
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:17331 "EHLO
	TX2EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755696Ab0ICIG3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 04:06:29 -0400
X-SpamScore: -3
X-BigFish: VPS-3(z5edIzbb2cKzz1202hzz8275bhz32i2a8h43h61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0L85VMH-01-HXI-02
X-M-MSG: 
From: Andre Przywara <andre.przywara@amd.com>
To: <hpa@zytor.com>, <tglx@linutronix.de>, <mingo@elte.hu>
CC: <linux-kernel@vger.kernel.org>, Andre Przywara <andre.przywara@amd.com>
Subject: [PATCH 2/4] x86: Update AMD CPUID feature bits
Date: Fri, 3 Sep 2010 10:03:06 +0200
Message-ID: <1283500988-32409-3-git-send-email-andre.przywara@amd.com>
X-Mailer: git-send-email 1.6.4
In-Reply-To: <1283500988-32409-1-git-send-email-andre.przywara@amd.com>
References: <1283500988-32409-1-git-send-email-andre.przywara@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

AMD's public CPUID specification has been updated and some bits have
got names. Add them to properly describe new CPU features.

Signed-off-by: Andre Przywara <andre.przywara@amd.com>
---
 arch/x86/include/asm/cpufeature.h |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
index c9c73d8..341835d 100644
--- a/arch/x86/include/asm/cpufeature.h
+++ b/arch/x86/include/asm/cpufeature.h
@@ -155,7 +155,11 @@
 #define X86_FEATURE_XOP		(6*32+11) /* extended AVX instructions */
 #define X86_FEATURE_SKINIT	(6*32+12) /* SKINIT/STGI instructions */
 #define X86_FEATURE_WDT		(6*32+13) /* Watchdog timer */
+#define X86_FEATURE_LWP		(6*32+15) /* Light Weight Profiling */
+#define X86_FEATURE_FMA4	(6*32+16) /* 4 operands MAC instructions */
 #define X86_FEATURE_NODEID_MSR	(6*32+19) /* NodeId MSR */
+#define X86_FEATURE_TBM		(6*32+21) /* trailing bit manipulations */
+#define X86_FEATURE_TOPOEXT	(6*32+22) /* topology extensions CPUID leafs */
 
 /*
  * Auxiliary flags: Linux defined - For features scattered in various
-- 
1.6.4


