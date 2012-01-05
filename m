Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757564Ab2AEOpW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 09:45:22 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:44708 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755425Ab2AEOpU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 09:45:20 -0500
Date: Thu, 5 Jan 2012 15:43:13 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/cpu change for v3.3
Message-ID: <20120105144313.GA5342@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=AWL,BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
	0.0 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-cpu-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-cpu-for-linus

 Thanks,

	Ingo

------------------>
Timo Teräs (1):
      x86, centaur: Enable cx8 for VIA Eden too


 arch/x86/kernel/cpu/centaur.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/cpu/centaur.c b/arch/x86/kernel/cpu/centaur.c
index e58d978..159103c 100644
--- a/arch/x86/kernel/cpu/centaur.c
+++ b/arch/x86/kernel/cpu/centaur.c
@@ -278,7 +278,7 @@ static void __cpuinit init_c3(struct cpuinfo_x86 *c)
 	}
 #ifdef CONFIG_X86_32
 	/* Cyrix III family needs CX8 & PGE explicitly enabled. */
-	if (c->x86_model >= 6 && c->x86_model <= 9) {
+	if (c->x86_model >= 6 && c->x86_model <= 13) {
 		rdmsr(MSR_VIA_FCR, lo, hi);
 		lo |= (1<<1 | 1<<7);
 		wrmsr(MSR_VIA_FCR, lo, hi);
