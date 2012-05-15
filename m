Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965311Ab2EOCnd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 22:43:33 -0400
Received: from mail.windriver.com ([147.11.1.11]:49756 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965101Ab2EOCRi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 22:17:38 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [34-longterm 120/179] USB: serial: add IDs for WinChipHead USB->RS232 adapter
Date: Mon, 14 May 2012 22:13:36 -0400
Message-ID: <1337048075-6132-121-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.6
In-Reply-To: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
References: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wolfgang Denk <wd@denx.de>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 026dfaf18973404a01f488d6aa556a8c466e06a4 upstream.

Add ID 4348:5523 for WinChipHead USB->RS 232 adapter with
Prolifec PL2303 chipset

Signed-off-by: Wolfgang Denk <wd@denx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/usb/serial/pl2303.c |    1 +
 drivers/usb/serial/pl2303.h |    4 ++++
 2 files changed, 5 insertions(+)

diff --git a/drivers/usb/serial/pl2303.c b/drivers/usb/serial/pl2303.c
index eb7d1ce..4b357d6 100644
--- a/drivers/usb/serial/pl2303.c
+++ b/drivers/usb/serial/pl2303.c
@@ -101,6 +101,7 @@ static const struct usb_device_id id_table[] = {
 	{ USB_DEVICE(SONY_VENDOR_ID, SONY_QN3USB_PRODUCT_ID) },
 	{ USB_DEVICE(SANWA_VENDOR_ID, SANWA_PRODUCT_ID) },
 	{ USB_DEVICE(ADLINK_VENDOR_ID, ADLINK_ND6530_PRODUCT_ID) },
+	{ USB_DEVICE(WINCHIPHEAD_VENDOR_ID, WINCHIPHEAD_USBSER_PRODUCT_ID) },
 	{ }					/* Terminating entry */
 };
 
diff --git a/drivers/usb/serial/pl2303.h b/drivers/usb/serial/pl2303.h
index 1b025f7..ca0d237 100644
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
-- 
1.7.9.6

