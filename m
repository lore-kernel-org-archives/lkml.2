Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756048Ab1K3Hxb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 02:53:31 -0500
Received: from STOEXHUB02.domain01.net ([83.145.59.143]:41140 "EHLO
	STOEXHUB02.domain01.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751774Ab1K3Hxa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 02:53:30 -0500
X-Greylist: delayed 338 seconds by postgrey-1.27 at vger.kernel.org; Wed, 30 Nov 2011 02:53:30 EST
From: Anders Darander <anders@chargestorm.se>
To: <linux@maxim.org.za>, <nicolas.ferre@atmel.com>, <plagnioj@jcrosoft.com>,
        <linux@arm.linux.org.uk>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Anders Darander <anders@chargestorm.se>
Subject: [PATCH] ARM: at91: Fix USB gadget registration
Date: Wed, 30 Nov 2011 08:47:44 +0100
Message-ID: <1322639264-24333-1-git-send-email-anders@chargestorm.se>
X-Mailer: git-send-email 1.7.7.3
MIME-Version: 1.0
Content-Type: text/plain
X-GFI-SMTP-Submission: 1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since 193ab2a6070039e7ee2b9b9bebea754a7c52fd1b, various AT91 boards don't
register at91_udc anymore due to depending on a now non-existing symbol.
Fix the symbol name.

Signed-off-by: Anders Darander <anders@chargestorm.se>
---

Patched based on 3.2-rc3, but should apply to older and newer trees as well.

Verified on a custom, at91sam9g20 based board.

---
 arch/arm/mach-at91/at91rm9200_devices.c  |    2 +-
 arch/arm/mach-at91/at91sam9260_devices.c |    2 +-
 arch/arm/mach-at91/at91sam9261_devices.c |    2 +-
 arch/arm/mach-at91/at91sam9263_devices.c |    2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm/mach-at91/at91rm9200_devices.c b/arch/arm/mach-at91/at91rm9200_devices.c
index 66591fa..ad93068 100644
--- a/arch/arm/mach-at91/at91rm9200_devices.c
+++ b/arch/arm/mach-at91/at91rm9200_devices.c
@@ -83,7 +83,7 @@ void __init at91_add_device_usbh(struct at91_usbh_data *data) {}
  *  USB Device (Gadget)
  * -------------------------------------------------------------------- */
 
-#ifdef CONFIG_USB_GADGET_AT91
+#ifdef CONFIG_USB_AT91
 static struct at91_udc_data udc_data;
 
 static struct resource udc_resources[] = {
diff --git a/arch/arm/mach-at91/at91sam9260_devices.c b/arch/arm/mach-at91/at91sam9260_devices.c
index 25e3464..629fa97 100644
--- a/arch/arm/mach-at91/at91sam9260_devices.c
+++ b/arch/arm/mach-at91/at91sam9260_devices.c
@@ -84,7 +84,7 @@ void __init at91_add_device_usbh(struct at91_usbh_data *data) {}
  *  USB Device (Gadget)
  * -------------------------------------------------------------------- */
 
-#ifdef CONFIG_USB_GADGET_AT91
+#ifdef CONFIG_USB_AT91
 static struct at91_udc_data udc_data;
 
 static struct resource udc_resources[] = {
diff --git a/arch/arm/mach-at91/at91sam9261_devices.c b/arch/arm/mach-at91/at91sam9261_devices.c
index ae78f4d..a178b58 100644
--- a/arch/arm/mach-at91/at91sam9261_devices.c
+++ b/arch/arm/mach-at91/at91sam9261_devices.c
@@ -87,7 +87,7 @@ void __init at91_add_device_usbh(struct at91_usbh_data *data) {}
  *  USB Device (Gadget)
  * -------------------------------------------------------------------- */
 
-#ifdef CONFIG_USB_GADGET_AT91
+#ifdef CONFIG_USB_AT91
 static struct at91_udc_data udc_data;
 
 static struct resource udc_resources[] = {
diff --git a/arch/arm/mach-at91/at91sam9263_devices.c b/arch/arm/mach-at91/at91sam9263_devices.c
index ad017eb..d5fbac9 100644
--- a/arch/arm/mach-at91/at91sam9263_devices.c
+++ b/arch/arm/mach-at91/at91sam9263_devices.c
@@ -92,7 +92,7 @@ void __init at91_add_device_usbh(struct at91_usbh_data *data) {}
  *  USB Device (Gadget)
  * -------------------------------------------------------------------- */
 
-#ifdef CONFIG_USB_GADGET_AT91
+#ifdef CONFIG_USB_AT91
 static struct at91_udc_data udc_data;
 
 static struct resource udc_resources[] = {
-- 
1.7.7.3

