Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754766Ab2JNOts (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2012 10:49:48 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46748 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932414Ab2JNOoP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2012 10:44:15 -0400
Message-Id: <20121014143538.421735414@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 14 Oct 2012 15:36:07 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Gustavo Padovan <gustavo.padovan@collabora.co.uk>
Subject: [ 034/147] Bluetooth: Add USB_VENDOR_AND_INTERFACE_INFO() for Broadcom/Foxconn
In-Reply-To: <20121014143533.742627615@decadent.org.uk>
X-SA-Exim-Connect-IP: 77.75.106.1
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gustavo Padovan <gustavo.padovan@collabora.co.uk>

commit ee66401bb94b1f2ce51089c341dcdd25d26ae631 upstream.

Foxconn devices has a vendor specific class of device, we will match them
differently now.

Signed-off-by: Gustavo Padovan <gustavo.padovan@collabora.co.uk>
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/bluetooth/btusb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -108,7 +108,7 @@ static struct usb_device_id btusb_table[
 	{ USB_DEVICE(0x413c, 0x8197) },
 
 	/* Foxconn - Hon Hai */
-	{ USB_DEVICE(0x0489, 0xe033) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(0x0489, 0xff, 0x01, 0x01) },
 
 	/*Broadcom devices with vendor specific id */
 	{ USB_VENDOR_AND_INTERFACE_INFO(0x0a5c, 0xff, 0x01, 0x01) },


