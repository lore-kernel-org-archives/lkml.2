Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759402Ab1EBOZ3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 10:25:29 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:53815 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756223Ab1EBOZ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 10:25:26 -0400
From: srinath@mistralsolutions.com
To: linux-omap@vger.kernel.org
Cc: jdk@ti.com, tony@atomide.com, linux-kernel@vger.kernel.org,
        linux@arm.linux.org.uk, linux-arm-kernel@lists.infradead.org,
        khilman@deeprootsystems.com, nm@ti.com, nagendra@mistralsolutions.com,
        umeshk@mistralsolutions.com,
        "Srinath.R" <srinath@mistralsolutions.com>
Subject: [Patch v2] AM35xx-Craneboard: USB EHCI: Fix USB ECHI PHY reset
Date: Mon,  2 May 2011 19:10:42 +0530
Message-Id: <1304343643-3148-1-git-send-email-srinath@mistralsolutions.com>
X-Mailer: git-send-email 1.7.1.226.g770c5
In-Reply-To: <[PATCH]>
References: <[PATCH]>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Srinath.R <srinath@mistralsolutions.com>

This patch fixes the EHCI PHY reset issue found on CraneBoard.

History:
https://patchwork.kernel.org/patch/740741/

Signed-off-by: Srinath.R <srinath@mistralsolutions.com>
---
 arch/arm/mach-omap2/board-am3517crane.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-omap2/board-am3517crane.c b/arch/arm/mach-omap2/board-am3517crane.c
index a890d24..05867b5 100644
--- a/arch/arm/mach-omap2/board-am3517crane.c
+++ b/arch/arm/mach-omap2/board-am3517crane.c
@@ -60,7 +60,7 @@ static struct usbhs_omap_board_data usbhs_bdata __initdata = {
 	.port_mode[1] = OMAP_USBHS_PORT_MODE_UNUSED,
 	.port_mode[2] = OMAP_USBHS_PORT_MODE_UNUSED,
 
-	.phy_reset  = true,
+	.phy_reset  = false,
 	.reset_gpio_port[0]  = GPIO_USB_NRESET,
 	.reset_gpio_port[1]  = -EINVAL,
 	.reset_gpio_port[2]  = -EINVAL
-- 
1.5.3.4

