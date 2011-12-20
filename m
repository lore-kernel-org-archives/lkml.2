Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753801Ab1LTAnv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 19:43:51 -0500
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:36867 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753765Ab1LTAnq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 19:43:46 -0500
From: Felipe Contreras <felipe.contreras@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Felipe Balbi <balbi@ti.com>, Vladimir Zapolskiy <vz@mleia.com>,
        Felipe Contreras <felipe.contreras@gmail.com>,
        Greg Kroah-Hartman <gregkh@suse.de> (supporter:USB SUBSYSTEM),
        linux-usb@vger.kernel.org (open list:USB GADGET/PERIPH...)
Subject: [PATCH 07/10] usb: gadget: remove useless depends on Kconfig
Date: Tue, 20 Dec 2011 02:42:24 +0200
Message-Id: <1324341747-5922-8-git-send-email-felipe.contreras@gmail.com>
X-Mailer: git-send-email 1.7.8.rc1.14.g248db
In-Reply-To: <1324341747-5922-1-git-send-email-felipe.contreras@gmail.com>
References: <1324341747-5922-1-git-send-email-felipe.contreras@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Where are inside an 'if USB_GADGET'.

Signed-off-by: Felipe Contreras <felipe.contreras@gmail.com>
---
 drivers/usb/gadget/Kconfig |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/gadget/Kconfig b/drivers/usb/gadget/Kconfig
index 23a4473..6207f1a 100644
--- a/drivers/usb/gadget/Kconfig
+++ b/drivers/usb/gadget/Kconfig
@@ -124,7 +124,6 @@ config USB_GADGET_STORAGE_NUM_BUFFERS
 #
 choice
 	prompt "USB Peripheral Controller"
-	depends on USB_GADGET
 	help
 	   A USB device uses a controller to talk to its host.
 	   Systems should have only one such upstream link.
@@ -544,12 +543,10 @@ endchoice
 # Selected by UDC drivers that support high-speed operation.
 config USB_GADGET_DUALSPEED
 	bool
-	depends on USB_GADGET
 
 # Selected by UDC drivers that support super-speed opperation
 config USB_GADGET_SUPERSPEED
 	bool
-	depends on USB_GADGET
 	depends on USB_GADGET_DUALSPEED
 
 #
@@ -557,7 +554,6 @@ config USB_GADGET_SUPERSPEED
 #
 choice
 	tristate "USB Gadget Drivers"
-	depends on USB_GADGET
 	default USB_ETH
 	help
 	  A Linux "Gadget Driver" talks to the USB Peripheral Controller
-- 
1.7.8.rc1.14.g248db

