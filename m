Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757235Ab0C3Xn0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 19:43:26 -0400
Received: from kroah.org ([198.145.64.141]:46184 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932578Ab0C3XUV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 19:20:21 -0400
X-Mailbox-Line: From linux@linux.site Tue Mar 30 15:48:06 2010
Message-Id: <20100330224806.004805043@linux.site>
User-Agent: quilt/0.47-14.9
Date: Tue, 30 Mar 2010 15:41:44 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Bernhard Rosenkraenzer <bero@arklinux.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [070/156] USB: qcserial: add new device ids
In-Reply-To: <20100330230630.GA28824@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Bernhard Rosenkraenzer <br@blankpage.ch>

commit 0725e95ea56698774e893edb7e7276b1d6890954 upstream.

This patch adds various USB device IDs for Gobi 2000 devices, as found in the
drivers available at https://www.codeaurora.org/wiki/GOBI_Releases

Signed-off-by: Bernhard Rosenkraenzer <bero@arklinux.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/serial/qcserial.c |   29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

--- a/drivers/usb/serial/qcserial.c
+++ b/drivers/usb/serial/qcserial.c
@@ -47,6 +47,35 @@ static struct usb_device_id id_table[] =
 	{USB_DEVICE(0x05c6, 0x9221)},	/* Generic Gobi QDL device */
 	{USB_DEVICE(0x05c6, 0x9231)},	/* Generic Gobi QDL device */
 	{USB_DEVICE(0x1f45, 0x0001)},	/* Unknown Gobi QDL device */
+	{USB_DEVICE(0x413c, 0x8185)},	/* Dell Gobi 2000 QDL device (N0218, VU936) */
+	{USB_DEVICE(0x413c, 0x8186)},	/* Dell Gobi 2000 Modem device (N0218, VU936) */
+	{USB_DEVICE(0x05c6, 0x9224)},	/* Sony Gobi 2000 QDL device (N0279, VU730) */
+	{USB_DEVICE(0x05c6, 0x9225)},	/* Sony Gobi 2000 Modem device (N0279, VU730) */
+	{USB_DEVICE(0x05c6, 0x9244)},	/* Samsung Gobi 2000 QDL device (VL176) */
+	{USB_DEVICE(0x05c6, 0x9245)},	/* Samsung Gobi 2000 Modem device (VL176) */
+	{USB_DEVICE(0x03f0, 0x241d)},	/* HP Gobi 2000 QDL device (VP412) */
+	{USB_DEVICE(0x03f0, 0x251d)},	/* HP Gobi 2000 Modem device (VP412) */
+	{USB_DEVICE(0x05c6, 0x9214)},	/* Acer Gobi 2000 QDL device (VP413) */
+	{USB_DEVICE(0x05c6, 0x9215)},	/* Acer Gobi 2000 Modem device (VP413) */
+	{USB_DEVICE(0x05c6, 0x9264)},	/* Asus Gobi 2000 QDL device (VR305) */
+	{USB_DEVICE(0x05c6, 0x9265)},	/* Asus Gobi 2000 Modem device (VR305) */
+	{USB_DEVICE(0x05c6, 0x9234)},	/* Top Global Gobi 2000 QDL device (VR306) */
+	{USB_DEVICE(0x05c6, 0x9235)},	/* Top Global Gobi 2000 Modem device (VR306) */
+	{USB_DEVICE(0x05c6, 0x9274)},	/* iRex Technologies Gobi 2000 QDL device (VR307) */
+	{USB_DEVICE(0x05c6, 0x9275)},	/* iRex Technologies Gobi 2000 Modem device (VR307) */
+	{USB_DEVICE(0x1199, 0x9000)},	/* Sierra Wireless Gobi 2000 QDL device (VT773) */
+	{USB_DEVICE(0x1199, 0x9001)},	/* Sierra Wireless Gobi 2000 Modem device (VT773) */
+	{USB_DEVICE(0x1199, 0x9002)},	/* Sierra Wireless Gobi 2000 Modem device (VT773) */
+	{USB_DEVICE(0x1199, 0x9003)},	/* Sierra Wireless Gobi 2000 Modem device (VT773) */
+	{USB_DEVICE(0x1199, 0x9004)},	/* Sierra Wireless Gobi 2000 Modem device (VT773) */
+	{USB_DEVICE(0x1199, 0x9005)},	/* Sierra Wireless Gobi 2000 Modem device (VT773) */
+	{USB_DEVICE(0x1199, 0x9006)},	/* Sierra Wireless Gobi 2000 Modem device (VT773) */
+	{USB_DEVICE(0x1199, 0x9007)},	/* Sierra Wireless Gobi 2000 Modem device (VT773) */
+	{USB_DEVICE(0x1199, 0x9008)},	/* Sierra Wireless Gobi 2000 Modem device (VT773) */
+	{USB_DEVICE(0x1199, 0x9009)},	/* Sierra Wireless Gobi 2000 Modem device (VT773) */
+	{USB_DEVICE(0x1199, 0x900a)},	/* Sierra Wireless Gobi 2000 Modem device (VT773) */
+	{USB_DEVICE(0x16d8, 0x8001)},	/* CMDTech Gobi 2000 QDL device (VU922) */
+	{USB_DEVICE(0x16d8, 0x8002)},	/* CMDTech Gobi 2000 Modem device (VU922) */
 	{ }				/* Terminating entry */
 };
 MODULE_DEVICE_TABLE(usb, id_table);


