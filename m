Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757771Ab2CSQl0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 12:41:26 -0400
Received: from mail-wg0-f66.google.com ([74.125.82.66]:64421 "EHLO
	mail-wg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932291Ab2CSQlY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 12:41:24 -0400
Date: Mon, 19 Mar 2012 17:41:20 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/cpufeature change for v3.4
Message-ID: <20120319164120.GA11153@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-cpufeature-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-cpufeature-for-linus

   HEAD: 513c4ec6e4759aa33c90af0658b82eb4d2027871 x86, cpufeature: Add CPU features from Intel document 319433-012A

 Thanks,

	Ingo

------------------>
H. Peter Anvin (1):
      x86, cpufeature: Add CPU features from Intel document 319433-012A


 arch/x86/include/asm/cpufeature.h |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
index 8d67d42..0d3dcc9 100644
--- a/arch/x86/include/asm/cpufeature.h
+++ b/arch/x86/include/asm/cpufeature.h
@@ -199,10 +199,13 @@
 /* Intel-defined CPU features, CPUID level 0x00000007:0 (ebx), word 9 */
 #define X86_FEATURE_FSGSBASE	(9*32+ 0) /* {RD/WR}{FS/GS}BASE instructions*/
 #define X86_FEATURE_BMI1	(9*32+ 3) /* 1st group bit manipulation extensions */
+#define X86_FEATURE_HLE		(9*32+ 4) /* Hardware Lock Elision */
 #define X86_FEATURE_AVX2	(9*32+ 5) /* AVX2 instructions */
 #define X86_FEATURE_SMEP	(9*32+ 7) /* Supervisor Mode Execution Protection */
 #define X86_FEATURE_BMI2	(9*32+ 8) /* 2nd group bit manipulation extensions */
 #define X86_FEATURE_ERMS	(9*32+ 9) /* Enhanced REP MOVSB/STOSB */
+#define X86_FEATURE_INVPCID	(9*32+10) /* Invalidate Processor Context ID */
+#define X86_FEATURE_RTM		(9*32+11) /* Restricted Transactional Memory */
 
 #if defined(__KERNEL__) && !defined(__ASSEMBLY__)
 
