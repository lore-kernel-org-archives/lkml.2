Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935800Ab1KJDfI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 22:35:08 -0500
Received: from cantor2.suse.de ([195.135.220.15]:43332 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935608Ab1KJDfB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 22:35:01 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  9 13:31:43 2011
Message-Id: <20111109213143.340134277@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 09 Nov 2011 13:30:59 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Richard Hartmann <richih.mailinglist@gmail.com>
Subject: [012/264] USB: qcserial: Add support for Sierra Wireless MC8355/Gobi 3000
In-Reply-To: <20111109213508.GA3476@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Richard Hartmann <richih.mailinglist@gmail.com>

commit 68c79e5756903229fa96826a2493c2265a3b395f upstream.

Simple patch to make qcserial recognize the USB id of the Sierra
Wireless MC8355 which is based on the Gobi 3000 chip.

Both UMTS and GPS work fine.

Signed-off-by: Richard Hartmann <richih.mailinglist@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/serial/qcserial.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/serial/qcserial.c
+++ b/drivers/usb/serial/qcserial.c
@@ -84,6 +84,7 @@ static const struct usb_device_id id_tab
 	{USB_DEVICE(0x16d8, 0x8002)},	/* CMDTech Gobi 2000 Modem device (VU922) */
 	{USB_DEVICE(0x05c6, 0x9204)},	/* Gobi 2000 QDL device */
 	{USB_DEVICE(0x05c6, 0x9205)},	/* Gobi 2000 Modem device */
+	{USB_DEVICE(0x1199, 0x9013)},	/* Sierra Wireless Gobi 3000 Modem device (MC8355) */
 	{ }				/* Terminating entry */
 };
 MODULE_DEVICE_TABLE(usb, id_table);


