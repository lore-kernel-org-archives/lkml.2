Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755207Ab2LSASp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 19:18:45 -0500
Received: from [216.32.181.183] ([216.32.181.183]:4350 "EHLO
	ch1outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1755101Ab2LSASl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 19:18:41 -0500
X-Forefront-Antispam-Report: CIP:149.199.60.83;KIP:(null);UIP:(null);IPV:NLI;H:xsj-gw1;RD:unknown-60-83.xilinx.com;EFVD:NLI
X-SpamScore: 1
X-BigFish: VPS1(zzzz1de0h1202h1e76h1d1ah1d2ahzz8275bhz2fh95h668h839hd24hf0ah119dh1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h14ddh1504h1537h162dh1631h1758h906i1155h)
From: Soren Brinkmann <soren.brinkmann@xilinx.com>
To: <linux-kernel@vger.kernel.org>, Michal Simek <michal.simek@xilinx.com>,
        <monstr@monstr.eu>, John Linn <john.linn@xilinx.com>
CC: <git@xilinx.com>, <josh.cartwright@ni.com>,
        Soren Brinkmann <soren.brinkmann@xilinx.com>
Subject: [PATCH 5/7] arm: zynq: timer: Remove redundant #includes
Date: Tue, 18 Dec 2012 16:16:37 -0800
X-Mailer: git-send-email 1.8.0.2
In-Reply-To: <1355876199-23788-1-git-send-email-soren.brinkmann@xilinx.com>
References: <1355876199-23788-1-git-send-email-soren.brinkmann@xilinx.com>
X-RCIS-Action: ALLOW
MIME-Version: 1.0
Content-Type: text/plain
Message-ID: <d1412014-393a-4bdc-b903-307c13e268ea@CH1EHSMHS028.ehs.local>
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some #includes are implicitly included through others, some are
just not needed.

Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
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


