Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754785Ab2HaRyw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2012 13:54:52 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:46072 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754350Ab2HaRyu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2012 13:54:50 -0400
From: Vaibhav Hiremath <hvaibhav@ti.com>
To: <linux-omap@vger.kernel.org>
CC: <linux-arm-kernel@lists.infradead.org>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        Vaibhav Hiremath <hvaibhav@ti.com>, Tony Lindgren <tony@atomide.com>
Subject: [PATCH] ARM: OMAP2+: Makefile.boot: Add am335x evm and bone targets
Date: Fri, 31 Aug 2012 23:24:34 +0530
Message-ID: <1346435674-6207-1-git-send-email-hvaibhav@ti.com>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds am335x-evm and am335x-bone dtb targets to
'make dtbs', just like other platforms.

Signed-off-by: Vaibhav Hiremath <hvaibhav@ti.com>
Cc: Tony Lindgren <tony@atomide.com>
---
 arch/arm/mach-omap2/Makefile.boot |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-omap2/Makefile.boot b/arch/arm/mach-omap2/Makefile.boot
index 6cf1c2d..1136072 100644
--- a/arch/arm/mach-omap2/Makefile.boot
+++ b/arch/arm/mach-omap2/Makefile.boot
@@ -7,3 +7,4 @@ dtb-$(CONFIG_ARCH_OMAP3)	+= omap3-beagle.dtb omap3-evm.dtb
 dtb-$(CONFIG_ARCH_OMAP4)	+= omap4-panda.dtb omap4-pandaES.dtb
 dtb-$(CONFIG_ARCH_OMAP4)	+= omap4-var_som.dtb omap4-sdp.dtb
 dtb-$(CONFIG_SOC_OMAP5)		+= omap5-evm.dtb
+dtb-$(CONFIG_SOC_AM33XX)	+= am335x-evm.dtb am335x-bone.dtb
-- 
1.7.0.4

