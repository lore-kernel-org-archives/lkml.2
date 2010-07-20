Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967442Ab0GTAwl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jul 2010 20:52:41 -0400
Received: from hera.kernel.org ([140.211.167.34]:38765 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967352Ab0GTAwj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jul 2010 20:52:39 -0400
Date: Tue, 20 Jul 2010 00:52:23 GMT
From: tip-bot for Suresh Siddha <suresh.b.siddha@intel.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        suresh.b.siddha@intel.com, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        suresh.b.siddha@intel.com, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <20100719230205.604014179@sbs-t61.sc.intel.com>
References: <20100719230205.604014179@sbs-t61.sc.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/cpu] x86, cpu: Enumerate xsaveopt
Message-ID: <tip-5734f62b6601d88fd8ec720cb56b93fd3a030557@git.kernel.org>
Git-Commit-ID: 5734f62b6601d88fd8ec720cb56b93fd3a030557
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 20 Jul 2010 00:52:23 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5734f62b6601d88fd8ec720cb56b93fd3a030557
Gitweb:     http://git.kernel.org/tip/5734f62b6601d88fd8ec720cb56b93fd3a030557
Author:     Suresh Siddha <suresh.b.siddha@intel.com>
AuthorDate: Mon, 19 Jul 2010 16:05:52 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Mon, 19 Jul 2010 16:50:40 -0700

x86, cpu: Enumerate xsaveopt

Enumerate the xsaveopt feature.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
LKML-Reference: <20100719230205.604014179@sbs-t61.sc.intel.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/kernel/cpu/addon_cpuid_features.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/cpu/addon_cpuid_features.c b/arch/x86/kernel/cpu/addon_cpuid_features.c
index 03cf24a..41eebcd 100644
--- a/arch/x86/kernel/cpu/addon_cpuid_features.c
+++ b/arch/x86/kernel/cpu/addon_cpuid_features.c
@@ -35,6 +35,7 @@ void __cpuinit init_scattered_cpuid_features(struct cpuinfo_x86 *c)
 		{ X86_FEATURE_ARAT,		CR_EAX, 2, 0x00000006, 0 },
 		{ X86_FEATURE_APERFMPERF,	CR_ECX, 0, 0x00000006, 0 },
 		{ X86_FEATURE_EPB,		CR_ECX, 3, 0x00000006, 0 },
+		{ X86_FEATURE_XSAVEOPT,		CR_EAX,	0, 0x0000000d, 1 },
 		{ X86_FEATURE_CPB,		CR_EDX, 9, 0x80000007, 0 },
 		{ X86_FEATURE_NPT,		CR_EDX, 0, 0x8000000a, 0 },
 		{ X86_FEATURE_LBRV,		CR_EDX, 1, 0x8000000a, 0 },
