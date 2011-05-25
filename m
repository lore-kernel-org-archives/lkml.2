Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751923Ab1EYE63 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 00:58:29 -0400
Received: from hera.kernel.org ([140.211.167.34]:57855 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751454Ab1EYE61 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 00:58:27 -0400
Date: Wed, 25 May 2011 04:58:17 GMT
From: tip-bot for Kees Cook <kees.cook@canonical.com>
Message-ID: <tip-7ccafc5f75c87853f3c49845d5a884f2376e03ce@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        fenghua.yu@intel.com, kees.cook@canonical.com, tglx@linutronix.de,
        hpa@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        kees.cook@canonical.com, fenghua.yu@intel.com, tglx@linutronix.de,
        hpa@linux.intel.com
In-Reply-To: <20110524232926.GA27728@outflux.net>
References: <20110524232926.GA27728@outflux.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86, cpufeature: Update CPU feature RDRND to RDRAND
Git-Commit-ID: 7ccafc5f75c87853f3c49845d5a884f2376e03ce
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 25 May 2011 04:58:18 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7ccafc5f75c87853f3c49845d5a884f2376e03ce
Gitweb:     http://git.kernel.org/tip/7ccafc5f75c87853f3c49845d5a884f2376e03ce
Author:     Kees Cook <kees.cook@canonical.com>
AuthorDate: Tue, 24 May 2011 16:29:26 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Tue, 24 May 2011 16:37:27 -0700

x86, cpufeature: Update CPU feature RDRND to RDRAND

The Intel manual changed the name of the CPUID bit to match the
instruction name. We should follow suit for sanity's sake. (See Intel SDM
Volume 2, Table 3-20 "Feature Information Returned in the ECX Register".)

[ hpa: we can only do this at this time because there are currently no CPUs
  with this feature on the market, hence this is pre-hardware enabling.
  However, Cc:'ing stable so that stable can present a consistent ABI. ]

Signed-off-by: Kees Cook <kees.cook@canonical.com>
Link: http://lkml.kernel.org/r/20110524232926.GA27728@outflux.net
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Cc: <stable@kernel.org> v2.6.36-39
---
 arch/x86/include/asm/cpufeature.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
index 5dc6acc..71cc380 100644
--- a/arch/x86/include/asm/cpufeature.h
+++ b/arch/x86/include/asm/cpufeature.h
@@ -125,7 +125,7 @@
 #define X86_FEATURE_OSXSAVE	(4*32+27) /* "" XSAVE enabled in the OS */
 #define X86_FEATURE_AVX		(4*32+28) /* Advanced Vector Extensions */
 #define X86_FEATURE_F16C	(4*32+29) /* 16-bit fp conversions */
-#define X86_FEATURE_RDRND	(4*32+30) /* The RDRAND instruction */
+#define X86_FEATURE_RDRAND	(4*32+30) /* The RDRAND instruction */
 #define X86_FEATURE_HYPERVISOR	(4*32+31) /* Running on a hypervisor */
 
 /* VIA/Cyrix/Centaur-defined CPU features, CPUID level 0xC0000001, word 5 */
