Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932135Ab2HOUVe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 16:21:34 -0400
Received: from mail1.windriver.com ([147.11.146.13]:62932 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756655Ab2HOTuq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 15:50:46 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Eric Benoit <eric@ecks.ca>, Greg Kroah-Hartman <gregkh@suse.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 076/165] USB: pl2303: add id for SMART device
Date: Wed, 15 Aug 2012 15:47:00 -0400
Message-ID: <1345060109-9187-77-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.12.rc2
In-Reply-To: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com>
References: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Benoit <eric@ecks.ca>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 598f0b703506da841d3459dc0c48506be14d1778 upstream.

Add vendor and product ID for the SMART USB to serial adapter. These
were meant to be used with their SMART Board whiteboards, but can be
re-purposed for other tasks. Tested and working (at at least 9600 bps).

Signed-off-by: Eric Benoit <eric@ecks.ca>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/usb/serial/pl2303.c | 1 +
 drivers/usb/serial/pl2303.h | 4 ++++
 2 files changed, 5 insertions(+)

diff --git a/drivers/usb/serial/pl2303.c b/drivers/usb/serial/pl2303.c
index 9f49375..e42ee9b 100644
--- a/drivers/usb/serial/pl2303.c
+++ b/drivers/usb/serial/pl2303.c
@@ -102,6 +102,7 @@ static const struct usb_device_id id_table[] = {
 	{ USB_DEVICE(SANWA_VENDOR_ID, SANWA_PRODUCT_ID) },
 	{ USB_DEVICE(ADLINK_VENDOR_ID, ADLINK_ND6530_PRODUCT_ID) },
 	{ USB_DEVICE(WINCHIPHEAD_VENDOR_ID, WINCHIPHEAD_USBSER_PRODUCT_ID) },
+	{ USB_DEVICE(SMART_VENDOR_ID, SMART_PRODUCT_ID) },
 	{ }					/* Terminating entry */
 };
 
diff --git a/drivers/usb/serial/pl2303.h b/drivers/usb/serial/pl2303.h
index ca0d237..450a4a7 100644
--- a/drivers/usb/serial/pl2303.h
+++ b/drivers/usb/serial/pl2303.h
@@ -148,3 +148,7 @@
 /* WinChipHead USB->RS 232 adapter */
 #define WINCHIPHEAD_VENDOR_ID		0x4348
 #define WINCHIPHEAD_USBSER_PRODUCT_ID	0x5523
+
+/* SMART USB Serial Adapter */
+#define SMART_VENDOR_ID	0x0b8c
+#define SMART_PRODUCT_ID	0x2303
-- 
1.7.12.rc2

