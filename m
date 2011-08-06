Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756972Ab1HFAa3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 20:30:29 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38939 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756893Ab1HFAHZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 20:07:25 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Aug  5 17:02:50 2011
Message-Id: <20110806000250.580029757@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 05 Aug 2011 17:01:47 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Wolfgang Denk <wd@denx.de>
Subject: [17/55] USB: serial: add IDs for WinChipHead USB->RS232 adapter
In-Reply-To: <20110806000257.GA25498@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Wolfgang Denk <wd@denx.de>

commit 026dfaf18973404a01f488d6aa556a8c466e06a4 upstream.

Add ID 4348:5523 for WinChipHead USB->RS 232 adapter with
Prolifec PL2303 chipset

Signed-off-by: Wolfgang Denk <wd@denx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/serial/pl2303.c |    1 +
 drivers/usb/serial/pl2303.h |    4 ++++
 2 files changed, 5 insertions(+)

--- a/drivers/usb/serial/pl2303.c
+++ b/drivers/usb/serial/pl2303.c
@@ -101,6 +101,7 @@ static struct usb_device_id id_table []
 	{ USB_DEVICE(SONY_VENDOR_ID, SONY_QN3USB_PRODUCT_ID) },
 	{ USB_DEVICE(SANWA_VENDOR_ID, SANWA_PRODUCT_ID) },
 	{ USB_DEVICE(ADLINK_VENDOR_ID, ADLINK_ND6530_PRODUCT_ID) },
+	{ USB_DEVICE(WINCHIPHEAD_VENDOR_ID, WINCHIPHEAD_USBSER_PRODUCT_ID) },
 	{ }					/* Terminating entry */
 };
 
--- a/drivers/usb/serial/pl2303.h
+++ b/drivers/usb/serial/pl2303.h
@@ -144,3 +144,7 @@
 /* ADLINK ND-6530 RS232,RS485 and RS422 adapter */
 #define ADLINK_VENDOR_ID		0x0b63
 #define ADLINK_ND6530_PRODUCT_ID	0x6530
+
+/* WinChipHead USB->RS 232 adapter */
+#define WINCHIPHEAD_VENDOR_ID		0x4348
+#define WINCHIPHEAD_USBSER_PRODUCT_ID	0x5523


