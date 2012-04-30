Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756212Ab2D3LFi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 07:05:38 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:57884 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755574Ab2D3LFh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 07:05:37 -0400
From: Steffen =?ISO-8859-1?Q?M=FCller?= <steffen.mueller@radio-frei.de>
To: opensuse-factory@opensuse.org
Cc: Oliver Neukum <oliver@neukum.org>, Alan Stern <stern@rowland.harvard.edu>,
        Jiri Slaby <jslaby@suse.cz>, stable@kernel.org,
        Greg KH <greg@kroah.com>, USB list <linux-usb@vger.kernel.org>,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: [PATCH] usb: add USB_QUIRK_RESET_RESUME for M-Audio 88es
Date: Mon, 30 Apr 2012 13:05:34 +0200
Message-ID: <1979769.SGKEhdJuNi@thinkpadsm.rf-studio>
User-Agent: KMail/4.8.2 (Linux/3.3.3-21-desktop-steffen; KDE/4.8.2; x86_64; ; )
In-Reply-To: <201204301048.21852.oliver@neukum.org>
References: <Pine.LNX.4.44L0.1204271122550.1690-100000@iolanthe.rowland.org> <5861865.YnqskICckP@thinkpadsm.rf-studio> <201204301048.21852.oliver@neukum.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
X-Provags-ID: V02:K0:J/+XCuVR/UqlFkHwAWwJIhTt97jvtbf64FB6NBMa2ab
 XHUhpUNVsPvtZg8+cuaf2SJFYRmww/Iqrhx2dihMg0/8c5Uj7J
 ydrX2XFEnOMMkCwBWzXV62t6clHcanKBYCe+3dw+E/sjCiGxP4
 Cg9itwYWCWi1IwtVkyzLKOwRpKHEYmU3IoeTaX8fEImWs3PUXy
 6mQSAe6jculs3TA2MvlOXIP+7evmbrufGjevd5rm+C4fN6o4SY
 cVS1QZ/Z68tIO1vkM5QuHY59EXkencjIEFS8NE9G6vJJvpBRzq
 P/ErkqQuuggWF8ZyGPOS1t7KVm3kjRzEiuymq9pe418vkaF+jN
 ttH1d7OUESB6Tt3SDoycghi5pKw7M04HMAmlPwg6HWRy311PQk
 /sbEsYegGThpA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tested-by:     Steffen Müller <steffen.mueller@radio-frei.de>
Signed-off-by: Steffen Müller <steffen.mueller@radio-frei.de>
Signed-off-by: Stefan Seyfried <seife+kernel@b1-systems.com>
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
 
-- 

