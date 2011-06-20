Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753137Ab1FTFxH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 01:53:07 -0400
Received: from qmta08.westchester.pa.mail.comcast.net ([76.96.62.80]:52156
	"EHLO qmta08.westchester.pa.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751902Ab1FTFv7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 01:51:59 -0400
From: matt mooney <mfm@muteddisk.com>
To: Greg KH <greg@kroah.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 05/22] staging: usbip: userspace: libsrc: set program name for logging
Date: Sun, 19 Jun 2011 22:44:35 -0700
Message-Id: <250cc0d54fb4cabaa09b2444cb0656adfdd7a4c5.1308547654.git.mfm@muteddisk.com>
X-Mailer: git-send-email 1.7.5.2
In-Reply-To: <cover.1308547654.git.mfm@muteddisk.com>
References: <cover.1308547654.git.mfm@muteddisk.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Set the program name to "libusbip" to identify that the message is
from the library code.

Signed-off-by: matt mooney <mfm@muteddisk.com>
---
 .../staging/usbip/userspace/libsrc/stub_driver.c   |    3 +++
 .../staging/usbip/userspace/libsrc/usbip_common.c  |    3 +++
 .../staging/usbip/userspace/libsrc/vhci_driver.c   |    3 +++
 3 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/usbip/userspace/libsrc/stub_driver.c b/drivers/staging/usbip/userspace/libsrc/stub_driver.c
index 6a1272d..b62f6b2 100644
--- a/drivers/staging/usbip/userspace/libsrc/stub_driver.c
+++ b/drivers/staging/usbip/userspace/libsrc/stub_driver.c
@@ -10,6 +10,9 @@
 
 #include "usbip.h"
 
+#undef  PROGNAME
+#define PROGNAME "libusbip"
+
 struct usbip_stub_driver *stub_driver;
 
 static struct sysfs_driver *open_sysfs_stub_driver(void)
diff --git a/drivers/staging/usbip/userspace/libsrc/usbip_common.c b/drivers/staging/usbip/userspace/libsrc/usbip_common.c
index e9d0614..6ac4361 100644
--- a/drivers/staging/usbip/userspace/libsrc/usbip_common.c
+++ b/drivers/staging/usbip/userspace/libsrc/usbip_common.c
@@ -5,6 +5,9 @@
 #include "usbip.h"
 #include "names.h"
 
+#undef  PROGNAME
+#define PROGNAME "libusbip"
+
 int usbip_use_syslog = 0;
 int usbip_use_stderr = 0;
 int usbip_use_debug  = 0;
diff --git a/drivers/staging/usbip/userspace/libsrc/vhci_driver.c b/drivers/staging/usbip/userspace/libsrc/vhci_driver.c
index 386f63b..f10121c 100644
--- a/drivers/staging/usbip/userspace/libsrc/vhci_driver.c
+++ b/drivers/staging/usbip/userspace/libsrc/vhci_driver.c
@@ -5,6 +5,9 @@
 
 #include "usbip.h"
 
+#undef  PROGNAME
+#define PROGNAME "libusbip"
+
 struct usbip_vhci_driver *vhci_driver;
 
 static struct usbip_imported_device *imported_device_init(struct usbip_imported_device *idev, char *busid)
-- 
1.7.5.2

