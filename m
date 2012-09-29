Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756744Ab2I2F7B (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Sep 2012 01:59:01 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:55597 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754150Ab2I2F7A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Sep 2012 01:59:00 -0400
From: Quinlan Pfiffer <qpfiffer@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Linux USB <linux-usb@vger.kernel.org>,
        Networking Drivers <netdev@vger.kernel.org>,
        linux-kernel@vger.kernel.org, Quinlan Pfiffer <qpfiffer@gmail.com>
Subject: [PATCH 1/1] Adds support for Lenovo 10/100 USB dongle.
Date: Fri, 28 Sep 2012 22:58:44 -0700
Message-Id: <1348898324-6550-1-git-send-email-qpfiffer@gmail.com>
X-Mailer: git-send-email 1.7.12.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This dongle ships with the X1 Carbon, and has an AX88772B
usb to ethernet chip in it.

Signed-off-by: Quinlan Pfiffer <qpfiffer@gmail.com>
---
 drivers/net/usb/asix_devices.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/usb/asix_devices.c b/drivers/net/usb/asix_devices.c
index 32e31c5..fc20e53 100644
--- a/drivers/net/usb/asix_devices.c
+++ b/drivers/net/usb/asix_devices.c
@@ -930,6 +930,10 @@ static const struct usb_device_id	products [] = {
 	USB_DEVICE (0x04f1, 0x3008),
 	.driver_info = (unsigned long) &ax8817x_info,
 }, {
+	// Lenovo U2L100P 10/100
+	USB_DEVICE (0x17ef, 0x7203),
+	.driver_info = (unsigned long) &ax88772_info,
+}, {
 	// ASIX AX88772B 10/100
 	USB_DEVICE (0x0b95, 0x772b),
 	.driver_info = (unsigned long) &ax88772_info,
-- 
1.7.12.1

