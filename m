Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755126Ab2LSAW4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 19:22:56 -0500
Received: from co9ehsobe002.messaging.microsoft.com ([207.46.163.25]:40793
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755018Ab2LSAWx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 19:22:53 -0500
X-Forefront-Antispam-Report: CIP:149.199.60.83;KIP:(null);UIP:(null);IPV:NLI;H:xsj-gw1;RD:unknown-60-83.xilinx.com;EFVD:NLI
X-SpamScore: 1
X-BigFish: VPS1(zzzz1de0h1202h1e76h1d1ah1d2ahzz8275bhz2fh95h668h839hd24hf0ah119dh1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h14ddh1504h1537h162dh1631h1758h906i1155h)
From: Soren Brinkmann <soren.brinkmann@xilinx.com>
To: <linux-kernel@vger.kernel.org>, Michal Simek <michal.simek@xilinx.com>,
        <monstr@monstr.eu>, John Linn <john.linn@xilinx.com>
CC: <git@xilinx.com>, <josh.cartwright@ni.com>,
        Soren Brinkmann <soren.brinkmann@xilinx.com>
Subject: [PATCH 4/7] arm: zynq: timer: Align columns
Date: Tue, 18 Dec 2012 16:16:36 -0800
X-Mailer: git-send-email 1.8.0.2
In-Reply-To: <1355876199-23788-1-git-send-email-soren.brinkmann@xilinx.com>
References: <1355876199-23788-1-git-send-email-soren.brinkmann@xilinx.com>
X-RCIS-Action: ALLOW
MIME-Version: 1.0
Content-Type: text/plain
Message-ID: <c6e8ebf7-360a-4acf-ba10-7840d2def7c9@CO9EHSMHS021.ehs.local>
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Aligning the columns in a block of #defines, so that the values
are starting in the same colum on every line.

Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
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


