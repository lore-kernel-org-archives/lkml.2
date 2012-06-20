Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932610Ab2FTS10 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 14:27:26 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:43050 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932560Ab2FTSYk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 14:24:40 -0400
Message-Id: <20120620173040.624171049@linuxfoundation.org>
User-Agent: quilt/0.60-20.3
Date: Wed, 20 Jun 2012 10:30:51 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>
Subject: [ 12/20] USB: qcserial: Add Sierra Wireless device IDs
In-Reply-To: <20120620173044.GA6910@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bjørn Mork <bjorn@mork.no>

commit c41444ccfa33a1c20efa319e554cb531576e64a2 upstream.

Some additional IDs found in the BSD/GPL licensed out-of-tree
GobiSerial driver from Sierra Wireless.

Signed-off-by: Bjørn Mork <bjorn@mork.no>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/qcserial.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/usb/serial/qcserial.c
+++ b/drivers/usb/serial/qcserial.c
@@ -104,7 +104,13 @@ static const struct usb_device_id id_tab
 	{USB_DEVICE(0x1410, 0xa021)},	/* Novatel Gobi 3000 Composite */
 	{USB_DEVICE(0x413c, 0x8193)},	/* Dell Gobi 3000 QDL */
 	{USB_DEVICE(0x413c, 0x8194)},	/* Dell Gobi 3000 Composite */
+	{USB_DEVICE(0x1199, 0x9010)},	/* Sierra Wireless Gobi 3000 QDL */
+	{USB_DEVICE(0x1199, 0x9012)},	/* Sierra Wireless Gobi 3000 QDL */
 	{USB_DEVICE(0x1199, 0x9013)},	/* Sierra Wireless Gobi 3000 Modem device (MC8355) */
+	{USB_DEVICE(0x1199, 0x9014)},	/* Sierra Wireless Gobi 3000 QDL */
+	{USB_DEVICE(0x1199, 0x9015)},	/* Sierra Wireless Gobi 3000 Modem device */
+	{USB_DEVICE(0x1199, 0x9018)},	/* Sierra Wireless Gobi 3000 QDL */
+	{USB_DEVICE(0x1199, 0x9019)},	/* Sierra Wireless Gobi 3000 Modem device */
 	{USB_DEVICE(0x12D1, 0x14F0)},	/* Sony Gobi 3000 QDL */
 	{USB_DEVICE(0x12D1, 0x14F1)},	/* Sony Gobi 3000 Composite */
 	{ }				/* Terminating entry */


