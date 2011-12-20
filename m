Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753773Ab1LTAnq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 19:43:46 -0500
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:36867 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753730Ab1LTAnk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 19:43:40 -0500
From: Felipe Contreras <felipe.contreras@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Felipe Balbi <balbi@ti.com>, Vladimir Zapolskiy <vz@mleia.com>,
        Felipe Contreras <felipe.contreras@gmail.com>,
        Greg Kroah-Hartman <gregkh@suse.de> (supporter:USB SUBSYSTEM),
        Jiri Kosina <trivial@kernel.org> (maintainer:TRIVIAL PATCHES),
        linux-usb@vger.kernel.org (open list:MUSB MULTIPOINT H...)
Subject: [PATCH 05/10] usb: musb: trivial Kconfig cleanups
Date: Tue, 20 Dec 2011 02:42:22 +0200
Message-Id: <1324341747-5922-6-git-send-email-felipe.contreras@gmail.com>
X-Mailer: git-send-email 1.7.8.rc1.14.g248db
In-Reply-To: <1324341747-5922-1-git-send-email-felipe.contreras@gmail.com>
References: <1324341747-5922-1-git-send-email-felipe.contreras@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Shuffle the code a bit so the description is at the top.

Signed-off-by: Felipe Contreras <felipe.contreras@gmail.com>
Acked-by: Felipe Balbi <balbi@ti.com>
---
 drivers/usb/musb/Kconfig |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/musb/Kconfig b/drivers/usb/musb/Kconfig
index 07a0346..b0a46e4 100644
--- a/drivers/usb/musb/Kconfig
+++ b/drivers/usb/musb/Kconfig
@@ -5,6 +5,7 @@
 
 # (M)HDRC = (Multipoint) Highspeed Dual-Role Controller
 config USB_MUSB_HDRC
+	tristate 'Inventra Highspeed Dual Role Controller (TI, ADI, ...)'
 	depends on USB && USB_GADGET
 	depends on (ARM || (BF54x && !BF544) || (BF52x && !BF522 && !BF523))
 	select NOP_USB_XCEIV if (ARCH_DAVINCI || MACH_OMAP3EVM || BLACKFIN)
@@ -12,7 +13,6 @@ config USB_MUSB_HDRC
 	select TWL6030_USB if MACH_OMAP_4430SDP || MACH_OMAP4_PANDA
 	select USB_OTG_UTILS
 	select USB_GADGET_DUALSPEED
-	tristate 'Inventra Highspeed Dual Role Controller (TI, ADI, ...)'
 	help
 	  Say Y here if your system has a dual role high speed USB
 	  controller based on the Mentor Graphics silicon IP.  Then
@@ -107,4 +107,3 @@ config USB_TUSB_OMAP_DMA
 	default y
 	help
 	  Enable DMA transfers on TUSB 6010 when OMAP DMA is available.
-
-- 
1.7.8.rc1.14.g248db

