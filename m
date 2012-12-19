Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755051Ab2LSSTS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 13:19:18 -0500
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:39914
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751114Ab2LSSTG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 13:19:06 -0500
X-Forefront-Antispam-Report: CIP:149.199.60.83;KIP:(null);UIP:(null);IPV:NLI;H:xsj-gw1;RD:unknown-60-83.xilinx.com;EFVD:NLI
X-SpamScore: 1
X-BigFish: VPS1(zzzz1de0h1202h1e76h1d1ah1d2ahzz8275bhz2fh95h668h839hd24hf0ah119dh1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h14ddh1504h1537h162dh1631h1758h906i1155h)
From: Soren Brinkmann <soren.brinkmann@xilinx.com>
To: Michal Simek <michal.simek@xilinx.com>, <monstr@monstr.eu>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        John Linn <john.linn@xilinx.com>, Arnd Bergmann <arnd@arndb.de>,
        <git@xilinx.com>, <nbowler@elliptictech.com>, <josh.cartwright@ni.com>,
        Soren Brinkmann <soren.brinkmann@xilinx.com>
Subject: [PATCH v2 4/7] arm: zynq: timer: Align columns
Date: Wed, 19 Dec 2012 10:18:39 -0800
X-Mailer: git-send-email 1.8.0.2
In-Reply-To: <ab760e55-61c2-46b0-b899-1935c213536e@CO1EHSMHS026.ehs.local>
References: <ab760e55-61c2-46b0-b899-1935c213536e@CO1EHSMHS026.ehs.local>
X-RCIS-Action: ALLOW
MIME-Version: 1.0
Content-Type: text/plain
Message-ID: <6707a3e2-3f76-40cb-a752-b37d0c7d2da6@VA3EHSMHS038.ehs.local>
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Aligning the columns in a block of #defines, so that the values
are starting in the same colum on every line.

Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
Reviewed-by: Josh Cartwright <josh.cartwright@ni.com>
---
 arch/arm/mach-zynq/timer.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm/mach-zynq/timer.c b/arch/arm/mach-zynq/timer.c
index 80bf474..4b81ae1 100644
--- a/arch/arm/mach-zynq/timer.c
+++ b/arch/arm/mach-zynq/timer.c
@@ -35,9 +35,9 @@
  * Timer Register Offset Definitions of Timer 1, Increment base address by 4
  * and use same offsets for Timer 2
  */
-#define XTTCPS_CLK_CNTRL_OFFSET	0x00 /* Clock Control Reg, RW */
-#define XTTCPS_CNT_CNTRL_OFFSET	0x0C /* Counter Control Reg, RW */
-#define XTTCPS_COUNT_VAL_OFFSET	0x18 /* Counter Value Reg, RO */
+#define XTTCPS_CLK_CNTRL_OFFSET		0x00 /* Clock Control Reg, RW */
+#define XTTCPS_CNT_CNTRL_OFFSET		0x0C /* Counter Control Reg, RW */
+#define XTTCPS_COUNT_VAL_OFFSET		0x18 /* Counter Value Reg, RO */
 #define XTTCPS_INTR_VAL_OFFSET		0x24 /* Interval Count Reg, RW */
 #define XTTCPS_ISR_OFFSET		0x54 /* Interrupt Status Reg, RO */
 #define XTTCPS_IER_OFFSET		0x60 /* Interrupt Enable Reg, RW */
-- 
1.8.0.2


