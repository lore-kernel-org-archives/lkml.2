Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756212Ab2DSSIM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 14:08:12 -0400
Received: from unicorn.mansr.com ([78.86.181.103]:40236 "EHLO
	unicorn.mansr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753919Ab2DSSIL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 14:08:11 -0400
X-Greylist: delayed 568 seconds by postgrey-1.27 at vger.kernel.org; Thu, 19 Apr 2012 14:08:11 EDT
From: Mans Rullgard <mans@mansr.com>
To: linux-omap@vger.kernel.org
Cc: Tony Lindgren <tony@atomide.com>, Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH] ARM: OMAP2+: craneboard: register emac device
Date: Thu, 19 Apr 2012 18:56:21 +0100
Message-Id: <1334858181-7232-1-git-send-email-mans@mansr.com>
X-Mailer: git-send-email 1.7.8.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds the required am35xx_emac_init() call to the craneboard init
function.

Signed-off-by: Mans Rullgard <mans@mansr.com>
---
 arch/arm/mach-omap2/board-am3517crane.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-omap2/board-am3517crane.c b/arch/arm/mach-omap2/board-am3517crane.c
index c3851e8..3b8a53c 100644
--- a/arch/arm/mach-omap2/board-am3517crane.c
+++ b/arch/arm/mach-omap2/board-am3517crane.c
@@ -30,6 +30,7 @@
 #include "common.h"
 #include <plat/usb.h>
 
+#include "am35xx-emac.h"
 #include "mux.h"
 #include "control.h"
 
@@ -90,6 +91,7 @@ static void __init am3517_crane_init(void)
 	}
 
 	usbhs_init(&usbhs_bdata);
+	am35xx_emac_init(AM35XX_DEFAULT_MDIO_FREQUENCY, 1);
 }
 
 MACHINE_START(CRANEBOARD, "AM3517/05 CRANEBOARD")
-- 
1.7.8.5

