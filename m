Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932110Ab2LSSTz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 13:19:55 -0500
Received: from db3ehsobe006.messaging.microsoft.com ([213.199.154.144]:42210
	"EHLO db3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750859Ab2LSSTJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 13:19:09 -0500
X-Forefront-Antispam-Report: CIP:149.199.60.83;KIP:(null);UIP:(null);IPV:NLI;H:xsj-gw1;RD:unknown-60-83.xilinx.com;EFVD:NLI
X-SpamScore: 1
X-BigFish: VPS1(zzzz1de0h1202h1e76h1d1ah1d2ahzz8275bhz2fh95h668h839hd24hf0ah119dh1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h14ddh1504h1537h162dh1631h1758h906i1155h)
From: Soren Brinkmann <soren.brinkmann@xilinx.com>
To: Michal Simek <michal.simek@xilinx.com>, <monstr@monstr.eu>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        John Linn <john.linn@xilinx.com>, Arnd Bergmann <arnd@arndb.de>,
        <git@xilinx.com>, <nbowler@elliptictech.com>, <josh.cartwright@ni.com>,
        Soren Brinkmann <soren.brinkmann@xilinx.com>
Subject: [PATCH v2 6/7] arm: zynq: timer: Fix comment style
Date: Wed, 19 Dec 2012 10:18:41 -0800
X-Mailer: git-send-email 1.8.0.2
In-Reply-To: <ab760e55-61c2-46b0-b899-1935c213536e@CO1EHSMHS026.ehs.local>
References: <ab760e55-61c2-46b0-b899-1935c213536e@CO1EHSMHS026.ehs.local>
X-RCIS-Action: ALLOW
MIME-Version: 1.0
Content-Type: text/plain
Message-ID: <07f27d3f-d6cd-44e6-95fe-739f9583a3bd@DB3EHSMHS012.ehs.local>
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixing multi line comment style at two locations.

Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
Reviewed-by: Josh Cartwright <josh.cartwright@ni.com>
---
 arch/arm/mach-zynq/timer.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/arch/arm/mach-zynq/timer.c b/arch/arm/mach-zynq/timer.c
index 2b23d0f..7b2e047 100644
--- a/arch/arm/mach-zynq/timer.c
+++ b/arch/arm/mach-zynq/timer.c
@@ -36,7 +36,8 @@
 
 #define XTTCPS_CNT_CNTRL_DISABLE_MASK	0x1
 
-/* Setup the timers to use pre-scaling, using a fixed value for now that will
+/*
+ * Setup the timers to use pre-scaling, using a fixed value for now that will
  * work across most input frequency, but it may need to be more dynamic
  */
 #define PRESCALE_EXPONENT	11	/* 2 ^ PRESCALE_EXPONENT = PRESCALE */
@@ -89,8 +90,10 @@ static void xttcps_set_interval(struct xttcps_timer *timer,
 
 	__raw_writel(cycles, timer->base_addr + XTTCPS_INTR_VAL_OFFSET);
 
-	/* Reset the counter (0x10) so that it starts from 0, one-shot
-	   mode makes this needed for timing to be right. */
+	/*
+	 * Reset the counter (0x10) so that it starts from 0, one-shot
+	 * mode makes this needed for timing to be right.
+	 */
 	ctrl_reg |= CNT_CNTRL_RESET;
 	ctrl_reg &= ~XTTCPS_CNT_CNTRL_DISABLE_MASK;
 	__raw_writel(ctrl_reg, timer->base_addr + XTTCPS_CNT_CNTRL_OFFSET);
-- 
1.8.0.2


