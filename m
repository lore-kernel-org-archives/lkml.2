Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755195Ab0KWPaV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 10:30:21 -0500
Received: from adelie.canonical.com ([91.189.90.139]:52384 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753037Ab0KWPaU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 10:30:20 -0500
Message-ID: <4CEBDE08.9030804@canonical.com>
Date: Tue, 23 Nov 2010 16:30:16 +0100
From: Stefan Bader <stefan.bader@canonical.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.15) Gecko/20101027 Lightning/1.0b1 Thunderbird/3.0.10
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        devel@driverdev.osuosl.org
CC: Greg Kroah-Hartman <gregkh@suse.de>, John Tapsell <johnflux@gmail.com>
Subject: [PATCH resend] Staging: rt2870: Add USB ID for Buffalo Airstation
 WLI-UC-GN
X-Enigmail-Version: 1.0.1
Content-Type: multipart/mixed;
 boundary="------------000506090605000409010202"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------000506090605000409010202
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit

This was tested under 2.6.35 and sent back then, but for one or the other reason
did not really make it anywhere. Patch applies to current tip of Linus tree and
2.6.36.y.

-Stefan

--------------000506090605000409010202
Content-Type: text/x-diff;
 name="0001-Staging-rt2870-Add-USB-ID-for-Buffalo-Airstation-WLI.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-Staging-rt2870-Add-USB-ID-for-Buffalo-Airstation-WLI.pa";
 filename*1="tch"

>From cfd78277cec4927bf02d6881a6001fa6f73a1b01 Mon Sep 17 00:00:00 2001
From: John Tapsell <johnflux@gmail.com>
Date: Thu, 25 Mar 2010 13:30:45 +0000
Subject: [PATCH] Staging: rt2870: Add USB ID for Buffalo Airstation WLI-UC-GN

BugLink: http://bugs.launchpad.net/bugs/441990

This was tested to successfully enable the hardware.

Signed-off-by: John Tapsell <johnflux@gmail.com>
Signed-off-by: Stefan Bader <stefan.bader@canonical.com>
CC: stable@kernel.org
---
 drivers/staging/rt2860/usb_main_dev.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/rt2860/usb_main_dev.c b/drivers/staging/rt2860/usb_main_dev.c
index ddacfc6..cd15daa 100644
--- a/drivers/staging/rt2860/usb_main_dev.c
+++ b/drivers/staging/rt2860/usb_main_dev.c
@@ -182,6 +182,7 @@ struct usb_device_id rtusb_usb_id[] = {
 	{USB_DEVICE(0x2001, 0x3C09)},	/* D-Link */
 	{USB_DEVICE(0x2001, 0x3C0A)},	/* D-Link 3072 */
 	{USB_DEVICE(0x2019, 0xED14)},	/* Planex Communications, Inc. */
+	{USB_DEVICE(0x0411, 0x015D)},	/* Buffalo Airstation WLI-UC-GN */
 	{}			/* Terminating entry */
 };
 
-- 
1.7.0.4


--------------000506090605000409010202--
