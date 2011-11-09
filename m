Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935140Ab1KJD3q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 22:29:46 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42652 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934435Ab1KJD3l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 22:29:41 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  9 13:27:18 2011
Message-Id: <20111109212718.444331793@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 09 Nov 2011 13:28:20 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Oliver Neukum <oneukum@suse.de>,
        "Gustavo F. Padovan" <padovan@profusion.mobi>
Subject: [178/262] btusb: add device entry for Broadcom SoftSailing
In-Reply-To: <20111109212847.GA20838@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oliver Neukum <oneukum@suse.de>

commit c510eae377c773241ff0b6369a8f3581da941a51 upstream.


This device declares itself to be vendor specific
It therefore needs to be added to the device table
to make btusb bind.

Signed-off-by: Oliver Neukum <oneukum@suse.de>
Signed-off-by: Gustavo F. Padovan <padovan@profusion.mobi>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/bluetooth/btusb.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -60,6 +60,9 @@ static struct usb_device_id btusb_table[
 	/* Generic Bluetooth USB device */
 	{ USB_DEVICE_INFO(0xe0, 0x01, 0x01) },
 
+	/* Broadcom SoftSailing reporting vendor specific */
+	{ USB_DEVICE(0x05ac, 0x21e1) },
+
 	/* Apple MacBookPro 7,1 */
 	{ USB_DEVICE(0x05ac, 0x8213) },
 


