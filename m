Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934743Ab2C3VEf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 17:04:35 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:37370 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934543Ab2C3VEQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 17:04:16 -0400
Message-Id: <20120330195725.561573050@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 30 Mar 2012 12:57:46 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Thomas Tuttle <ttuttle@chromium.org>
Subject: [ 024/108] USB: qcserial: add several new serial devices
In-Reply-To: <20120330195812.GA31833@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Tuttle <ttuttle@chromium.org>

commit 2db4d87070e87d198ab630e66a898b45eff316d9 upstream.

Signed-off-by: Thomas Tuttle <ttuttle@chromium.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/serial/qcserial.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

--- a/drivers/usb/serial/qcserial.c
+++ b/drivers/usb/serial/qcserial.c
@@ -35,6 +35,11 @@ static const struct usb_device_id id_tab
 	{USB_DEVICE(0x413c, 0x8171)},	/* Dell Gobi QDL device */
 	{USB_DEVICE(0x1410, 0xa001)},	/* Novatel Gobi Modem device */
 	{USB_DEVICE(0x1410, 0xa008)},	/* Novatel Gobi QDL device */
+	{USB_DEVICE(0x1410, 0xa010)},	/* Novatel Gobi QDL device */
+	{USB_DEVICE(0x1410, 0xa011)},	/* Novatel Gobi QDL device */
+	{USB_DEVICE(0x1410, 0xa012)},	/* Novatel Gobi QDL device */
+	{USB_DEVICE(0x1410, 0xa013)},	/* Novatel Gobi QDL device */
+	{USB_DEVICE(0x1410, 0xa014)},	/* Novatel Gobi QDL device */
 	{USB_DEVICE(0x0b05, 0x1776)},	/* Asus Gobi Modem device */
 	{USB_DEVICE(0x0b05, 0x1774)},	/* Asus Gobi QDL device */
 	{USB_DEVICE(0x19d2, 0xfff3)},	/* ONDA Gobi Modem device */
@@ -85,7 +90,16 @@ static const struct usb_device_id id_tab
 	{USB_DEVICE(0x16d8, 0x8002)},	/* CMDTech Gobi 2000 Modem device (VU922) */
 	{USB_DEVICE(0x05c6, 0x9204)},	/* Gobi 2000 QDL device */
 	{USB_DEVICE(0x05c6, 0x9205)},	/* Gobi 2000 Modem device */
+
+	{USB_DEVICE(0x05c6, 0x920c)},	/* Gobi 3000 QDL */
+	{USB_DEVICE(0x05c6, 0x920d)},	/* Gobi 3000 Composite */
+	{USB_DEVICE(0x1410, 0xa020)},   /* Novatel Gobi 3000 QDL */
+	{USB_DEVICE(0x1410, 0xa021)},	/* Novatel Gobi 3000 Composite */
+	{USB_DEVICE(0x413c, 0x8193)},	/* Dell Gobi 3000 QDL */
+	{USB_DEVICE(0x413c, 0x8194)},	/* Dell Gobi 3000 Composite */
 	{USB_DEVICE(0x1199, 0x9013)},	/* Sierra Wireless Gobi 3000 Modem device (MC8355) */
+	{USB_DEVICE(0x12D1, 0x14F0)},	/* Sony Gobi 3000 QDL */
+	{USB_DEVICE(0x12D1, 0x14F1)},	/* Sony Gobi 3000 Composite */
 	{ }				/* Terminating entry */
 };
 MODULE_DEVICE_TABLE(usb, id_table);


