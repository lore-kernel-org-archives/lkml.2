Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755977Ab0IHV2c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 17:28:32 -0400
Received: from hera.kernel.org ([140.211.167.34]:54339 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755694Ab0IHV21 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 17:28:27 -0400
Date: Wed, 8 Sep 2010 21:28:08 GMT
From: tip-bot for Andre Przywara <andre.przywara@amd.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        andre.przywara@amd.com, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        andre.przywara@amd.com, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1283778860-26843-3-git-send-email-andre.przywara@amd.com>
References: <1283778860-26843-3-git-send-email-andre.przywara@amd.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/cpu] x86, cpu: Update AMD CPUID feature bits
Message-ID: <tip-33ed82fb6c5f032151f7e9f1ac7b667f78f426b8@git.kernel.org>
Git-Commit-ID: 33ed82fb6c5f032151f7e9f1ac7b667f78f426b8
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 08 Sep 2010 21:28:08 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  33ed82fb6c5f032151f7e9f1ac7b667f78f426b8
Gitweb:     http://git.kernel.org/tip/33ed82fb6c5f032151f7e9f1ac7b667f78f426b8
Author:     Andre Przywara <andre.przywara@amd.com>
AuthorDate: Mon, 6 Sep 2010 15:14:18 +0200
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Wed, 8 Sep 2010 13:34:15 -0700

x86, cpu: Update AMD CPUID feature bits

AMD's public CPUID specification has been updated and some bits have
got names. Add them to properly describe new CPU features.

Signed-off-by: Andre Przywara <andre.przywara@amd.com>
LKML-Reference: <1283778860-26843-3-git-send-email-andre.przywara@amd.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/include/asm/cpufeature.h |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
index c9c73d8..341835df 100644
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
