Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934019Ab1KJDWP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 22:22:15 -0500
Received: from cantor2.suse.de ([195.135.220.15]:41803 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933979Ab1KJDWK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 22:22:10 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  9 13:27:05 2011
Message-Id: <20111109212705.338784348@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 09 Nov 2011 13:26:12 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Eric Benoit <eric@ecks.ca>
Subject: [050/262] USB: pl2303: add id for SMART device
In-Reply-To: <20111109212847.GA20838@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Benoit <eric@ecks.ca>

commit 598f0b703506da841d3459dc0c48506be14d1778 upstream.

Add vendor and product ID for the SMART USB to serial adapter. These
were meant to be used with their SMART Board whiteboards, but can be
re-purposed for other tasks. Tested and working (at at least 9600 bps).

Signed-off-by: Eric Benoit <eric@ecks.ca>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/serial/pl2303.c |    1 +
 drivers/usb/serial/pl2303.h |    5 +++++
 2 files changed, 6 insertions(+)

--- a/drivers/usb/serial/pl2303.c
+++ b/drivers/usb/serial/pl2303.c
@@ -92,6 +92,7 @@ static const struct usb_device_id id_tab
 	{ USB_DEVICE(SANWA_VENDOR_ID, SANWA_PRODUCT_ID) },
 	{ USB_DEVICE(ADLINK_VENDOR_ID, ADLINK_ND6530_PRODUCT_ID) },
 	{ USB_DEVICE(WINCHIPHEAD_VENDOR_ID, WINCHIPHEAD_USBSER_PRODUCT_ID) },
+	{ USB_DEVICE(SMART_VENDOR_ID, SMART_PRODUCT_ID) },
 	{ }					/* Terminating entry */
 };
 
--- a/drivers/usb/serial/pl2303.h
+++ b/drivers/usb/serial/pl2303.h
@@ -148,3 +148,8 @@
 /* WinChipHead USB->RS 232 adapter */
 #define WINCHIPHEAD_VENDOR_ID		0x4348
 #define WINCHIPHEAD_USBSER_PRODUCT_ID	0x5523
+
+/* SMART USB Serial Adapter */
+#define SMART_VENDOR_ID	0x0b8c
+#define SMART_PRODUCT_ID	0x2303
+


