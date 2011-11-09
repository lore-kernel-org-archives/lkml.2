Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751993Ab1KJFBF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 00:01:05 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42649 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935107Ab1KJD3i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 22:29:38 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  9 13:27:18 2011
Message-Id: <20111109212718.346514611@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 09 Nov 2011 13:28:19 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Jurgen Kramer <gtmkramer@xs4all.nl>,
        "Gustavo F. Padovan" <padovan@profusion.mobi>
Subject: [177/262] Bluetooth: add support for 2011 mac mini
In-Reply-To: <20111109212847.GA20838@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jurgen Kramer <gtmkramer@xs4all.nl>

commit f78b68261e80899f81a21dfdf91e2a1456ea8175 upstream.

Today I noticed that the usb bluetooth adapter (BCM2046B1) on my 2011
mac mini was not working. I've created a patch to get it going.

Signed-off-by: Jurgen Kramer <gtmkramer@xs4all.nl>
Signed-off-by: Gustavo F. Padovan <padovan@profusion.mobi>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/bluetooth/btusb.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -78,6 +78,9 @@ static struct usb_device_id btusb_table[
 	/* Apple MacBookPro8,2 */
 	{ USB_DEVICE(0x05ac, 0x821a) },
 
+	/* Apple MacMini5,1 */
+	{ USB_DEVICE(0x05ac, 0x8281) },
+
 	/* AVM BlueFRITZ! USB v2.0 */
 	{ USB_DEVICE(0x057c, 0x3800) },
 


