Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752160Ab2GZQ1u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 12:27:50 -0400
Received: from mail.tpi.com ([70.99.223.143]:3472 "EHLO mail.tpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751650Ab2GZQ1t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 12:27:49 -0400
From: Tim Gardner <tim.gardner@canonical.com>
To: linux-kernel@vger.kernel.org
Cc: Tim Gardner <tim.gardner@canonical.com>, Ian Abbott <abbotti@mev.co.uk>,
        Mori Hess <fmhess@users.sourceforge.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Bernd Porr <berndporr@f2s.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        devel@driverdev.osuosl.org
Subject: [PATCH] usbduxsigma: Declare MODULE_FIRMWARE usage
Date: Thu, 26 Jul 2012 10:28:20 -0600
Message-Id: <1343320100-120489-1-git-send-email-tim.gardner@canonical.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Bernd Porr <berndporr@f2s.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>
Cc: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: devel@driverdev.osuosl.org
Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
---
 drivers/staging/comedi/drivers/usbduxsigma.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/comedi/drivers/usbduxsigma.c b/drivers/staging/comedi/drivers/usbduxsigma.c
index 465afbd..816c3a1 100644
--- a/drivers/staging/comedi/drivers/usbduxsigma.c
+++ b/drivers/staging/comedi/drivers/usbduxsigma.c
@@ -63,6 +63,7 @@ Status: testing
 #include "../comedidev.h"
 
 #define BOARDNAME "usbduxsigma"
+#define FIRMWARE "usbduxsigma_firmware.bin"
 
 /* timeout for the USB-transfer in ms*/
 #define BULK_TIMEOUT 1000
@@ -2588,7 +2589,7 @@ static int usbduxsigma_probe(struct usb_interface *uinterf,
 
 	ret = request_firmware_nowait(THIS_MODULE,
 				      FW_ACTION_HOTPLUG,
-				      "usbduxsigma_firmware.bin",
+				      FIRMWARE,
 				      &udev->dev,
 				      GFP_KERNEL,
 				      usbduxsub + index,
@@ -2865,3 +2866,4 @@ module_exit(exit_usbduxsigma);
 MODULE_AUTHOR(DRIVER_AUTHOR);
 MODULE_DESCRIPTION(DRIVER_DESC);
 MODULE_LICENSE("GPL");
+MODULE_FIRMWARE(FIRMWARE);
-- 
1.7.9.5

