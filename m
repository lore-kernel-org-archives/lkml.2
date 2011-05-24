Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757539Ab1EXX3k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 19:29:40 -0400
Received: from smtp.outflux.net ([198.145.64.163]:49543 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757030Ab1EXX3j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 19:29:39 -0400
Date: Tue, 24 May 2011 16:29:26 -0700
From: Kees Cook <kees.cook@canonical.com>
To: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Fenghua Yu <fenghua.yu@intel.com>,
        Andre Przywara <andre.przywara@amd.com>,
        Len Brown <len.brown@intel.com>, Tejun Heo <tj@kernel.org>
Subject: [PATCH] x86: update cpu feature RDRND to RDRAND
Message-ID: <20110524232926.GA27728@outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: Canonical
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Intel manual changed the name of the CPUID bit to match the
instruction name. We should follow suit for sanity's sake. (See Intel SDM
Volume 2, Table 3-20 "Feature Information Returned in the ECX Register".)

Signed-off-by: Kees Cook <kees.cook@canonical.com>
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
-- 
1.7.4.1

-- 
Kees Cook
Ubuntu Security Team
