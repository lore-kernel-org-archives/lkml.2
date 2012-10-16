Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755122Ab2JPPay (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 11:30:54 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:51619 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754728Ab2JPPax (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 11:30:53 -0400
From: Sebastien Guiriec <s-guiriec@ti.com>
To: Sebastien Guiriec <s-guiriec@ti.com>, Tony Lindgren <tony@atomide.com>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, Russell King <linux@arm.linux.org.uk>
Subject: [PATCH] OMAP4: devices: fixup OMAP4 DMIC platform device error message
Date: Tue, 16 Oct 2012 17:30:40 +0200
Message-ID: <1350401440-9620-1-git-send-email-s-guiriec@ti.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Correct DMIC hwmod lockup error message and replace printk() by
pr_err().

Signed-off-by: Sebastien Guiriec <s-guiriec@ti.com>
---
 arch/arm/mach-omap2/devices.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/mach-omap2/devices.c b/arch/arm/mach-omap2/devices.c
index c8c2117..cba60e0 100644
--- a/arch/arm/mach-omap2/devices.c
+++ b/arch/arm/mach-omap2/devices.c
@@ -341,7 +341,7 @@ static void __init omap_init_dmic(void)
 
 	oh = omap_hwmod_lookup("dmic");
 	if (!oh) {
-		printk(KERN_ERR "Could not look up mcpdm hw_mod\n");
+		pr_err("Could not look up dmic hw_mod\n");
 		return;
 	}
 
-- 
1.7.10.4

