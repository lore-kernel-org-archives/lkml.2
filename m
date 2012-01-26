Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752156Ab2AZNlb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 08:41:31 -0500
Received: from terminus.zytor.com ([198.137.202.10]:36120 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751163Ab2AZNla (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 08:41:30 -0500
Date: Thu, 26 Jan 2012 05:41:05 -0800
From: tip-bot for Andreas Herrmann <andreas.herrmann3@amd.com>
Message-ID: <tip-652847aa449cfe364d40018849223f57f31a38e2@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        andreas.herrmann3@amd.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        andreas.herrmann3@amd.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20120120163823.GC24508@alberich.amd.com>
References: <20120120163823.GC24508@alberich.amd.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86/amd:
  Add missing feature flag for fam15h models 10h-1fh processors
Git-Commit-ID: 652847aa449cfe364d40018849223f57f31a38e2
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 26 Jan 2012 05:41:11 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  652847aa449cfe364d40018849223f57f31a38e2
Gitweb:     http://git.kernel.org/tip/652847aa449cfe364d40018849223f57f31a38e2
Author:     Andreas Herrmann <andreas.herrmann3@amd.com>
AuthorDate: Fri, 20 Jan 2012 17:38:23 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 26 Jan 2012 12:06:38 +0100

x86/amd: Add missing feature flag for fam15h models 10h-1fh processors

That is the last one missing for those CPUs.

Others were recently added with commits

 fb215366b3c7320ac25dca766a0152df16534932
 (KVM: expose latest Intel cpu new features (BMI1/BMI2/FMA/AVX2) to guest)

and

 commit 969df4b82904a30fef19a67398a0c854d223ea67
 (x86: Report cpb and eff_freq_ro flags correctly)

Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
Link: http://lkml.kernel.org/r/20120120163823.GC24508@alberich.amd.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
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
