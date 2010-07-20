Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761034Ab0GTAw2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jul 2010 20:52:28 -0400
Received: from hera.kernel.org ([140.211.167.34]:38757 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760967Ab0GTAw0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jul 2010 20:52:26 -0400
Date: Tue, 20 Jul 2010 00:52:04 GMT
From: tip-bot for Suresh Siddha <suresh.b.siddha@intel.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        suresh.b.siddha@intel.com, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        suresh.b.siddha@intel.com, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <20100719230205.523204988@sbs-t61.sc.intel.com>
References: <20100719230205.523204988@sbs-t61.sc.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/cpu] x86, cpu: Add xsaveopt cpufeature
Message-ID: <tip-40e1d7a4ffee5cb17f5c36f4c3c4a011ab103ebe@git.kernel.org>
Git-Commit-ID: 40e1d7a4ffee5cb17f5c36f4c3c4a011ab103ebe
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 20 Jul 2010 00:52:05 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  40e1d7a4ffee5cb17f5c36f4c3c4a011ab103ebe
Gitweb:     http://git.kernel.org/tip/40e1d7a4ffee5cb17f5c36f4c3c4a011ab103ebe
Author:     Suresh Siddha <suresh.b.siddha@intel.com>
AuthorDate: Mon, 19 Jul 2010 16:05:51 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Mon, 19 Jul 2010 16:48:06 -0700

x86, cpu: Add xsaveopt cpufeature

Add cpu feature bit support for the XSAVEOPT instruction.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
LKML-Reference: <20100719230205.523204988@sbs-t61.sc.intel.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/include/asm/cpufeature.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
index 3ec9275..d5ea3e3 100644
--- a/arch/x86/include/asm/cpufeature.h
+++ b/arch/x86/include/asm/cpufeature.h
@@ -165,6 +165,7 @@
 #define X86_FEATURE_ARAT	(7*32+ 1) /* Always Running APIC Timer */
 #define X86_FEATURE_CPB		(7*32+ 2) /* AMD Core Performance Boost */
 #define X86_FEATURE_EPB		(7*32+ 3) /* IA32_ENERGY_PERF_BIAS support */
+#define X86_FEATURE_XSAVEOPT	(7*32+4) /* "xsaveopt" Optimized Xsave */
 
 /* Virtualization flags: Linux defined, word 8 */
 #define X86_FEATURE_TPR_SHADOW  (8*32+ 0) /* Intel TPR Shadow */
