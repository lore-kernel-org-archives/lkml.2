Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753308Ab1KAJa7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 05:30:59 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:47964 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752861Ab1KAJa4 (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:0:0>);
	Tue, 1 Nov 2011 05:30:56 -0400
From: "Cho, Yu-Chen" <acho@suse.com>
To: marcel@holtmann.org, padovan@profusion.mobi,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: acho@novell.com, jlee@novell.com, oneukum@suse.com, acho@suse.com,
        jlee@suse.com
Subject: [PATCH 2/3] fix device id for Broadcom SoftSailing
Date: Tue,  1 Nov 2011 17:33:06 +0800
Message-Id: <441ba580885def5ff35d1172e265566c1870a60c.1320139612.git.acho@suse.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <944af9667334f5677be87e89fe8f38486823cc95.1320139612.git.acho@suse.com>
References: <944af9667334f5677be87e89fe8f38486823cc95.1320139612.git.acho@suse.com>
In-Reply-To: <944af9667334f5677be87e89fe8f38486823cc95.1320139612.git.acho@suse.com>
References: <944af9667334f5677be87e89fe8f38486823cc95.1320139612.git.acho@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed the device VID:PID typo 05ac:21e1 to 0a5c:21e1

Signed-off-by: Cho, Yu-Chen <acho@suse.com>
---
 drivers/bluetooth/btusb.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index be01260..8583aee 100644
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
+	{ USB_DEVICE(0x0a5c, 0x21e1) },
 	/* Broadcom Valentine 802.11bgn 1x1 Combo HMC */
 	{ USB_DEVICE(0x0a5c, 0x21e3) },
 
-- 
1.7.3.4

