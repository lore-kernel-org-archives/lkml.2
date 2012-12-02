Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753002Ab2LBHgv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2012 02:36:51 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:35679 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751580Ab2LBHgt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2012 02:36:49 -0500
From: "Guillermo A. Amaral" <g@maral.me>
To: dmitry.torokhov@gmail.com
Cc: gregkh@linuxfoundation.org, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, "Guillermo A. Amaral" <g@maral.me>
Subject: [PATCH 1/2] Input: xpad - Minor coding style errors fixed.
Date: Sat,  1 Dec 2012 23:36:19 -0800
Message-Id: <1354433779-16274-1-git-send-email-g@maral.me>
X-Mailer: git-send-email 1.7.8.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Guillermo A. Amaral" <g@maral.me>

Fixed a few minor coding style issues in xpad driver.

Signed-off-by: "Guillermo A. Amaral B." <g@maral.me>
---
 drivers/input/joystick/xpad.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/input/joystick/xpad.c b/drivers/input/joystick/xpad.c
index 83811e4..3d8f39b 100644
--- a/drivers/input/joystick/xpad.c
+++ b/drivers/input/joystick/xpad.c
@@ -235,7 +235,7 @@ static const signed short xpad_abs_triggers[] = {
 	{ XPAD_XBOX360_VENDOR_PROTOCOL(vend,1) }, \
 	{ XPAD_XBOX360_VENDOR_PROTOCOL(vend,129) }
 
-static struct usb_device_id xpad_table [] = {
+static struct usb_device_id xpad_table[] = {
 	{ USB_INTERFACE_INFO('X', 'B', 0) },	/* X-Box USB-IF not approved class */
 	XPAD_XBOX360_VENDOR(0x045e),		/* Microsoft X-Box 360 controllers */
 	XPAD_XBOX360_VENDOR(0x046d),		/* Logitech X-Box 360 style controllers */
@@ -251,7 +251,7 @@ static struct usb_device_id xpad_table [] = {
 	{ }
 };
 
-MODULE_DEVICE_TABLE (usb, xpad_table);
+MODULE_DEVICE_TABLE(usb, xpad_table);
 
 struct usb_xpad {
 	struct input_dev *dev;		/* input device interface */
@@ -783,7 +783,7 @@ static int xpad_open(struct input_dev *dev)
 	struct usb_xpad *xpad = input_get_drvdata(dev);
 
 	/* URB was submitted in probe */
-	if(xpad->xtype == XTYPE_XBOX360W)
+	if (xpad->xtype == XTYPE_XBOX360W)
 		return 0;
 
 	xpad->irq_in->dev = xpad->udev;
-- 
1.7.8.6

