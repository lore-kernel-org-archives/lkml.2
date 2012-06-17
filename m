Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758916Ab2FQSeQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2012 14:34:16 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:50270 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758180Ab2FQSWn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2012 14:22:43 -0400
Message-Id: <20120617175948.153675246@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 17 Jun 2012 19:00:29 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [ 48/69] USB: qcserial: Add Sierra Wireless device IDs
In-Reply-To: <20120617175941.281333656@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bjørn Mork <bjorn@mork.no>

commit c41444ccfa33a1c20efa319e554cb531576e64a2 upstream.

Some additional IDs found in the BSD/GPL licensed out-of-tree
GobiSerial driver from Sierra Wireless.

Signed-off-by: Bjørn Mork <bjorn@mork.no>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/serial/qcserial.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/usb/serial/qcserial.c b/drivers/usb/serial/qcserial.c
index 0d5fe59..996015c 100644
--- a/drivers/usb/serial/qcserial.c
+++ b/drivers/usb/serial/qcserial.c
@@ -105,7 +105,13 @@ static const struct usb_device_id id_table[] = {
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


