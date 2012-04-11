Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760517Ab2DKPMr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 11:12:47 -0400
Received: from ch1ehsobe005.messaging.microsoft.com ([216.32.181.185]:54003
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755534Ab2DKPMp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 11:12:45 -0400
X-SpamScore: -5
X-BigFish: VPS-5(zz1135Mzz1202hzz8275bhz2dh668h839h93fhd25h)
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0M2BM91-02-0D3-02
X-M-MSG: 
Date: Wed, 11 Apr 2012 17:12:38 +0200
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>
CC: <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86, amd: Remove broken links from comment and kernel message
Message-ID: <20120411151238.GA4794@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
---
 arch/x86/kernel/cpu/amd.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index 0a44b90..1248f9c 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -26,7 +26,8 @@
  *	contact AMD for precise details and a CPU swap.
  *
  *	See	http://www.multimania.com/poulot/k6bug.html
- *		http://www.amd.com/K6/k6docs/revgd.html
+ *	and	section 2.6.2 of "AMD-K6 Processor Revision Guide - Model 6"
+ *		(Publication # 21266  Issue Date: August 1998)
  *
  *	The following test is erm.. interesting. AMD neglected to up
  *	the chip setting when fixing the bug but they also tweaked some
@@ -94,7 +95,6 @@ static void __cpuinit init_amd_k6(struct cpuinfo_x86 *c)
 				"system stability may be impaired when more than 32 MB are used.\n");
 		else
 			printk(KERN_CONT "probably OK (after B9730xxxx).\n");
-		printk(KERN_INFO "Please see http://membres.lycos.fr/poulot/k6bug.html\n");
 	}
 
 	/* K6 with old style WHCR */
-- 
1.7.8.5



