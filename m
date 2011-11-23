Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759012Ab1KWAdv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 19:33:51 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42161 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758996Ab1KWAds (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 19:33:48 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Nov 22 16:22:09 2011
Message-Id: <20111123002209.054134905@clark.kroah.org>
User-Agent: quilt/0.48-20.1.2
Date: Tue, 22 Nov 2011 16:21:12 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Josh Boyer <jwboyer@redhat.com>
Subject: [22/25] USB: add quirk for Logitech C600 web cam
In-Reply-To: <20111123002222.GA2376@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------
Content-Length: 823
Lines: 27

From: Josh Boyer <jwboyer@redhat.com>

commit 60c71ca972a2dd3fd9d0165b405361c8ad48349b upstream.

We've had another report of the "chipmunk" sound on a Logitech C600 webcam.
This patch resolves the issue.

Signed-off-by: Josh Boyer <jwboyer@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/core/quirks.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/usb/core/quirks.c
+++ b/drivers/usb/core/quirks.c
@@ -47,6 +47,9 @@ static const struct usb_device_id usb_qu
 	/* Logitech Webcam B/C500 */
 	{ USB_DEVICE(0x046d, 0x0807), .driver_info = USB_QUIRK_RESET_RESUME },
 
+	/* Logitech Webcam C600 */
+	{ USB_DEVICE(0x046d, 0x0808), .driver_info = USB_QUIRK_RESET_RESUME },
+
 	/* Logitech Webcam Pro 9000 */
 	{ USB_DEVICE(0x046d, 0x0809), .driver_info = USB_QUIRK_RESET_RESUME },
 


