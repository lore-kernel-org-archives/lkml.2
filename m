Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756153Ab1G1XoW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 19:44:22 -0400
Received: from mga02.intel.com ([134.134.136.20]:12959 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756090Ab1G1XoQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 19:44:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,285,1309762800"; 
   d="scan'208";a="33351976"
From: Andi Kleen <andi@firstfloor.org>
References: <20110728444.299940435@firstfloor.org>
In-Reply-To: <20110728444.299940435@firstfloor.org>
To: wd@denx.de, gregkh@suse.de, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [12/50] USB: serial: add IDs for WinChipHead USB->RS232 adapter
Message-Id: <20110728234416.827BF2403FF@tassilo.jf.intel.com>
Date: Thu, 28 Jul 2011 16:44:16 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Wolfgang Denk <wd@denx.de>

[ upstream commit 026dfaf18973404a01f488d6aa556a8c466e06a4 ]

Add ID 4348:5523 for WinChipHead USB->RS 232 adapter with
Prolifec PL2303 chipset

Signed-off-by: Wolfgang Denk <wd@denx.de>
Cc: stable <stable@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

Index: linux-2.6.35.y/drivers/usb/serial/pl2303.c
===================================================================
--- linux-2.6.35.y.orig/drivers/usb/serial/pl2303.c
+++ linux-2.6.35.y/drivers/usb/serial/pl2303.c
@@ -91,6 +91,7 @@ static const struct usb_device_id id_tab
 	{ USB_DEVICE(SONY_VENDOR_ID, SONY_QN3USB_PRODUCT_ID) },
 	{ USB_DEVICE(SANWA_VENDOR_ID, SANWA_PRODUCT_ID) },
 	{ USB_DEVICE(ADLINK_VENDOR_ID, ADLINK_ND6530_PRODUCT_ID) },
+	{ USB_DEVICE(WINCHIPHEAD_VENDOR_ID, WINCHIPHEAD_USBSER_PRODUCT_ID) },
 	{ }					/* Terminating entry */
 };
 
Index: linux-2.6.35.y/drivers/usb/serial/pl2303.h
===================================================================
--- linux-2.6.35.y.orig/drivers/usb/serial/pl2303.h
+++ linux-2.6.35.y/drivers/usb/serial/pl2303.h
@@ -144,3 +144,7 @@
 /* ADLINK ND-6530 RS232,RS485 and RS422 adapter */
 #define ADLINK_VENDOR_ID		0x0b63
 #define ADLINK_ND6530_PRODUCT_ID	0x6530
+
+/* WinChipHead USB->RS 232 adapter */
+#define WINCHIPHEAD_VENDOR_ID		0x4348
+#define WINCHIPHEAD_USBSER_PRODUCT_ID	0x5523
