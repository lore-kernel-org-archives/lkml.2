Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755673Ab2KUSi2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 13:38:28 -0500
Received: from mail.tpi.com ([70.99.223.143]:4696 "EHLO mail.tpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755656Ab2KUSi1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 13:38:27 -0500
X-Greylist: delayed 1644 seconds by postgrey-1.27 at vger.kernel.org; Wed, 21 Nov 2012 13:38:27 EST
From: Tim Gardner <tim.gardner@canonical.com>
To: linux-kernel@vger.kernel.org
Cc: Tim Gardner <tim.gardner@canonical.com>, Rob Landley <rob@landley.net>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ben Hutchings <ben@decadent.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-doc@vger.kernel.org
Subject: [PATCH linux-next] firmware: Remove last vestiges of dabusb
Date: Wed, 21 Nov 2012 11:10:01 -0700
Message-Id: <1353521401-13203-1-git-send-email-tim.gardner@canonical.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dabusb was removed with commit dae86ccbc3c185aebfc396e8e668aa3d73d748d8
'[media] dabusb: remove obsolete driver', so remove the last vestiges of
firmware and documentation.

Cc: Rob Landley <rob@landley.net>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Ben Hutchings <ben@decadent.org.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-doc@vger.kernel.org
Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
---

This patch was created using '--irreversible-delete' which might require manual
intervention depending on your version of git.

 Documentation/devices.txt          |    3 -
 firmware/Makefile                  |    1 -
 firmware/dabusb/bitstream.bin.ihex |  761 ------------------------------------
 firmware/dabusb/firmware.HEX       |  649 ------------------------------
 4 files changed, 1414 deletions(-)
 delete mode 100644 firmware/dabusb/bitstream.bin.ihex
 delete mode 100644 firmware/dabusb/firmware.HEX

diff --git a/Documentation/devices.txt b/Documentation/devices.txt
index b6251cc..08f01e7 100644
--- a/Documentation/devices.txt
+++ b/Documentation/devices.txt
@@ -2561,9 +2561,6 @@ Your cooperation is appreciated.
 		192 = /dev/usb/yurex1	First USB Yurex device
 		   ...
 		209 = /dev/usb/yurex16	16th USB Yurex device
-		240 = /dev/usb/dabusb0	First daubusb device
-		    ...
-		243 = /dev/usb/dabusb3	Fourth dabusb device
 
 180 block	USB block devices
 		  0 = /dev/uba		First USB block device
diff --git a/firmware/Makefile b/firmware/Makefile
index eeb1403..cbb09ce 100644
--- a/firmware/Makefile
+++ b/firmware/Makefile
@@ -97,7 +97,6 @@ fw-shipped-$(CONFIG_TEHUTI) += tehuti/bdx.bin
 fw-shipped-$(CONFIG_TIGON3) += tigon/tg3.bin tigon/tg3_tso.bin \
 			       tigon/tg3_tso5.bin
 fw-shipped-$(CONFIG_TYPHOON) += 3com/typhoon.bin
-fw-shipped-$(CONFIG_USB_DABUSB) += dabusb/firmware.fw dabusb/bitstream.bin
 fw-shipped-$(CONFIG_USB_EMI26) += emi26/loader.fw emi26/firmware.fw \
 				  emi26/bitstream.fw
 fw-shipped-$(CONFIG_USB_EMI62) += emi62/loader.fw emi62/bitstream.fw \
diff --git a/firmware/dabusb/bitstream.bin.ihex b/firmware/dabusb/bitstream.bin.ihex
deleted file mode 100644
index 5021a4b..0000000
diff --git a/firmware/dabusb/firmware.HEX b/firmware/dabusb/firmware.HEX
deleted file mode 100644
index 7c258df..0000000
-- 
1.7.9.5

