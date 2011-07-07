Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754710Ab1GGILt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 04:11:49 -0400
Received: from qmta14.emeryville.ca.mail.comcast.net ([76.96.27.212]:55718
	"EHLO qmta14.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752104Ab1GGILq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 04:11:46 -0400
From: matt mooney <mfm@muteddisk.com>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 6/7] staging: usbip: userspace: README: update example output
Date: Thu,  7 Jul 2011 00:31:55 -0700
Message-Id: <2a0898316ddacf19296bbe5215965dd3e89eb761.1310023068.git.mfm@muteddisk.com>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <cover.1310023068.git.mfm@muteddisk.com>
References: <cover.1310023068.git.mfm@muteddisk.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change a missed reference to the `list' command, and update the output
from `usbip bind ...' and `usbip list -r ...'

Signed-off-by: matt mooney <mfm@muteddisk.com>
---
 drivers/staging/usbip/userspace/README |   53 +++++++++++++++++---------------
 1 files changed, 28 insertions(+), 25 deletions(-)

diff --git a/drivers/staging/usbip/userspace/README b/drivers/staging/usbip/userspace/README
index aafab102..63cd107 100644
--- a/drivers/staging/usbip/userspace/README
+++ b/drivers/staging/usbip/userspace/README
@@ -79,7 +79,7 @@ Physically attach your USB devices to this host.
 In another terminal, let's look up what USB devices are physically
 attached to this host.
 
-    trois:# usbip_bind_driver --list
+    trois:# usbip list -l
     Local USB devices
     =================
      - busid 1-1 (05a9:a511)
@@ -115,8 +115,9 @@ Mark the device of busid 3-3.2 as exportable:
 
     trois:# usbip --debug bind --busid 3-3.2
     ...
-    usbip dbg: utils.c:	 52 (modify_match_busid) write "add 3-3.2" to...
-    usbip dbg: usbip_bind.c: 231 (use_device_by_usbip) bind 3-3.2 complete!
+    usbip debug: usbip_bind.c:162:[unbind_other] 3-3.2:1.0 -> usb-storage
+    ...
+    bind device on busid 3-3.2: complete
 
     trois:# usbip list -l
     Local USB devices
@@ -137,28 +138,30 @@ exportable on the host.
     deux:# insmod path/to/vhci-hcd.ko
 
     deux:# usbip list --remote 10.0.0.3
-    - 10.0.0.3
-	  1-1: Prolific Technology, Inc. : unknown product (067b:3507)
-	     : /sys/devices/pci0000:00/0000:00:1f.2/usb1/1-1
-	     : (Defined at Interface level) / unknown subclass / unknown protocol (00/00/00)
-	     :	0 - Mass Storage / SCSI / Bulk (Zip) (08/06/50)
-
-      1-2.2.1: Apple Computer, Inc. : unknown product (05ac:0203)
-	     : /sys/devices/pci0000:00/0000:00:1f.2/usb1/1-2/1-2.2/1-2.2.1
-	     : (Defined at Interface level) / unknown subclass / unknown protocol (00/00/00)
-	     :	0 - Human Interface Devices / Boot Interface Subclass / Keyboard (03/01/01)
-
-      1-2.2.3: OmniVision Technologies, Inc. : OV511+ WebCam (05a9:a511)
-	     : /sys/devices/pci0000:00/0000:00:1f.2/usb1/1-2/1-2.2/1-2.2.3
-	     : (Defined at Interface level) / unknown subclass / unknown protocol (00/00/00)
-	     :	0 - Vendor Specific Class / unknown subclass / unknown protocol (ff/00/00)
-
-	  3-1: Logitech, Inc. : QuickCam Pro 4000 (046d:08b2)
-	     : /sys/devices/pci0000:00/0000:00:1e.0/0000:02:0a.0/usb3/3-1
-	     : (Defined at Interface level) / unknown subclass / unknown protocol (00/00/00)
-	     :	0 - Data / unknown subclass / unknown protocol (0a/ff/00)
-	     :	1 - Audio / Control Device / unknown protocol (01/01/00)
-	     :	2 - Audio / Streaming / unknown protocol (01/02/00)
+    Exportable USB devices
+    ======================
+     - 10.0.0.3
+	    1-1: Prolific Technology, Inc. : unknown product (067b:3507)
+	       : /sys/devices/pci0000:00/0000:00:1f.2/usb1/1-1
+	       : (Defined at Interface level) / unknown subclass / unknown protocol (00/00/00)
+	       :  0 - Mass Storage / SCSI / Bulk (Zip) (08/06/50)
+
+	1-2.2.1: Apple Computer, Inc. : unknown product (05ac:0203)
+	       : /sys/devices/pci0000:00/0000:00:1f.2/usb1/1-2/1-2.2/1-2.2.1
+	       : (Defined at Interface level) / unknown subclass / unknown protocol (00/00/00)
+	       :  0 - Human Interface Devices / Boot Interface Subclass / Keyboard (03/01/01)
+
+	1-2.2.3: OmniVision Technologies, Inc. : OV511+ WebCam (05a9:a511)
+	       : /sys/devices/pci0000:00/0000:00:1f.2/usb1/1-2/1-2.2/1-2.2.3
+	       : (Defined at Interface level) / unknown subclass / unknown protocol (00/00/00)
+	       :  0 - Vendor Specific Class / unknown subclass / unknown protocol (ff/00/00)
+
+	    3-1: Logitech, Inc. : QuickCam Pro 4000 (046d:08b2)
+	       : /sys/devices/pci0000:00/0000:00:1e.0/0000:02:0a.0/usb3/3-1
+	       : (Defined at Interface level) / unknown subclass / unknown protocol (00/00/00)
+	       :  0 - Data / unknown subclass / unknown protocol (0a/ff/00)
+	       :  1 - Audio / Control Device / unknown protocol (01/01/00)
+	       :  2 - Audio / Streaming / unknown protocol (01/02/00)
 
 Attach a remote USB device:
 
-- 
1.7.6

