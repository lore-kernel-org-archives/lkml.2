Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752223Ab2GIRxO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 13:53:14 -0400
Received: from csmtp3.one.com ([91.198.169.23]:11793 "EHLO csmtp3.one.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751509Ab2GIRxN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 13:53:13 -0400
From: "Henrik Rydberg" <rydberg@bitmath.se>
To: Gustavo Padovan <gustavo@padovan.org>
Cc: linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        Henrik Rydberg <rydberg@euromail.se>
Subject: [PATCH] Bluetooth: Add MacBookPro10,1 support
Date: Mon,  9 Jul 2012 19:52:27 +0200
Message-Id: <1341856347-257-1-git-send-email-rydberg@euromail.se>
X-Mailer: git-send-email 1.7.11.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for the 2012 15'' MacBook Pro Retina.

Patch originally written by clipcarl (forums.opensuse.org).

Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
---
Hi Gustavo,

This patch adds support for the new retina. Picked up from the suse
forum. Getting it into 3.5 would be great, if possible.

Cheers,
Henrik

 drivers/bluetooth/btusb.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index 83ebb24..6cc54da 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -84,6 +84,9 @@ static struct usb_device_id btusb_table[] = {
 	/* Apple MacMini5,1 */
 	{ USB_DEVICE(0x05ac, 0x8281) },
 
+	/* Apple MacBookPro10,1 */
+	{ USB_DEVICE(0x05ac, 0x8286) },
+
 	/* AVM BlueFRITZ! USB v2.0 */
 	{ USB_DEVICE(0x057c, 0x3800) },
 
-- 
1.7.11.1

