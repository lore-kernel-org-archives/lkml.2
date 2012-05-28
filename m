Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755261Ab2E1Drp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2012 23:47:45 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:52004 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753485Ab2E1D3Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2012 23:29:25 -0400
Message-Id: <20120528031208.405968497@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 28 May 2012 04:12:42 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        =?UTF-8?q?Steffen=20M=C3=BCller?= <steffen.mueller@radio-frei.de>,
        Stefan Seyfried <seife+kernel@b1-systems.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [ 040/117] usb: add USB_QUIRK_RESET_RESUME for M-Audio 88es
In-Reply-To: <20120528031202.829379252@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steffen Müller <steffen.mueller@radio-frei.de>

commit 166cb70e97bd83d7ae9bbec6ae59a178fd9bb823 upstream.

Tested-by: Steffen Müller <steffen.mueller@radio-frei.de>
Signed-off-by: Steffen Müller <steffen.mueller@radio-frei.de>
Signed-off-by: Stefan Seyfried <seife+kernel@b1-systems.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/core/quirks.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/usb/core/quirks.c b/drivers/usb/core/quirks.c
index 4c65eb6..32d3adc 100644
--- a/drivers/usb/core/quirks.c
+++ b/drivers/usb/core/quirks.c
@@ -123,6 +123,9 @@ static const struct usb_device_id usb_quirk_list[] = {
 	/* Guillemot Webcam Hercules Dualpix Exchange*/
 	{ USB_DEVICE(0x06f8, 0x3005), .driver_info = USB_QUIRK_RESET_RESUME },
 
+	/* Midiman M-Audio Keystation 88es */
+	{ USB_DEVICE(0x0763, 0x0192), .driver_info = USB_QUIRK_RESET_RESUME },
+
 	/* M-Systems Flash Disk Pioneers */
 	{ USB_DEVICE(0x08ec, 0x1000), .driver_info = USB_QUIRK_RESET_RESUME },
 


