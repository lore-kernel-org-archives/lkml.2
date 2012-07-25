Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933300Ab2GYOsP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 10:48:15 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:51011 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933180Ab2GYOsN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 10:48:13 -0400
Date: Wed, 25 Jul 2012 16:48:08 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/cpufeature change for v3.6
Message-ID: <20120725144808.GA31637@gmail.com>
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

   HEAD: 30d5c4546a7dae29a1aa76abdb69a78bb00136be x86, cpufeature: Add the RDSEED and ADX features

A single commit that adds new CPU feature names.

 Thanks,

	Ingo

------------------>
H. Peter Anvin (1):
      x86, cpufeature: Add the RDSEED and ADX features


 arch/x86/include/asm/cpufeature.h |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
index f91e80f..6b7ee5f 100644
--- a/arch/x86/include/asm/cpufeature.h
+++ b/arch/x86/include/asm/cpufeature.h
@@ -207,6 +207,8 @@
 #define X86_FEATURE_ERMS	(9*32+ 9) /* Enhanced REP MOVSB/STOSB */
 #define X86_FEATURE_INVPCID	(9*32+10) /* Invalidate Processor Context ID */
 #define X86_FEATURE_RTM		(9*32+11) /* Restricted Transactional Memory */
+#define X86_FEATURE_RDSEED	(9*32+18) /* The RDSEED instruction */
+#define X86_FEATURE_ADX		(9*32+19) /* The ADCX and ADOX instructions */
 
 #if defined(__KERNEL__) && !defined(__ASSEMBLY__)
 
