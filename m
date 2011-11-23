Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932272Ab1KWAdy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 19:33:54 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42166 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759014Ab1KWAdw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 19:33:52 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Nov 22 16:22:09 2011
Message-Id: <20111123002209.146934568@clark.kroah.org>
User-Agent: quilt/0.48-20.1.2
Date: Tue, 22 Nov 2011 16:21:13 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        sordna <sordna@gmail.com>, Oliver Neukum <oliver@neukum.org>
Subject: [23/25] USB: quirks: adding more quirky webcams to avoid squeaky audio
In-Reply-To: <20111123002222.GA2376@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------
Content-Length: 1917
Lines: 56

From: sordna <sordna@gmail.com>

commit 0d145d7d4a241c321c832a810bb6edad18e2217b upstream.

The following patch contains additional affected webcam models, on top of the
patches commited to linux-next 2394d67e446bf616a0885167d5f0d397bdacfdfc
and 5b253d88cc6c65a23cefc457a5a4ef139913c5fc

Signed-off-by: sordna <sordna@gmail.com>
Cc: Oliver Neukum <oliver@neukum.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/core/quirks.c |   24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

--- a/drivers/usb/core/quirks.c
+++ b/drivers/usb/core/quirks.c
@@ -53,12 +53,36 @@ static const struct usb_device_id usb_qu
 	/* Logitech Webcam Pro 9000 */
 	{ USB_DEVICE(0x046d, 0x0809), .driver_info = USB_QUIRK_RESET_RESUME },
 
+	/* Logitech Webcam C905 */
+	{ USB_DEVICE(0x046d, 0x080a), .driver_info = USB_QUIRK_RESET_RESUME },
+
+	/* Logitech Webcam C210 */
+	{ USB_DEVICE(0x046d, 0x0819), .driver_info = USB_QUIRK_RESET_RESUME },
+
+	/* Logitech Webcam C260 */
+	{ USB_DEVICE(0x046d, 0x081a), .driver_info = USB_QUIRK_RESET_RESUME },
+
 	/* Logitech Webcam C310 */
 	{ USB_DEVICE(0x046d, 0x081b), .driver_info = USB_QUIRK_RESET_RESUME },
 
+	/* Logitech Webcam C910 */
+	{ USB_DEVICE(0x046d, 0x0821), .driver_info = USB_QUIRK_RESET_RESUME },
+
+	/* Logitech Webcam C160 */
+	{ USB_DEVICE(0x046d, 0x0824), .driver_info = USB_QUIRK_RESET_RESUME },
+
 	/* Logitech Webcam C270 */
 	{ USB_DEVICE(0x046d, 0x0825), .driver_info = USB_QUIRK_RESET_RESUME },
 
+	/* Logitech Quickcam Pro 9000 */
+	{ USB_DEVICE(0x046d, 0x0990), .driver_info = USB_QUIRK_RESET_RESUME },
+
+	/* Logitech Quickcam E3500 */
+	{ USB_DEVICE(0x046d, 0x09a4), .driver_info = USB_QUIRK_RESET_RESUME },
+
+	/* Logitech Quickcam Vision Pro */
+	{ USB_DEVICE(0x046d, 0x09a6), .driver_info = USB_QUIRK_RESET_RESUME },
+
 	/* Logitech Harmony 700-series */
 	{ USB_DEVICE(0x046d, 0xc122), .driver_info = USB_QUIRK_DELAY_INIT },
 


