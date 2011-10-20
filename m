Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753044Ab1JTE5I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Oct 2011 00:57:08 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:41197 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751101Ab1JTE5G (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:0:0>);
	Thu, 20 Oct 2011 00:57:06 -0400
From: "Cho, Yu-Chen" <acho@suse.com>
To: marcel@holtmann.org, padovan@profusion.mobi,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: acho@novell.com, jlee@novell.com, oneukum@suse.com,
        "Cho, Yu-Chen" <acho@suse.com>
Subject: [PATCH 2/2] fix device id for Broadcom SoftSailing
Date: Thu, 20 Oct 2011 12:58:30 +0800
Message-Id: <588a371b8ea7ca230776ca2ec62412501b532ebd.1319086508.git.acho@suse.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <2eb6d1b761a3fddea28294959bde7e9c7ef88043.1319086508.git.acho@suse.com>
References: <2eb6d1b761a3fddea28294959bde7e9c7ef88043.1319086508.git.acho@suse.com>
In-Reply-To: <2eb6d1b761a3fddea28294959bde7e9c7ef88043.1319086508.git.acho@suse.com>
References: <2eb6d1b761a3fddea28294959bde7e9c7ef88043.1319086508.git.acho@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed the device VID:PID typo 05ac:21e1 to 0a5c:21e1

Signed-off-by: Cho, Yu-Chen <acho@suse.com>
---
 drivers/bluetooth/btusb.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index 5893ba4..1877e91 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -60,9 +60,6 @@ static struct usb_device_id btusb_table[] = {
 	/* Generic Bluetooth USB device */
 	{ USB_DEVICE_INFO(0xe0, 0x01, 0x01) },
 
-	/* Broadcom SoftSailing reporting vendor specific */
-	{ USB_DEVICE(0x05ac, 0x21e1) },
-
 	/* Apple MacBookPro 7,1 */
 	{ USB_DEVICE(0x05ac, 0x8213) },
 
@@ -98,6 +95,8 @@ static struct usb_device_id btusb_table[] = {
 	{ USB_DEVICE(0x0bdb, 0x1002) },
 
 	/* Broadcom 20702 Bluetooth 4.0 Adapter */
+	/* Broadcom SoftSailing reporting vendor specific */
+	{ USB_DEVICE(0xa5c, 0x21e1) },
 	/* Broadcom Valentine 802.11bgn 1x1 Combo HMC */
 	{ USB_DEVICE(0xa5c, 0x21e3) },
 
-- 
1.7.3.4

