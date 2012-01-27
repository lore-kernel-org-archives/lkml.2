Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753948Ab2A0K2Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 05:28:25 -0500
Received: from newsmtp5.atmel.com ([204.2.163.5]:28717 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751525Ab2A0K2X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 05:28:23 -0500
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: plagnioj@jcrosoft.com, linux-arm-kernel@lists.infradead.org
Cc: karel@ryston.cz, linux-kernel@vger.kernel.org,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        stable <stable@vger.kernel.org>
Subject: [PATCH] ARM: at91: USB AT91 gadget registration for module
Date: Fri, 27 Jan 2012 11:28:07 +0100
Message-Id: <1327660087-20864-1-git-send-email-nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Registration of at91_udc as a module will enable SoC
related code.

Fix following an idea from Karel Znamenacek.

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: stable <stable@vger.kernel.org>
---
Karel,

Do you want to add your "Acked-by" line?

 arch/arm/mach-at91/at91rm9200_devices.c  |    2 +-
 arch/arm/mach-at91/at91sam9260_devices.c |    2 +-
 arch/arm/mach-at91/at91sam9261_devices.c |    2 +-
 arch/arm/mach-at91/at91sam9263_devices.c |    2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm/mach-at91/at91rm9200_devices.c b/arch/arm/mach-at91/at91rm9200_devices.c
index 18bacec..97676bd 100644
--- a/arch/arm/mach-at91/at91rm9200_devices.c
+++ b/arch/arm/mach-at91/at91rm9200_devices.c
@@ -83,7 +83,7 @@ void __init at91_add_device_usbh(struct at91_usbh_data *data) {}
  *  USB Device (Gadget)
  * -------------------------------------------------------------------- */
 
-#ifdef CONFIG_USB_AT91
+#if defined(CONFIG_USB_AT91) || defined(CONFIG_USB_AT91_MODULE)
 static struct at91_udc_data udc_data;
 
 static struct resource udc_resources[] = {
diff --git a/arch/arm/mach-at91/at91sam9260_devices.c b/arch/arm/mach-at91/at91sam9260_devices.c
index 642ccb6..f1a1bb45 100644
--- a/arch/arm/mach-at91/at91sam9260_devices.c
+++ b/arch/arm/mach-at91/at91sam9260_devices.c
@@ -84,7 +84,7 @@ void __init at91_add_device_usbh(struct at91_usbh_data *data) {}
  *  USB Device (Gadget)
  * -------------------------------------------------------------------- */
 
-#ifdef CONFIG_USB_AT91
+#if defined(CONFIG_USB_AT91) || defined(CONFIG_USB_AT91_MODULE)
 static struct at91_udc_data udc_data;
 
 static struct resource udc_resources[] = {
diff --git a/arch/arm/mach-at91/at91sam9261_devices.c b/arch/arm/mach-at91/at91sam9261_devices.c
index fc59cbd..1e28bed 100644
--- a/arch/arm/mach-at91/at91sam9261_devices.c
+++ b/arch/arm/mach-at91/at91sam9261_devices.c
@@ -87,7 +87,7 @@ void __init at91_add_device_usbh(struct at91_usbh_data *data) {}
  *  USB Device (Gadget)
  * -------------------------------------------------------------------- */
 
-#ifdef CONFIG_USB_AT91
+#if defined(CONFIG_USB_AT91) || defined(CONFIG_USB_AT91_MODULE)
 static struct at91_udc_data udc_data;
 
 static struct resource udc_resources[] = {
diff --git a/arch/arm/mach-at91/at91sam9263_devices.c b/arch/arm/mach-at91/at91sam9263_devices.c
index 7b46b27..618013d 100644
--- a/arch/arm/mach-at91/at91sam9263_devices.c
+++ b/arch/arm/mach-at91/at91sam9263_devices.c
@@ -92,7 +92,7 @@ void __init at91_add_device_usbh(struct at91_usbh_data *data) {}
  *  USB Device (Gadget)
  * -------------------------------------------------------------------- */
 
-#ifdef CONFIG_USB_AT91
+#if defined(CONFIG_USB_AT91) || defined(CONFIG_USB_AT91_MODULE)
 static struct at91_udc_data udc_data;
 
 static struct resource udc_resources[] = {
-- 
1.7.5.4

