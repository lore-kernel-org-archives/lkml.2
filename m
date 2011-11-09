Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935128Ab1KJD3n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 22:29:43 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42619 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934672Ab1KJD32 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 22:29:28 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  9 13:27:18 2011
Message-Id: <20111109212718.055277414@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 09 Nov 2011 13:28:16 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Pieter-Augustijn Van Malleghem <p-a@scarlet.be>,
        "Gustavo F. Padovan" <padovan@profusion.mobi>
Subject: [174/262] Bluetooth: Add MacBookAir4,1 support
In-Reply-To: <20111109212847.GA20838@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pieter-Augustijn Van Malleghem <p-a@scarlet.be>

commit a63b723d02531f7add0b2b8a0e6a77ee176f1626 upstream.

This patch against current git adds the hardware ID for the Apple
MacBookAir4,1, released in July 2011. The device features a BCM2046
USB chip. The patch was inspired by the previous modifications adding
support for the MacBookAir3,x.

Signed-off-by: Pieter-Augustijn Van Malleghem <p-a@scarlet.be>
Signed-off-by: Gustavo F. Padovan <padovan@profusion.mobi>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/bluetooth/btusb.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -71,6 +71,9 @@ static struct usb_device_id btusb_table[
 	/* Apple MacBookAir3,1, MacBookAir3,2 */
 	{ USB_DEVICE(0x05ac, 0x821b) },
 
+	/* Apple MacBookAir4,1 */
+	{ USB_DEVICE(0x05ac, 0x821f) },
+
 	/* Apple MacBookPro8,2 */
 	{ USB_DEVICE(0x05ac, 0x821a) },
 


