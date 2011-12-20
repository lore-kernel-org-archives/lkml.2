Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753865Ab1LTAo6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 19:44:58 -0500
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:36867 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753748Ab1LTAnn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 19:43:43 -0500
From: Felipe Contreras <felipe.contreras@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Felipe Balbi <balbi@ti.com>, Vladimir Zapolskiy <vz@mleia.com>,
        Felipe Contreras <felipe.contreras@gmail.com>,
        Greg Kroah-Hartman <gregkh@suse.de> (supporter:USB SUBSYSTEM),
        Jiri Kosina <trivial@kernel.org> (maintainer:TRIVIAL PATCHES),
        David Woodhouse <david.woodhouse@intel.com> (commit_signer:1/2=50%),
        Andrew Morton <akpm@linux-foundation.org> (commit_signer:1/2=50%),
        Ingo Molnar <mingo@elte.hu> (commit_signer:1/2=50%),
        David Rientjes <rientjes@google.com> (commit_signer:1/2=50%),
        linux-usb@vger.kernel.org (open list:USB SUBSYSTEM)
Subject: [PATCH 06/10] usb: core: trivial Kconfig cleanups
Date: Tue, 20 Dec 2011 02:42:23 +0200
Message-Id: <1324341747-5922-7-git-send-email-felipe.contreras@gmail.com>
X-Mailer: git-send-email 1.7.8.rc1.14.g248db
In-Reply-To: <1324341747-5922-1-git-send-email-felipe.contreras@gmail.com>
References: <1324341747-5922-1-git-send-email-felipe.contreras@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The default is 'n', so specifying it is a no-op.

Signed-off-by: Felipe Contreras <felipe.contreras@gmail.com>
---
 drivers/usb/core/Kconfig |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/core/Kconfig b/drivers/usb/core/Kconfig
index 18d02e3..1b1d371 100644
--- a/drivers/usb/core/Kconfig
+++ b/drivers/usb/core/Kconfig
@@ -12,7 +12,6 @@ config USB_DEBUG
 config USB_ANNOUNCE_NEW_DEVICES
 	bool "USB announce new devices"
 	depends on USB
-	default N
 	help
 	  Say Y here if you want the USB core to always announce the
 	  idVendor, idProduct, Manufacturer, Product, and SerialNumber
@@ -110,7 +109,6 @@ config USB_OTG
 	bool "OTG support"
 	depends on USB && EXPERIMENTAL
 	depends on USB_SUSPEND
-	default n
 	help
 	  The most notable feature of USB OTG is support for a
 	  "Dual-Role" device, which can act as either a device
@@ -125,7 +123,6 @@ config USB_OTG_WHITELIST
 	bool "Rely on OTG Targeted Peripherals List"
 	depends on USB_OTG || EXPERT
 	default y if USB_OTG
-	default n if EXPERT
 	help
 	  If you say Y here, the "otg_whitelist.h" file will be used as a
 	  product whitelist, so USB peripherals not listed there will be
@@ -147,4 +144,3 @@ config USB_OTG_BLACKLIST_HUB
 	  external hubs.  OTG hosts are allowed to reduce hardware
 	  and software costs by not supporting external hubs.  So
 	  are "Embedded Hosts" that don't offer OTG support.
-
-- 
1.7.8.rc1.14.g248db

