Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933346Ab1JZPXX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Oct 2011 11:23:23 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:43626 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933026Ab1JZPXW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Oct 2011 11:23:22 -0400
Date: Wed, 26 Oct 2011 17:21:49 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/cpufeature change for v3.2
Message-ID: <20111026152148.GA30255@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-cpufeature-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-cpufeature-for-linus

 Thanks,

	Ingo

------------------>
Arun Thomas (1):
      x86, cpu: Add cpufeature flag for PCIDs


 arch/x86/include/asm/cpufeature.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
index 4258aac..f24ed51 100644
--- a/arch/x86/include/asm/cpufeature.h
+++ b/arch/x86/include/asm/cpufeature.h
@@ -114,6 +114,7 @@
 #define X86_FEATURE_CX16	(4*32+13) /* CMPXCHG16B */
 #define X86_FEATURE_XTPR	(4*32+14) /* Send Task Priority Messages */
 #define X86_FEATURE_PDCM	(4*32+15) /* Performance Capabilities */
+#define X86_FEATURE_PCID	(4*32+17) /* Process Context Identifiers */
 #define X86_FEATURE_DCA		(4*32+18) /* Direct Cache Access */
 #define X86_FEATURE_XMM4_1	(4*32+19) /* "sse4_1" SSE-4.1 */
 #define X86_FEATURE_XMM4_2	(4*32+20) /* "sse4_2" SSE-4.2 */
