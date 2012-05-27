Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932155Ab2E0BAI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2012 21:00:08 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:56104 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755711Ab2E0BAB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2012 21:00:01 -0400
Message-Id: <20120527002619.597925581@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Sun, 27 May 2012 09:26:51 +0900
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        =?UTF-8?q?Steffen=20M=C3=BCller?= <steffen.mueller@radio-frei.de>,
        Stefan Seyfried <seife+kernel@b1-systems.com>
Subject: [ 38/55] usb: add USB_QUIRK_RESET_RESUME for M-Audio 88es
In-Reply-To: <20120527005203.GA2146@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: =?UTF-8?q?Steffen=20M=C3=BCller?= <steffen.mueller@radio-frei.de>

commit 166cb70e97bd83d7ae9bbec6ae59a178fd9bb823 upstream.

Tested-by: Steffen Müller <steffen.mueller@radio-frei.de>
Signed-off-by: Steffen Müller <steffen.mueller@radio-frei.de>
Signed-off-by: Stefan Seyfried <seife+kernel@b1-systems.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/core/quirks.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/usb/core/quirks.c
+++ b/drivers/usb/core/quirks.c
@@ -123,6 +123,9 @@ static const struct usb_device_id usb_qu
 	/* Guillemot Webcam Hercules Dualpix Exchange*/
 	{ USB_DEVICE(0x06f8, 0x3005), .driver_info = USB_QUIRK_RESET_RESUME },
 
+	/* Midiman M-Audio Keystation 88es */
+	{ USB_DEVICE(0x0763, 0x0192), .driver_info = USB_QUIRK_RESET_RESUME },
+
 	/* M-Systems Flash Disk Pioneers */
 	{ USB_DEVICE(0x08ec, 0x1000), .driver_info = USB_QUIRK_RESET_RESUME },
 


