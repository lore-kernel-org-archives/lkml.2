Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935039Ab1KJD3A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 22:29:00 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42569 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935027Ab1KJD24 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 22:28:56 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  9 13:27:17 2011
Message-Id: <20111109212717.265555710@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 09 Nov 2011 13:28:08 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Florian Echtler <floe@butterbrot.org>
Subject: [166/262] USB: Serial: Add device ID for Sierra Wireless MC8305
In-Reply-To: <20111109212847.GA20838@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Florian Echtler <floe@butterbrot.org>

commit 2f1def2695c223b2aa325e5e47d0d64200a45d23 upstream.

A new device ID pair is added for Sierra Wireless MC8305.

Signed-off-by: Florian Echtler <floe@butterbrot.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/serial/qcserial.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/serial/qcserial.c
+++ b/drivers/usb/serial/qcserial.c
@@ -80,6 +80,7 @@ static const struct usb_device_id id_tab
 	{USB_DEVICE(0x1199, 0x9008)},	/* Sierra Wireless Gobi 2000 Modem device (VT773) */
 	{USB_DEVICE(0x1199, 0x9009)},	/* Sierra Wireless Gobi 2000 Modem device (VT773) */
 	{USB_DEVICE(0x1199, 0x900a)},	/* Sierra Wireless Gobi 2000 Modem device (VT773) */
+	{USB_DEVICE(0x1199, 0x9011)},   /* Sierra Wireless Gobi 2000 Modem device (MC8305) */
 	{USB_DEVICE(0x16d8, 0x8001)},	/* CMDTech Gobi 2000 QDL device (VU922) */
 	{USB_DEVICE(0x16d8, 0x8002)},	/* CMDTech Gobi 2000 Modem device (VU922) */
 	{USB_DEVICE(0x05c6, 0x9204)},	/* Gobi 2000 QDL device */


