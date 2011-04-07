Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755453Ab1DGWIU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 18:08:20 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:45537 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754685Ab1DGWIS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 18:08:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=IHqD+/es+lcRuFScWEsNmHr1adY8xwOqWbM/DTQonT154uqqW/JMz2JuqEtDXWBD+p
         oQGp0/9iJmFt/dTobBpOYMC+mZRpKW/SYhcZYTJA4v8E+cexXHBh5Ni7VElMDG31CVzy
         J2Th+kQtABwDM7MkXReRzPOHH+kn1tK205XVk=
From: Chihau Chau <chihau@gmail.com>
To: davidb@codeaurora.org, dwalker@fifo99.com, bryanh@codeaurora.org,
        linux@arm.linux.org.uk, gregkh@suse.de
Cc: linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Chihau Chau <chihau@gmail.com>
Subject: [PATCH] arm: mach-msm: acpuclock-arm11: Using __func__ instead __FUNCTION__
Date: Thu,  7 Apr 2011 19:06:33 -0300
Message-Id: <1302213993-32737-1-git-send-email-chihau@gmail.com>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changing the __FUNCTION__ variable for the C99 standard __func__

Signed-off-by: Chihau Chau <chihau@gmail.com>
---
 arch/arm/mach-msm/acpuclock-arm11.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-msm/acpuclock-arm11.c b/arch/arm/mach-msm/acpuclock-arm11.c
index d716cf1..18ba209 100644
--- a/arch/arm/mach-msm/acpuclock-arm11.c
+++ b/arch/arm/mach-msm/acpuclock-arm11.c
@@ -379,7 +379,7 @@ int acpuclk_set_rate(unsigned long rate, int for_power_collapse)
 		}
 #if PERF_SWITCH_STEP_DEBUG
 		printk(KERN_DEBUG "%s: STEP khz = %u, pll = %d\n",
-			__FUNCTION__, cur_s->a11clk_khz, cur_s->pll);
+			__func__, cur_s->a11clk_khz, cur_s->pll);
 #endif
 		if (!for_power_collapse && cur_s->pll != ACPU_PLL_TCXO
 		    && !(plls_enabled & (1 << cur_s->pll))) {
@@ -428,7 +428,7 @@ int acpuclk_set_rate(unsigned long rate, int for_power_collapse)
 	}
 
 #if PERF_SWITCH_DEBUG
-	printk(KERN_DEBUG "%s: ACPU speed change complete\n", __FUNCTION__);
+	printk(KERN_DEBUG "%s: ACPU speed change complete\n", __func__);
 #endif
 out:
 	if (!for_power_collapse)
-- 
1.7.3.4

