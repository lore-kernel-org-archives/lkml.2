Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758127Ab0GTCHK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jul 2010 22:07:10 -0400
Received: from hera.kernel.org ([140.211.167.34]:43958 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758084Ab0GTCHI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jul 2010 22:07:08 -0400
Date: Tue, 20 Jul 2010 02:06:40 GMT
From: "tip-bot for H. Peter Anvin" <hpa@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        suresh.b.siddha@intel.com, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        suresh.b.siddha@intel.com, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <tip-*@git.kernel.org>
References: <tip-*@git.kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/cpu] x86, cpu: Clean up formatting in cpufeature.h, remove override
Message-ID: <tip-278bc5f6abd69dd868746dbd642266ac09a9c9c6@git.kernel.org>
Git-Commit-ID: 278bc5f6abd69dd868746dbd642266ac09a9c9c6
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 20 Jul 2010 02:06:41 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  278bc5f6abd69dd868746dbd642266ac09a9c9c6
Gitweb:     http://git.kernel.org/tip/278bc5f6abd69dd868746dbd642266ac09a9c9c6
Author:     H. Peter Anvin <hpa@linux.intel.com>
AuthorDate: Mon, 19 Jul 2010 18:53:51 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Mon, 19 Jul 2010 19:02:35 -0700

x86, cpu: Clean up formatting in cpufeature.h, remove override

Clean up the formatting in cpufeature.h, and remove an unnecessary
name override.

Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>
LKML-Reference: <tip-*@git.kernel.org>
---
 arch/x86/include/asm/cpufeature.h |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
index d5ea3e3..4be50dd 100644
--- a/arch/x86/include/asm/cpufeature.h
+++ b/arch/x86/include/asm/cpufeature.h
@@ -165,7 +165,7 @@
 #define X86_FEATURE_ARAT	(7*32+ 1) /* Always Running APIC Timer */
 #define X86_FEATURE_CPB		(7*32+ 2) /* AMD Core Performance Boost */
 #define X86_FEATURE_EPB		(7*32+ 3) /* IA32_ENERGY_PERF_BIAS support */
-#define X86_FEATURE_XSAVEOPT	(7*32+4) /* "xsaveopt" Optimized Xsave */
+#define X86_FEATURE_XSAVEOPT	(7*32+ 4) /* Optimized Xsave */
 
 /* Virtualization flags: Linux defined, word 8 */
 #define X86_FEATURE_TPR_SHADOW  (8*32+ 0) /* Intel TPR Shadow */
@@ -173,13 +173,13 @@
 #define X86_FEATURE_FLEXPRIORITY (8*32+ 2) /* Intel FlexPriority */
 #define X86_FEATURE_EPT         (8*32+ 3) /* Intel Extended Page Table */
 #define X86_FEATURE_VPID        (8*32+ 4) /* Intel Virtual Processor ID */
-#define X86_FEATURE_NPT		(8*32+5)  /* AMD Nested Page Table support */
-#define X86_FEATURE_LBRV	(8*32+6)  /* AMD LBR Virtualization support */
-#define X86_FEATURE_SVML	(8*32+7)  /* "svm_lock" AMD SVM locking MSR */
-#define X86_FEATURE_NRIPS	(8*32+8)  /* "nrip_save" AMD SVM next_rip save */
+#define X86_FEATURE_NPT		(8*32+ 5) /* AMD Nested Page Table support */
+#define X86_FEATURE_LBRV	(8*32+ 6) /* AMD LBR Virtualization support */
+#define X86_FEATURE_SVML	(8*32+ 7) /* "svm_lock" AMD SVM locking MSR */
+#define X86_FEATURE_NRIPS	(8*32+ 8) /* "nrip_save" AMD SVM next_rip save */
 
 /* Intel-defined CPU features, CPUID level 0x00000007:0 (ebx), word 9 */
-#define X86_FEATURE_FSGSBASE	(9*32+0)  /* {RD/WR}{FS/GS}BASE instructions*/
+#define X86_FEATURE_FSGSBASE	(9*32+ 0) /* {RD/WR}{FS/GS}BASE instructions*/
 
 #if defined(__KERNEL__) && !defined(__ASSEMBLY__)
 
