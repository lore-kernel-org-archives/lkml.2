Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752117Ab1GWIvF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jul 2011 04:51:05 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:56323 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752048Ab1GWIu7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jul 2011 04:50:59 -0400
Date: Sat, 23 Jul 2011 10:50:13 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/debug update for v3.1
Message-ID: <20110723085013.GA14835@elte.hu>
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

Please pull the latest core-debug-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git core-debug-for-linus

 Thanks,

	Ingo

------------------>
Josh Triplett (1):
      debug: Make CONFIG_EXPERT select CONFIG_DEBUG_KERNEL to unhide debug options


 init/Kconfig |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/init/Kconfig b/init/Kconfig
index ebafac4..14370d3 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -909,6 +909,8 @@ config ANON_INODES
 
 menuconfig EXPERT
 	bool "Configure standard kernel features (expert users)"
+	# Unhide debug options, to make the on-by-default options visible
+	select DEBUG_KERNEL
 	help
 	  This option allows certain base kernel options and settings
           to be disabled or tweaked. This is for specialized
