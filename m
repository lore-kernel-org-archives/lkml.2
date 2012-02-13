Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756674Ab2BMNn1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 08:43:27 -0500
Received: from i118-21-156-233.s30.a048.ap.plala.or.jp ([118.21.156.233]:35029
	"EHLO rinabert.homeip.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751157Ab2BMNnZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 08:43:25 -0500
From: Masanari Iida <standby24x7@gmail.com>
To: trivial@kernel.org, rdunlap@xenotime.net, linux-doc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, standby24x7@gmail.com
Subject: [PATCH] [trivial] Documentation: Fix Broken URL "freshmeat"
Date: Mon, 13 Feb 2012 22:42:58 +0900
Message-Id: <1329140578-2045-1-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 1.7.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix broken URL in documents "freshmeat" to "freecode" in
Documentation/filesystems/ramfs-rootfs-initramfs.txt,
Documentation/scsi/scsi-generic.txt
Documentation/usb/mtouchusb.txt

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 .../filesystems/ramfs-rootfs-initramfs.txt         |    2 +-
 Documentation/scsi/scsi-generic.txt                |    2 +-
 Documentation/usb/mtouchusb.txt                    |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/Documentation/filesystems/ramfs-rootfs-initramfs.txt b/Documentation/filesystems/ramfs-rootfs-initramfs.txt
index a8273d5..59b4a09 100644
--- a/Documentation/filesystems/ramfs-rootfs-initramfs.txt
+++ b/Documentation/filesystems/ramfs-rootfs-initramfs.txt
@@ -297,7 +297,7 @@ the above threads) is:
    either way about the archive format, and there are alternative tools,
    such as:
 
-     http://freshmeat.net/projects/afio/
+     http://freecode.com/projects/afio
 
 2) The cpio archive format chosen by the kernel is simpler and cleaner (and
    thus easier to create and parse) than any of the (literally dozens of)
diff --git a/Documentation/scsi/scsi-generic.txt b/Documentation/scsi/scsi-generic.txt
index 0a22ab8..51be20a 100644
--- a/Documentation/scsi/scsi-generic.txt
+++ b/Documentation/scsi/scsi-generic.txt
@@ -62,7 +62,7 @@ There are two packages of sg utilities:
                 and earlier
 Both packages will work in the lk 2.4 series however sg3_utils offers more
 capabilities. They can be found at: http://sg.danny.cz/sg/sg3_utils.html and 
-freshmeat.net
+freecode.com
 
 Another approach is to look at the applications that use the sg driver.
 These include cdrecord, cdparanoia, SANE and cdrdao.
diff --git a/Documentation/usb/mtouchusb.txt b/Documentation/usb/mtouchusb.txt
index 86302cd..a91adb2 100644
--- a/Documentation/usb/mtouchusb.txt
+++ b/Documentation/usb/mtouchusb.txt
@@ -1,7 +1,7 @@
 CHANGES
 
 - 0.3 - Created based off of scanner & INSTALL from the original touchscreen
-  driver on freshmeat (http://freshmeat.net/projects/3mtouchscreendriver)
+  driver on freecode (http://freecode.com/projects/3mtouchscreendriver)
 - Amended for linux-2.4.18, then 2.4.19
 
 - 0.5 - Complete rewrite using Linux Input in 2.6.3
-- 
1.7.6.5

