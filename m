Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753302Ab2DPLYU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 07:24:20 -0400
Received: from cust23-dsl91-135-1.idnet.net ([91.135.1.23]:58116 "EHLO
	drevil.shawell.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753175Ab2DPLYT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 07:24:19 -0400
X-Greylist: delayed 647 seconds by postgrey-1.27 at vger.kernel.org; Mon, 16 Apr 2012 07:24:19 EDT
From: Steve Glendinning <steve.glendinning@shawell.net>
To: linux-kernel@vger.kernel.org
Cc: trivial@rustcorp.com.au, Steve Glendinning <steve.glendinning@shawell.net>
Subject: [PATCH] Change email address for Steve Glendinning
Date: Mon, 16 Apr 2012 12:13:29 +0100
Message-Id: <1334574809-2446-1-git-send-email-steve.glendinning@shawell.net>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I no longer have a mailbox at smsc.com, and I've had two reports
that that email address now bounces from people trying to
contact me.  This patch updates all references to that invalid
address to one that I can be contacted on more permanently.

This patch also updates the maintainer status to reflect
the fact I'm no longer directly paid to maintain these drivers.

Signed-off-by: Steve Glendinning <steve.glendinning@shawell.net>
---
 MAINTAINERS                    |   20 ++++++++++----------
 arch/sh/boards/board-polaris.c |    2 +-
 drivers/hwmon/emc2103.c        |    2 +-
 drivers/net/phy/smsc.c         |    2 +-
 drivers/net/usb/smsc75xx.c     |    2 +-
 drivers/net/usb/smsc95xx.c     |    2 +-
 drivers/video/smscufx.c        |    4 ++--
 7 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index b0f1073..b74bed7 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6144,9 +6144,9 @@ F:	Documentation/hwmon/smm665
 F:	drivers/hwmon/smm665.c
 
 SMSC EMC2103 HARDWARE MONITOR DRIVER
-M:	Steve Glendinning <steve.glendinning@smsc.com>
+M:	Steve Glendinning <steve.glendinning@shawell.net>
 L:	lm-sensors@lm-sensors.org
-S:	Supported
+S:	Maintained
 F:	Documentation/hwmon/emc2103
 F:	drivers/hwmon/emc2103.c
 
@@ -6165,22 +6165,22 @@ F:	Documentation/hwmon/smsc47b397
 F:	drivers/hwmon/smsc47b397.c
 
 SMSC911x ETHERNET DRIVER
-M:	Steve Glendinning <steve.glendinning@smsc.com>
+M:	Steve Glendinning <steve.glendinning@shawell.net>
 L:	netdev@vger.kernel.org
-S:	Supported
+S:	Maintained
 F:	include/linux/smsc911x.h
 F:	drivers/net/ethernet/smsc/smsc911x.*
 
 SMSC9420 PCI ETHERNET DRIVER
-M:	Steve Glendinning <steve.glendinning@smsc.com>
+M:	Steve Glendinning <steve.glendinning@shawell.net>
 L:	netdev@vger.kernel.org
-S:	Supported
+S:	Maintained
 F:	drivers/net/ethernet/smsc/smsc9420.*
 
 SMSC UFX6000 and UFX7000 USB to VGA DRIVER
-M:	Steve Glendinning <steve.glendinning@smsc.com>
+M:	Steve Glendinning <steve.glendinning@shawell.net>
 L:	linux-fbdev@vger.kernel.org
-S:	Supported
+S:	Maintained
 F:	drivers/video/smscufx.c
 
 SN-IA64 (Itanium) SUB-PLATFORM
@@ -7098,9 +7098,9 @@ S:	Supported
 F:	drivers/usb/serial/whiteheat*
 
 USB SMSC95XX ETHERNET DRIVER
-M:	Steve Glendinning <steve.glendinning@smsc.com>
+M:	Steve Glendinning <steve.glendinning@shawell.net>
 L:	netdev@vger.kernel.org
-S:	Supported
+S:	Maintained
 F:	drivers/net/usb/smsc95xx.*
 
 USB SN9C1xx DRIVER
diff --git a/arch/sh/boards/board-polaris.c b/arch/sh/boards/board-polaris.c
index 5948663..9f09756 100644
--- a/arch/sh/boards/board-polaris.c
+++ b/arch/sh/boards/board-polaris.c
@@ -1,5 +1,5 @@
 /*
- * June 2006 steve.glendinning@smsc.com
+ * June 2006 Steve Glendinning <steve.glendinning@shawell.net>
  *
  * Polaris-specific resource declaration
  *
diff --git a/drivers/hwmon/emc2103.c b/drivers/hwmon/emc2103.c
index 9691f66..a73e685 100644
--- a/drivers/hwmon/emc2103.c
+++ b/drivers/hwmon/emc2103.c
@@ -728,6 +728,6 @@ static struct i2c_driver emc2103_driver = {
 
 module_i2c_driver(emc2103_driver);
 
-MODULE_AUTHOR("Steve Glendinning <steve.glendinning@smsc.com>");
+MODULE_AUTHOR("Steve Glendinning <steve.glendinning@shawell.net>");
 MODULE_DESCRIPTION("SMSC EMC2103 hwmon driver");
 MODULE_LICENSE("GPL");
diff --git a/drivers/net/phy/smsc.c b/drivers/net/phy/smsc.c
index fc3e7e9..42c43e7 100644
--- a/drivers/net/phy/smsc.c
+++ b/drivers/net/phy/smsc.c
@@ -12,7 +12,7 @@
  * Free Software Foundation;  either version 2 of the  License, or (at your
  * option) any later version.
  *
- * Support added for SMSC LAN8187 and LAN8700 by steve.glendinning@smsc.com
+ * Support added for SMSC LAN8187 and LAN8700 by steve.glendinning@shawell.net
  *
  */
 
diff --git a/drivers/net/usb/smsc75xx.c b/drivers/net/usb/smsc75xx.c
index 187d01c..80f7a59 100644
--- a/drivers/net/usb/smsc75xx.c
+++ b/drivers/net/usb/smsc75xx.c
@@ -1241,6 +1241,6 @@ static struct usb_driver smsc75xx_driver = {
 module_usb_driver(smsc75xx_driver);
 
 MODULE_AUTHOR("Nancy Lin");
-MODULE_AUTHOR("Steve Glendinning <steve.glendinning@smsc.com>");
+MODULE_AUTHOR("Steve Glendinning <steve.glendinning@shawell.net>");
 MODULE_DESCRIPTION("SMSC75XX USB 2.0 Gigabit Ethernet Devices");
 MODULE_LICENSE("GPL");
diff --git a/drivers/net/usb/smsc95xx.c b/drivers/net/usb/smsc95xx.c
index 5f19f84..6e46cf4 100644
--- a/drivers/net/usb/smsc95xx.c
+++ b/drivers/net/usb/smsc95xx.c
@@ -1301,6 +1301,6 @@ static struct usb_driver smsc95xx_driver = {
 module_usb_driver(smsc95xx_driver);
 
 MODULE_AUTHOR("Nancy Lin");
-MODULE_AUTHOR("Steve Glendinning <steve.glendinning@smsc.com>");
+MODULE_AUTHOR("Steve Glendinning <steve.glendinning@shawell.net>");
 MODULE_DESCRIPTION("SMSC95XX USB 2.0 Ethernet Devices");
 MODULE_LICENSE("GPL");
diff --git a/drivers/video/smscufx.c b/drivers/video/smscufx.c
index ccbfef5..2e4c249 100644
--- a/drivers/video/smscufx.c
+++ b/drivers/video/smscufx.c
@@ -1,7 +1,7 @@
 /*
  * smscufx.c -- Framebuffer driver for SMSC UFX USB controller
  *
- * Copyright (C) 2011 Steve Glendinning <steve.glendinning@smsc.com>
+ * Copyright (C) 2011 Steve Glendinning <steve.glendinning@shawell.net>
  * Copyright (C) 2009 Roberto De Ioris <roberto@unbit.it>
  * Copyright (C) 2009 Jaya Kumar <jayakumar.lkml@gmail.com>
  * Copyright (C) 2009 Bernie Thompson <bernie@plugable.com>
@@ -1972,6 +1972,6 @@ MODULE_PARM_DESC(console, "Allow fbcon to be used on this display");
 module_param(fb_defio, bool, S_IWUSR | S_IRUSR | S_IWGRP | S_IRGRP);
 MODULE_PARM_DESC(fb_defio, "Enable fb_defio mmap support");
 
-MODULE_AUTHOR("Steve Glendinning <steve.glendinning@smsc.com>");
+MODULE_AUTHOR("Steve Glendinning <steve.glendinning@shawell.net>");
 MODULE_DESCRIPTION("SMSC UFX kernel framebuffer driver");
 MODULE_LICENSE("GPL");
-- 
1.7.5.4

