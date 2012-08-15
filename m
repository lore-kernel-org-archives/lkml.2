Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932417Ab2HOUD0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 16:03:26 -0400
Received: from mail.windriver.com ([147.11.1.11]:37308 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932109Ab2HOTwe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 15:52:34 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Kees Cook <kees.cook@canonical.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 143/165] x86, cpufeature: Update CPU feature RDRND to RDRAND
Date: Wed, 15 Aug 2012 15:48:07 -0400
Message-ID: <1345060109-9187-144-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.12.rc2
In-Reply-To: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com>
References: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kees Cook <kees.cook@canonical.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 7ccafc5f75c87853f3c49845d5a884f2376e03ce upstream.

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
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 arch/x86/include/asm/cpufeature.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
index 0cfa2fb..d79434e 100644
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
-- 
1.7.12.rc2

