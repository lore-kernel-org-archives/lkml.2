Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753842Ab1LTAn6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 19:43:58 -0500
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:36867 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753792Ab1LTAnv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 19:43:51 -0500
From: Felipe Contreras <felipe.contreras@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Felipe Balbi <balbi@ti.com>, Vladimir Zapolskiy <vz@mleia.com>,
        Felipe Contreras <felipe.contreras@gmail.com>,
        Greg Kroah-Hartman <gregkh@suse.de> (supporter:USB SUBSYSTEM 
	,commit_signer:4/5=80%),
        Jiri Kosina <trivial@kernel.org> (maintainer:TRIVIAL PATCHES),
        Pavankumar Kondeti <pkondeti@codeaurora.org> (commit_signer:2/5=40%),
        Benoit Goby <benoit@android.com> (commit_signer:1/5=20%),
        Li Yang <leoli@freescale.com> (commit_signer:1/5=20%),
        linux-usb@vger.kernel.org (open list:USB SUBSYSTEM)
Subject: [PATCH 09/10] usb: otg: trivial cleanups
Date: Tue, 20 Dec 2011 02:42:26 +0200
Message-Id: <1324341747-5922-10-git-send-email-felipe.contreras@gmail.com>
X-Mailer: git-send-email 1.7.8.rc1.14.g248db
In-Reply-To: <1324341747-5922-1-git-send-email-felipe.contreras@gmail.com>
References: <1324341747-5922-1-git-send-email-felipe.contreras@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Spaces to tabs, proper alignment, and start sentences as they should.

Signed-off-by: Felipe Contreras <felipe.contreras@gmail.com>
---
 drivers/usb/otg/Kconfig |   20 ++++++++++----------
 1 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/usb/otg/Kconfig b/drivers/usb/otg/Kconfig
index c66481a..5e913d7 100644
--- a/drivers/usb/otg/Kconfig
+++ b/drivers/usb/otg/Kconfig
@@ -82,9 +82,9 @@ config NOP_USB_XCEIV
 	tristate "NOP USB Transceiver Driver"
 	select USB_OTG_UTILS
 	help
-	 this driver is to be used by all the usb transceiver which are either
-	 built-in with usb ip or which are autonomous and doesn't require any
-	 phy programming such as ISP1x04 etc.
+	  This driver is to be used by all the usb transceiver which are either
+	  built-in with usb ip or which are autonomous and doesn't require any
+	  phy programming such as ISP1x04 etc.
 
 config USB_LANGWELL_OTG
 	tristate "Intel Langwell USB OTG dual-role support"
@@ -114,13 +114,13 @@ config USB_MSM_OTG
 	  has an external PHY.
 
 config AB8500_USB
-        tristate "AB8500 USB Transceiver Driver"
-        depends on AB8500_CORE
-        select USB_OTG_UTILS
-        help
-          Enable this to support the USB OTG transceiver in AB8500 chip.
-          This transceiver supports high and full speed devices plus,
-          in host mode, low speed.
+	tristate "AB8500 USB Transceiver Driver"
+	depends on AB8500_CORE
+	select USB_OTG_UTILS
+	help
+	  Enable this to support the USB OTG transceiver in AB8500 chip.
+	  This transceiver supports high and full speed devices plus,
+	  in host mode, low speed.
 
 config FSL_USB2_OTG
 	bool "Freescale USB OTG Transceiver Driver"
-- 
1.7.8.rc1.14.g248db

