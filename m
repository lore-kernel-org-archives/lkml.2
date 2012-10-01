Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751646Ab2JANpv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 09:45:51 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:32779 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750848Ab2JANpu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 09:45:50 -0400
Date: Mon, 1 Oct 2012 15:45:45 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/cpufeature change for v3.7
Message-ID: <20121001134545.GA23974@gmail.com>
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

   HEAD: 05194cfc547528a01d655262c49da3b1311c4b11 x86, cpufeature: Add feature bit for SMAP

Prepare for SMAP (Supervisor Mode Access Prevention) support on 
x86.

 Thanks,

	Ingo

------------------>
H. Peter Anvin (1):
      x86, cpufeature: Add feature bit for SMAP


 arch/x86/include/asm/cpufeature.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
index 6b7ee5f..633b617 100644
--- a/arch/x86/include/asm/cpufeature.h
+++ b/arch/x86/include/asm/cpufeature.h
@@ -209,6 +209,7 @@
 #define X86_FEATURE_RTM		(9*32+11) /* Restricted Transactional Memory */
 #define X86_FEATURE_RDSEED	(9*32+18) /* The RDSEED instruction */
 #define X86_FEATURE_ADX		(9*32+19) /* The ADCX and ADOX instructions */
+#define X86_FEATURE_SMAP	(9*32+20) /* Supervisor Mode Access Prevention */
 
 #if defined(__KERNEL__) && !defined(__ASSEMBLY__)
 
