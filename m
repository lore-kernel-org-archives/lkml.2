Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932792Ab1LPTuO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 14:50:14 -0500
Received: from cantor2.suse.de ([195.135.220.15]:44967 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932675Ab1LPTti (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 14:49:38 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Dec 16 11:45:55 2011
Message-Id: <20111216194555.292024784@clark.kroah.org>
User-Agent: quilt/0.50-24.1
Date: Fri, 16 Dec 2011 11:45:05 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Anders Darander <anders@chargestorm.se>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [08/53] ARM: at91: Fix USB AT91 gadget registration
In-Reply-To: <20111216194613.GA18395@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anders Darander <anders@chargestorm.se>

commit 0e934e22f3fabb98c41737e2e30bd9db2668e935 upstream.

Since 193ab2a6070039e7ee2b9b9bebea754a7c52fd1b, various AT91 boards don't
register at91_udc anymore due to depending on a now non-existing symbol.
Fix the symbol name.

Signed-off-by: Anders Darander <anders@chargestorm.se>
Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/arm/mach-at91/at91rm9200_devices.c  |    2 +-
 arch/arm/mach-at91/at91sam9260_devices.c |    2 +-
 arch/arm/mach-at91/at91sam9261_devices.c |    2 +-
 arch/arm/mach-at91/at91sam9263_devices.c |    2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

--- a/arch/arm/mach-at91/at91rm9200_devices.c
+++ b/arch/arm/mach-at91/at91rm9200_devices.c
@@ -75,7 +75,7 @@ void __init at91_add_device_usbh(struct
  *  USB Device (Gadget)
  * -------------------------------------------------------------------- */
 
-#ifdef CONFIG_USB_GADGET_AT91
+#ifdef CONFIG_USB_AT91
 static struct at91_udc_data udc_data;
 
 static struct resource udc_resources[] = {
--- a/arch/arm/mach-at91/at91sam9260_devices.c
+++ b/arch/arm/mach-at91/at91sam9260_devices.c
@@ -76,7 +76,7 @@ void __init at91_add_device_usbh(struct
  *  USB Device (Gadget)
  * -------------------------------------------------------------------- */
 
-#ifdef CONFIG_USB_GADGET_AT91
+#ifdef CONFIG_USB_AT91
 static struct at91_udc_data udc_data;
 
 static struct resource udc_resources[] = {
--- a/arch/arm/mach-at91/at91sam9261_devices.c
+++ b/arch/arm/mach-at91/at91sam9261_devices.c
@@ -79,7 +79,7 @@ void __init at91_add_device_usbh(struct
  *  USB Device (Gadget)
  * -------------------------------------------------------------------- */
 
-#ifdef CONFIG_USB_GADGET_AT91
+#ifdef CONFIG_USB_AT91
 static struct at91_udc_data udc_data;
 
 static struct resource udc_resources[] = {
--- a/arch/arm/mach-at91/at91sam9263_devices.c
+++ b/arch/arm/mach-at91/at91sam9263_devices.c
@@ -86,7 +86,7 @@ void __init at91_add_device_usbh(struct
  *  USB Device (Gadget)
  * -------------------------------------------------------------------- */
 
-#ifdef CONFIG_USB_GADGET_AT91
+#ifdef CONFIG_USB_AT91
 static struct at91_udc_data udc_data;
 
 static struct resource udc_resources[] = {


