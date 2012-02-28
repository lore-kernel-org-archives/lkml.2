Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965400Ab2B1BYj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 20:24:39 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:58867 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965331Ab2B1BTP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 20:19:15 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of gregkh@linuxfoundation.org designates 10.68.226.231 as permitted sender) smtp.mail=gregkh@linuxfoundation.org
MIME-Version: 1.0
Message-Id: <20120228010429.649073322@linuxfoundation.org>
User-Agent: quilt/0.51-17.1
Date: Mon, 27 Feb 2012 17:04:32 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Nicolas Ferre <nicolas.ferre@atmel.com>,
        Karel Znamenacek <karel@ryston.cz>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Subject: [ 03/72] ARM: at91: USB AT91 gadget registration for module
In-Reply-To: <20120228010511.GA8453@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicolas Ferre <nicolas.ferre@atmel.com>

commit e8c9dc93e27d891636defbc269f182a83e6abba8 upstream.

Registration of at91_udc as a module will enable SoC
related code.

Fix following an idea from Karel Znamenacek.

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Acked-by: Karel Znamenacek <karel@ryston.cz>
Acked-by: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/mach-at91/at91rm9200_devices.c  |    2 +-
 arch/arm/mach-at91/at91sam9260_devices.c |    2 +-
 arch/arm/mach-at91/at91sam9261_devices.c |    2 +-
 arch/arm/mach-at91/at91sam9263_devices.c |    2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

--- a/arch/arm/mach-at91/at91rm9200_devices.c
+++ b/arch/arm/mach-at91/at91rm9200_devices.c
@@ -83,7 +83,7 @@ void __init at91_add_device_usbh(struct
  *  USB Device (Gadget)
  * -------------------------------------------------------------------- */
 
-#ifdef CONFIG_USB_AT91
+#if defined(CONFIG_USB_AT91) || defined(CONFIG_USB_AT91_MODULE)
 static struct at91_udc_data udc_data;
 
 static struct resource udc_resources[] = {
--- a/arch/arm/mach-at91/at91sam9260_devices.c
+++ b/arch/arm/mach-at91/at91sam9260_devices.c
@@ -84,7 +84,7 @@ void __init at91_add_device_usbh(struct
  *  USB Device (Gadget)
  * -------------------------------------------------------------------- */
 
-#ifdef CONFIG_USB_AT91
+#if defined(CONFIG_USB_AT91) || defined(CONFIG_USB_AT91_MODULE)
 static struct at91_udc_data udc_data;
 
 static struct resource udc_resources[] = {
--- a/arch/arm/mach-at91/at91sam9261_devices.c
+++ b/arch/arm/mach-at91/at91sam9261_devices.c
@@ -87,7 +87,7 @@ void __init at91_add_device_usbh(struct
  *  USB Device (Gadget)
  * -------------------------------------------------------------------- */
 
-#ifdef CONFIG_USB_AT91
+#if defined(CONFIG_USB_AT91) || defined(CONFIG_USB_AT91_MODULE)
 static struct at91_udc_data udc_data;
 
 static struct resource udc_resources[] = {
--- a/arch/arm/mach-at91/at91sam9263_devices.c
+++ b/arch/arm/mach-at91/at91sam9263_devices.c
@@ -92,7 +92,7 @@ void __init at91_add_device_usbh(struct
  *  USB Device (Gadget)
  * -------------------------------------------------------------------- */
 
-#ifdef CONFIG_USB_AT91
+#if defined(CONFIG_USB_AT91) || defined(CONFIG_USB_AT91_MODULE)
 static struct at91_udc_data udc_data;
 
 static struct resource udc_resources[] = {


