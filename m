Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757512Ab1E3ROS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 13:14:18 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:51356 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750982Ab1E3ROR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 13:14:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=fadwr65cgXTRkgSfirh1yYenla2iGXug9Z9nW1TS4A1G8pMTh6ui2v+5GBedMit4a3
         YiJRl/ZqB03gEw1eaxT+X3Kxs3rXkh0+aA/lBYZn3crsPT4KcEcYlwKtLIGS8MGyV+4G
         nei9GTMcpA60SxckCqME6vNbd0a5aRh8ckWyY=
From: Maxim Osipov <maxim.osipov@gmail.com>
To: Andrew Victor <linux@maxim.org.za>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Maxim Osipov <maxim.osipov@gmail.com>
Subject: [PATCH 1/1] AT91: flexibity: default leds to heartbeat
Date: Mon, 30 May 2011 18:13:47 +0100
Message-Id: <1306775627-6640-1-git-send-email-maxim.osipov@gmail.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch changes default behavior of Flexibity board LEDs to blinking
for boot diagnostic purpose.

Signed-off-by: Maxim Osipov <maxim.osipov@gmail.com>
---
 arch/arm/mach-at91/board-flexibity.c |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/arm/mach-at91/board-flexibity.c b/arch/arm/mach-at91/board-flexibity.c
index 4fdc96c..8cbec8a 100644
--- a/arch/arm/mach-at91/board-flexibity.c
+++ b/arch/arm/mach-at91/board-flexibity.c
@@ -96,49 +96,49 @@ static struct gpio_led flexibity_leds[] = {
 		.name			= "usb1:green",
 		.gpio			= AT91_PIN_PA12,
 		.active_low		= 1,
-		.default_trigger	= "default-on",
+		.default_trigger	= "heartbeat",
 	},
 	{
 		.name			= "usb1:red",
 		.gpio			= AT91_PIN_PA13,
 		.active_low		= 1,
-		.default_trigger	= "default-on",
+		.default_trigger	= "heartbeat",
 	},
 	{
 		.name			= "usb2:green",
 		.gpio			= AT91_PIN_PB26,
 		.active_low		= 1,
-		.default_trigger	= "default-on",
+		.default_trigger	= "heartbeat",
 	},
 	{
 		.name			= "usb2:red",
 		.gpio			= AT91_PIN_PB27,
 		.active_low		= 1,
-		.default_trigger	= "default-on",
+		.default_trigger	= "heartbeat",
 	},
 	{
 		.name			= "usb3:green",
 		.gpio			= AT91_PIN_PC8,
 		.active_low		= 1,
-		.default_trigger	= "default-on",
+		.default_trigger	= "heartbeat",
 	},
 	{
 		.name			= "usb3:red",
 		.gpio			= AT91_PIN_PC6,
 		.active_low		= 1,
-		.default_trigger	= "default-on",
+		.default_trigger	= "heartbeat",
 	},
 	{
 		.name			= "usb4:green",
 		.gpio			= AT91_PIN_PB4,
 		.active_low		= 1,
-		.default_trigger	= "default-on",
+		.default_trigger	= "heartbeat",
 	},
 	{
 		.name			= "usb4:red",
 		.gpio			= AT91_PIN_PB5,
 		.active_low		= 1,
-		.default_trigger	= "default-on",
+		.default_trigger	= "heartbeat",
 	}
 };
 
-- 
1.7.4.1

