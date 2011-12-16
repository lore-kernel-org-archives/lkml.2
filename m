Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759453Ab1LPQP0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 11:15:26 -0500
Received: from 36-246.206-83.static-ip.oleane.fr ([83.206.246.36]:47318 "EHLO
	mail.technolia.fr" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751991Ab1LPQPU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 11:15:20 -0500
X-Greylist: delayed 1191 seconds by postgrey-1.27 at vger.kernel.org; Fri, 16 Dec 2011 11:15:20 EST
From: Aurelien Jacobs <aurel@gnuage.org>
To: linux-kernel@vger.kernel.org
Cc: Aurelien Jacobs <aurel@gnuage.org>
Subject: [PATCH] asix: new device id
Date: Fri, 16 Dec 2011 16:55:21 +0100
Message-Id: <1324050921-9007-1-git-send-email-aurel@gnuage.org>
X-Mailer: git-send-email 1.7.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adds the device id needed for the USB Ethernet Adapter delivered by
ASUS with their Zenbook.

Signed-off-by: Aurelien Jacobs <aurel@gnuage.org>
---
 drivers/net/usb/asix.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/net/usb/asix.c b/drivers/net/usb/asix.c
index e6fed4d..e95f0e6 100644
--- a/drivers/net/usb/asix.c
+++ b/drivers/net/usb/asix.c
@@ -1655,6 +1655,10 @@ static const struct usb_device_id	products [] = {
 	// ASIX 88772a
 	USB_DEVICE(0x0db0, 0xa877),
 	.driver_info = (unsigned long) &ax88772_info,
+}, {
+	// Asus USB Ethernet Adapter
+	USB_DEVICE (0x0b95, 0x7e2b),
+	.driver_info = (unsigned long) &ax88772_info,
 },
 	{ },		// END
 };
-- 
1.7.7.3

