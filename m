Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932440Ab1DLOp3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 10:45:29 -0400
Received: from kroah.org ([198.145.64.141]:57725 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932360Ab1DLOih (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 10:38:37 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Apr 12 07:35:56 2011
Message-Id: <20110412143556.085500585@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Tue, 12 Apr 2011 07:35:05 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Marc-Antoine Perennou <Marc-Antoine@Perennou.com>,
        "Gustavo F. Padovan" <padovan@profusion.mobi>
Subject: [076/105] Bluetooth: add support for Apple MacBook Pro 8,2
In-Reply-To: <20110412143613.GA19478@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Marc-Antoine Perennou <Marc-Antoine@Perennou.com>

commit 63a8588debd4dc72becb9e27add9343c76301c7d upstream.

Just adding the vendor details makes it work fine.

Signed-off-by: Marc-Antoine Perennou <Marc-Antoine@Perennou.com>
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
 
+	/* Apple MacBookPro8,2 */
+	{ USB_DEVICE(0x05ac, 0x821a) },
+
 	/* AVM BlueFRITZ! USB v2.0 */
 	{ USB_DEVICE(0x057c, 0x3800) },
 


