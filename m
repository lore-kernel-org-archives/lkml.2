Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752558Ab2GZQDN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 12:03:13 -0400
Received: from mail.tpi.com ([70.99.223.143]:4638 "EHLO mail.tpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751500Ab2GZQDL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 12:03:11 -0400
From: Tim Gardner <tim.gardner@canonical.com>
To: linux-kernel@vger.kernel.org
Cc: Tim Gardner <tim.gardner@canonical.com>, Ian Abbott <abbotti@mev.co.uk>,
        Mori Hess <fmhess@users.sourceforge.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        Ravishankar Karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>,
        devel@driverdev.osuosl.org
Subject: [PATCH] usbduxfast: Declare MODULE_FIRMWARE usage
Date: Thu, 26 Jul 2012 10:03:34 -0600
Message-Id: <1343318614-94700-1-git-send-email-tim.gardner@canonical.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ravishankar Karkala Mallikarjunayya <ravishankar.km@greenturtles.in>
Cc: devel@driverdev.osuosl.org
Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
---
 drivers/staging/comedi/drivers/usbduxfast.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/comedi/drivers/usbduxfast.c b/drivers/staging/comedi/drivers/usbduxfast.c
index 7b1d21a..5f41d49 100644
--- a/drivers/staging/comedi/drivers/usbduxfast.c
+++ b/drivers/staging/comedi/drivers/usbduxfast.c
@@ -53,6 +53,7 @@
 #define DRIVER_AUTHOR "Bernd Porr, BerndPorr@f2s.com"
 #define DRIVER_DESC "USB-DUXfast, BerndPorr@f2s.com"
 #define BOARDNAME "usbduxfast"
+#define FIRMWARE "usbduxfast_firmware.bin"
 
 /*
  * timeout for the USB-transfer
@@ -1578,7 +1579,7 @@ static int usbduxfastsub_probe(struct usb_interface *uinterf,
 
 	ret = request_firmware_nowait(THIS_MODULE,
 				      FW_ACTION_HOTPLUG,
-				      "usbduxfast_firmware.bin",
+				      FIRMWARE,
 				      &udev->dev,
 				      GFP_KERNEL,
 				      usbduxfastsub + index,
@@ -1804,3 +1805,4 @@ module_exit(exit_usbduxfast);
 MODULE_AUTHOR(DRIVER_AUTHOR);
 MODULE_DESCRIPTION(DRIVER_DESC);
 MODULE_LICENSE("GPL");
+MODULE_FIRMWARE(FIRMWARE);
-- 
1.7.9.5

