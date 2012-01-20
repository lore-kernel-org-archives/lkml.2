Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754461Ab2ATQig (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jan 2012 11:38:36 -0500
Received: from ch1ehsobe001.messaging.microsoft.com ([216.32.181.181]:7924
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753855Ab2ATQie (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jan 2012 11:38:34 -0500
X-SpamScore: -4
X-BigFish: VPS-4(zz4015Lzz1202hzz8275bhz2dhc1bhc31hc1ah668h839h944h)
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LY3VK3-01-JMS-02
X-M-MSG: 
Date: Fri, 20 Jan 2012 17:38:23 +0100
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>
CC: <linux-kernel@vger.kernel.org>
Subject: [PATCH resend] x86, amd: Add missing feature flag for fam15h models
 10h-1fh processors
Message-ID: <20120120163823.GC24508@alberich.amd.com>
References: <20120105182859.GG14947@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20120105182859.GG14947@alberich.amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


That is the last one missing for those CPUs.

Others were recently added with commits

 fb215366b3c7320ac25dca766a0152df16534932
 (KVM: expose latest Intel cpu new features (BMI1/BMI2/FMA/AVX2) to guest)

and

 commit 969df4b82904a30fef19a67398a0c854d223ea67
 (x86: Report cpb and eff_freq_ro flags correctly)

Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
---

Please apply.


Thanks,

Andreas


 arch/x86/include/asm/cpufeature.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
index 17c5d4b..8d67d42 100644
--- a/arch/x86/include/asm/cpufeature.h
+++ b/arch/x86/include/asm/cpufeature.h
@@ -159,6 +159,7 @@
 #define X86_FEATURE_WDT		(6*32+13) /* Watchdog timer */
 #define X86_FEATURE_LWP		(6*32+15) /* Light Weight Profiling */
 #define X86_FEATURE_FMA4	(6*32+16) /* 4 operands MAC instructions */
+#define X86_FEATURE_TCE		(6*32+17) /* translation cache extension */
 #define X86_FEATURE_NODEID_MSR	(6*32+19) /* NodeId MSR */
 #define X86_FEATURE_TBM		(6*32+21) /* trailing bit manipulations */
 #define X86_FEATURE_TOPOEXT	(6*32+22) /* topology extensions CPUID leafs */
-- 
1.7.8.3



