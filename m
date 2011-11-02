Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752612Ab1KCBwH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 21:52:07 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51325 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934627Ab1KCBlh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 21:41:37 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  2 15:27:45 2011
Message-Id: <20111102222745.693997764@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 02 Nov 2011 15:26:49 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Eric Benoit <eric@ecks.ca>
Subject: [065/101] USB: pl2303: add id for SMART device
In-Reply-To: <20111102222755.GA10893@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-longterm review patch.  If anyone has any objections, please let us know.

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
@@ -101,6 +101,7 @@ static struct usb_device_id id_table []
 	{ USB_DEVICE(SANWA_VENDOR_ID, SANWA_PRODUCT_ID) },
 	{ USB_DEVICE(ADLINK_VENDOR_ID, ADLINK_ND6530_PRODUCT_ID) },
 	{ USB_DEVICE(WINCHIPHEAD_VENDOR_ID, WINCHIPHEAD_USBSER_PRODUCT_ID) },
+	{ USB_DEVICE(SMART_VENDOR_ID, SMART_PRODUCT_ID) },
 	{ }					/* Terminating entry */
 };
 
--- a/drivers/usb/serial/pl2303.h
+++ b/drivers/usb/serial/pl2303.h
@@ -144,3 +144,8 @@
 /* WinChipHead USB->RS 232 adapter */
 #define WINCHIPHEAD_VENDOR_ID		0x4348
 #define WINCHIPHEAD_USBSER_PRODUCT_ID	0x5523
+
+/* SMART USB Serial Adapter */
+#define SMART_VENDOR_ID	0x0b8c
+#define SMART_PRODUCT_ID	0x2303
+


