Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755230Ab2LSSTZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 13:19:25 -0500
Received: from co1ehsobe001.messaging.microsoft.com ([216.32.180.184]:10962
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751805Ab2LSSTG (ORCPT
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
Subject: [PATCH v2 5/7] arm: zynq: timer: Remove redundant #includes
Date: Wed, 19 Dec 2012 10:18:40 -0800
X-Mailer: git-send-email 1.8.0.2
In-Reply-To: <ab760e55-61c2-46b0-b899-1935c213536e@CO1EHSMHS026.ehs.local>
References: <ab760e55-61c2-46b0-b899-1935c213536e@CO1EHSMHS026.ehs.local>
X-RCIS-Action: ALLOW
MIME-Version: 1.0
Content-Type: text/plain
Message-ID: <21207fff-dd51-4099-88f8-eea754e3d19c@CO1EHSMHS021.ehs.local>
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some #includes are implicitly included through others, some are
just not needed.

Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
Reviewed-by: Josh Cartwright <josh.cartwright@ni.com>
---
 arch/arm/mach-zynq/timer.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/arch/arm/mach-zynq/timer.c b/arch/arm/mach-zynq/timer.c
index 4b81ae1..2b23d0f 100644
--- a/arch/arm/mach-zynq/timer.c
+++ b/arch/arm/mach-zynq/timer.c
@@ -15,20 +15,12 @@
  * GNU General Public License for more details.
  */
 
-#include <linux/kernel.h>
-#include <linux/init.h>
 #include <linux/interrupt.h>
-#include <linux/irq.h>
-#include <linux/types.h>
-#include <linux/clocksource.h>
 #include <linux/clockchips.h>
-#include <linux/io.h>
-#include <linux/of.h>
 #include <linux/of_address.h>
 #include <linux/of_irq.h>
 #include <linux/slab.h>
 #include <linux/clk-provider.h>
-
 #include "common.h"
 
 /*
-- 
1.8.0.2


