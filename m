Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758737Ab0GAV71 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 17:59:27 -0400
Received: from kroah.org ([198.145.64.141]:33878 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758774Ab0GAVNL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 17:13:11 -0400
X-Mailbox-Line: From gregkh@clark.site Thu Jul  1 10:42:49 2010
Message-Id: <20100701174249.380138853@clark.site>
User-Agent: quilt/0.48-10.1
Date: Thu, 01 Jul 2010 10:42:05 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Wolfram Sang <w.sang@pengutronix.de>,
       Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [035/200] ARM: 6135/1: mx21/devices: fix USBOTG resource
In-Reply-To: <20100701175201.GA2149@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wolfram Sang <w.sang@pengutronix.de>

commit e1695307e6b85477afd2421d3b4891ca5bea8300 upstream.

It got a typo from 988addf82e4c03739375279de73929580a2d4a6a.

Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/arm/mach-mx2/devices.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/arm/mach-mx2/devices.c
+++ b/arch/arm/mach-mx2/devices.c
@@ -483,8 +483,8 @@ int __init mxc_register_gpios(void)
 #ifdef CONFIG_MACH_MX21
 static struct resource mx21_usbhc_resources[] = {
 	{
-		.start	= MX21_BASE_ADDR,
-		.end	= MX21_BASE_ADDR + 0x1FFF,
+		.start	= MX21_USBOTG_BASE_ADDR,
+		.end	= MX21_USBOTG_BASE_ADDR + SZ_8K - 1,
 		.flags	= IORESOURCE_MEM,
 	},
 	{


