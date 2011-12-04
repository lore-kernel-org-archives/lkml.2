Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754636Ab1LDQQt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Dec 2011 11:16:49 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:50208 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754378Ab1LDQQs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Dec 2011 11:16:48 -0500
From: Alexander Kozinko <xcariba@gmail.com>
To: Marcel Holtmann <marcel@holtmann.org>,
        "Gustavo F. Padovan" <padovan@profusion.mobi>,
        linux-kernel@vger.kernel.org
Cc: linux-bluetooth@vger.kernel.org, Alexander Kozinko <xcariba@gmail.com>
Subject: [PATCH 1/1] bluetooth: Fix for new AR3012 embeded modules in Acer Aspire S3 and Asus Zenbook UX31
Date: Sun,  4 Dec 2011 20:16:37 +0400
Message-Id: <1323015397-3017-1-git-send-email-xcariba@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added new ids for embeded bluetooth modules.

Tested on both laptops.

Signed-off-by: Alexander Kozinko <xcariba@gmail.com>
---
 drivers/bluetooth/ath3k.c |    4 ++++
 drivers/bluetooth/btusb.c |    2 ++
 2 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/bluetooth/ath3k.c b/drivers/bluetooth/ath3k.c
index 106beb1..bc3c343 100644
--- a/drivers/bluetooth/ath3k.c
+++ b/drivers/bluetooth/ath3k.c
@@ -70,6 +70,8 @@ static struct usb_device_id ath3k_table[] = {
 
 	/* Atheros AR3012 with sflash firmware*/
 	{ USB_DEVICE(0x0CF3, 0x3004) },
+	{ USB_DEVICE(0x13d3, 0x3375) },
+	{ USB_DEVICE(0x04ca, 0x3004) },
 
 	/* Atheros AR5BBU12 with sflash firmware */
 	{ USB_DEVICE(0x0489, 0xE02C) },
@@ -86,6 +88,8 @@ static struct usb_device_id ath3k_blist_tbl[] = {
 
 	/* Atheros AR3012 with sflash firmware*/
 	{ USB_DEVICE(0x0cf3, 0x3004), .driver_info = BTUSB_ATH3012 },
+	{ USB_DEVICE(0x13d3, 0x3375), .driver_info = BTUSB_ATH3012 },
+	{ USB_DEVICE(0x04ca, 0x3004), .driver_info = BTUSB_ATH3012 },
 
 	{ }	/* Terminating entry */
 };
diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index fe4ebc3..098a743 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -125,6 +125,8 @@ static struct usb_device_id blacklist_table[] = {
 
 	/* Atheros 3012 with sflash firmware */
 	{ USB_DEVICE(0x0cf3, 0x3004), .driver_info = BTUSB_ATH3012 },
+	{ USB_DEVICE(0x13d3, 0x3375), .driver_info = BTUSB_ATH3012 },
+	{ USB_DEVICE(0x04ca, 0x3004), .driver_info = BTUSB_ATH3012 },
 
 	/* Atheros AR5BBU12 with sflash firmware */
 	{ USB_DEVICE(0x0489, 0xe02c), .driver_info = BTUSB_IGNORE },
-- 
1.7.5.4

