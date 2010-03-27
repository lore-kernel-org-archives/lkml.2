Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752778Ab0C0C2F (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Mar 2010 22:28:05 -0400
Received: from mail.perches.com ([173.55.12.10]:1125 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752642Ab0C0C2A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Mar 2010 22:28:00 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Russell King <linux@arm.linux.org.uk>,
       linux-arm-kernel@lists.infradead.org
Subject: [PATCH 1/9] arch/arm: Fix continuation lines
Date: Fri, 26 Mar 2010 19:27:50 -0700
Message-Id: <0c97f736400ec243e71ba794ae7046a61d2449c1.1269655208.git.joe@perches.com>
X-Mailer: git-send-email 1.7.0.14.g7e948
In-Reply-To: <cover.1269655208.git.joe@perches.com>
References: <cover.1269655208.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 arch/arm/mach-s5pv210/clock.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-s5pv210/clock.c b/arch/arm/mach-s5pv210/clock.c
index ccccae2..a989c5e 100644
--- a/arch/arm/mach-s5pv210/clock.c
+++ b/arch/arm/mach-s5pv210/clock.c
@@ -394,8 +394,8 @@ void __init_or_cpufreq s5pv210_setup_clocks(void)
 	pclk83 = hclk166 / GET_DIV(clkdiv0, S5P_CLKDIV0_PCLK83);
 	pclk66 = hclk133 / GET_DIV(clkdiv0, S5P_CLKDIV0_PCLK66);
 
-	printk(KERN_INFO "S5PV210: ARMCLK=%ld, HCLKM=%ld, HCLKD=%ld, \
-			HCLKP=%ld, PCLKM=%ld, PCLKD=%ld, PCLKP=%ld\n",
+	printk(KERN_INFO "S5PV210: ARMCLK=%ld, HCLKM=%ld, HCLKD=%ld, "
+			"HCLKP=%ld, PCLKM=%ld, PCLKD=%ld, PCLKP=%ld\n",
 	       armclk, hclk200, hclk166, hclk133, pclk100, pclk83, pclk66);
 
 	clk_fout_apll.rate = apll;
-- 
1.7.0.14.g7e948

