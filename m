Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753541Ab1KAJbO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 05:31:14 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:52200 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752590Ab1KAJbL (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:0:0>);
	Tue, 1 Nov 2011 05:31:11 -0400
From: "Cho, Yu-Chen" <acho@suse.com>
To: marcel@holtmann.org, padovan@profusion.mobi,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: acho@novell.com, jlee@novell.com, oneukum@suse.com, acho@suse.com,
        jlee@suse.com
Subject: [PATCH 3/3] add device entry for other Broadcom combo card
Date: Tue,  1 Nov 2011 17:33:07 +0800
Message-Id: <6842576afea60f36a866fbf5000195c8cafb99f3.1320139612.git.acho@suse.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <944af9667334f5677be87e89fe8f38486823cc95.1320139612.git.acho@suse.com>
References: <944af9667334f5677be87e89fe8f38486823cc95.1320139612.git.acho@suse.com>
In-Reply-To: <944af9667334f5677be87e89fe8f38486823cc95.1320139612.git.acho@suse.com>
References: <944af9667334f5677be87e89fe8f38486823cc95.1320139612.git.acho@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Those devices declare themselves to be vendor specific
It therefore needs to be added to the device table
to make btusb bind.

Signed-off-by: Cho, Yu-Chen <acho@suse.com>
---
 drivers/bluetooth/btusb.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index 8583aee..bc8f850 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -100,6 +100,12 @@ static struct usb_device_id btusb_table[] = {
 	/* Broadcom Valentine 802.11bgn 1x1 Combo HMC */
 	{ USB_DEVICE(0x0a5c, 0x21e3) },
 
+	{ USB_DEVICE(0x03f0, 0x2a1d) },
+	{ USB_DEVICE(0x03f0, 0x231d) },
+
+	/* BCM2070 Bluetooth 2.1 + EDR */
+	{ USB_DEVICE(0x0a5c, 0x21b4) },
+
 	/* Canyon CN-BTU1 with HID interfaces */
 	{ USB_DEVICE(0x0c10, 0x0000) },
 
-- 
1.7.3.4

