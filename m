Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965041Ab1KJDi0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 22:38:26 -0500
Received: from cantor2.suse.de ([195.135.220.15]:43915 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935783Ab1KJDiU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 22:38:20 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  9 13:31:49 2011
Message-Id: <20111109213149.236711423@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 09 Nov 2011 13:31:58 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Jon Levell <linuxusb@coralbark.net>
Subject: [071/264] USB: add quirk for Logitech C300 web cam
In-Reply-To: <20111109213508.GA3476@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jon Levell <linuxusb@coralbark.net>

commit 5b253d88cc6c65a23cefc457a5a4ef139913c5fc upstream.

My webcam is a Logitech C300 and I get "chipmunk"ed squeaky sound.
The following trivial patch fixes it.

Signed-off-by: Jon Levell <linuxusb@coralbark.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

diff --git a/drivers/usb/core/quirks.c b/drivers/usb/core/quirks.c
index 38f0510..d6a8d82 100644
--- a/drivers/usb/core/quirks.c
+++ b/drivers/usb/core/quirks.c
@@ -44,6 +44,9 @@ static const struct usb_device_id usb_quirk_list[] = {
 	/* Logitech Webcam C250 */
 	{ USB_DEVICE(0x046d, 0x0804), .driver_info = USB_QUIRK_RESET_RESUME },
 
+	/* Logitech Webcam C300 */
+	{ USB_DEVICE(0x046d, 0x0805), .driver_info = USB_QUIRK_RESET_RESUME },
+
 	/* Logitech Webcam B/C500 */
 	{ USB_DEVICE(0x046d, 0x0807), .driver_info = USB_QUIRK_RESET_RESUME },
 


