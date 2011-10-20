Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753192Ab1JTFRh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Oct 2011 01:17:37 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:45486 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751101Ab1JTFRf (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:0:0>);
	Thu, 20 Oct 2011 01:17:35 -0400
From: "Cho, Yu-Chen" <acho@suse.com>
To: marcel@holtmann.org, padovan@profusion.mobi,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: acho@novell.com, jlee@novell.com, oneukum@suse.com,
        "Cho, Yu-Chen" <acho@suse.com>
Subject: [PATCH 1/2] add device entry for Broadcom Valentine combo card
Date: Thu, 20 Oct 2011 12:58:29 +0800
Message-Id: <2eb6d1b761a3fddea28294959bde7e9c7ef88043.1319086508.git.acho@suse.com>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This device declares itself to be vendor specific
It therefore needs to be added to the device table
to make btusb bind.

Signed-off-by: Cho, Yu-Chen <acho@suse.com>
---
 drivers/bluetooth/btusb.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index abfc4ee..5893ba4 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -97,6 +97,10 @@ static struct usb_device_id btusb_table[] = {
 	/* Ericsson with non-standard id */
 	{ USB_DEVICE(0x0bdb, 0x1002) },
 
+	/* Broadcom 20702 Bluetooth 4.0 Adapter */
+	/* Broadcom Valentine 802.11bgn 1x1 Combo HMC */
+	{ USB_DEVICE(0xa5c, 0x21e3) },
+
 	/* Canyon CN-BTU1 with HID interfaces */
 	{ USB_DEVICE(0x0c10, 0x0000) },
 
-- 
1.7.3.4

