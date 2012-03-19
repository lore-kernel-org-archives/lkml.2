Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162006Ab2CSQgP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 12:36:15 -0400
Received: from mail-wg0-f66.google.com ([74.125.82.66]:48570 "EHLO
	mail-wg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755596Ab2CSQgO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 12:36:14 -0400
Date: Mon, 19 Mar 2012 17:36:10 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/cpu change for v3.4
Message-ID: <20120319163610.GA11094@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-cpu-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-cpu-for-linus

   HEAD: 140f190bc3a3b6f200548d204befd998eadd63fd x86: Remove some noise from boot log when starting cpus

 Thanks,

	Ingo

------------------>
Tony Luck (1):
      x86: Remove some noise from boot log when starting cpus


 arch/x86/kernel/smpboot.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 66d250c..6835752 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -740,8 +740,6 @@ do_rest:
 	 * the targeted processor.
 	 */
 
-	printk(KERN_DEBUG "smpboot cpu %d: start_ip = %lx\n", cpu, start_ip);
-
 	atomic_set(&init_deasserted, 0);
 
 	if (get_uv_system_type() != UV_NON_UNIQUE_APIC) {
