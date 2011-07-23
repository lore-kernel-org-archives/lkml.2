Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752269Ab1GWJQG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jul 2011 05:16:06 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:45881 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752048Ab1GWJP4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jul 2011 05:15:56 -0400
Date: Sat, 23 Jul 2011 11:15:09 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/detect-hyper change for v3.1
Message-ID: <20110723091509.GA18000@elte.hu>
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

Please pull the latest x86-detect-hyper-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-detect-hyper-for-linus

 Thanks,

	Ingo

------------------>
Anupam Chanda (1):
      x86, hyper: Change hypervisor detection order


 arch/x86/kernel/cpu/hypervisor.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/hypervisor.c b/arch/x86/kernel/cpu/hypervisor.c
index 8095f86..755f64f 100644
--- a/arch/x86/kernel/cpu/hypervisor.c
+++ b/arch/x86/kernel/cpu/hypervisor.c
@@ -32,11 +32,11 @@
  */
 static const __initconst struct hypervisor_x86 * const hypervisors[] =
 {
-	&x86_hyper_vmware,
-	&x86_hyper_ms_hyperv,
 #ifdef CONFIG_XEN_PVHVM
 	&x86_hyper_xen_hvm,
 #endif
+	&x86_hyper_vmware,
+	&x86_hyper_ms_hyperv,
 };
 
 const struct hypervisor_x86 *x86_hyper;
