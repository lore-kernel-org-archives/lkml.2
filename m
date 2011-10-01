Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756388Ab1JAKQc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Oct 2011 06:16:32 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:64695 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755519Ab1JAKPt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Oct 2011 06:15:49 -0400
From: Mark Einon <mark.einon@gmail.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        o.hartmann@telovital.com, alan@linux.intel.com,
        Mark Einon <mark.einon@gmail.com>
Subject: [PATCH 7/8] staging: et131x: Updating copyright statements and module authors
Date: Sat,  1 Oct 2011 11:14:16 +0100
Message-Id: <1317464057-18231-7-git-send-email-mark.einon@gmail.com>
X-Mailer: git-send-email 1.7.6.4
In-Reply-To: <1317464057-18231-1-git-send-email-mark.einon@gmail.com>
References: <1317464057-18231-1-git-send-email-mark.einon@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding copyright notices and adding myself as a module author.

Signed-off-by: Mark Einon <mark.einon@gmail.com>
---
 drivers/staging/et131x/et1310_address_map.h |    2 ++
 drivers/staging/et131x/et1310_eeprom.c      |    2 ++
 drivers/staging/et131x/et1310_mac.c         |    2 ++
 drivers/staging/et131x/et1310_phy.c         |    2 ++
 drivers/staging/et131x/et1310_phy.h         |    2 ++
 drivers/staging/et131x/et1310_pm.c          |    2 ++
 drivers/staging/et131x/et1310_rx.c          |    2 ++
 drivers/staging/et131x/et1310_rx.h          |    2 ++
 drivers/staging/et131x/et1310_tx.c          |    2 ++
 drivers/staging/et131x/et131x_adapter.h     |    2 ++
 drivers/staging/et131x/et131x_defs.h        |    2 ++
 drivers/staging/et131x/et131x_ethtool.c     |    4 +---
 drivers/staging/et131x/et131x_initpci.c     |    3 +++
 drivers/staging/et131x/et131x_isr.c         |    2 ++
 drivers/staging/et131x/et131x_netdev.c      |    2 ++
 drivers/staging/et131x/et131x_version.h     |    1 +
 16 files changed, 31 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/et131x/et1310_address_map.h b/drivers/staging/et131x/et1310_address_map.h
index 38ec56c..b502ce3 100644
--- a/drivers/staging/et131x/et1310_address_map.h
+++ b/drivers/staging/et131x/et1310_address_map.h
@@ -6,6 +6,8 @@
  * All rights reserved.
  *   http://www.agere.com
  *
+ * Copyright (c) 2011 Mark Einon <mark.einon@gmail.com>
+ *
  *------------------------------------------------------------------------------
  *
  * et1310_address_map.h - Contains the register mapping for the ET1310
diff --git a/drivers/staging/et131x/et1310_eeprom.c b/drivers/staging/et131x/et1310_eeprom.c
index e810254..747b1dc 100644
--- a/drivers/staging/et131x/et1310_eeprom.c
+++ b/drivers/staging/et131x/et1310_eeprom.c
@@ -6,6 +6,8 @@
  * All rights reserved.
  *   http://www.agere.com
  *
+ * Copyright (c) 2011 Mark Einon <mark.einon@gmail.com>
+ *
  *------------------------------------------------------------------------------
  *
  * et1310_eeprom.c - Code used to access the device's EEPROM
diff --git a/drivers/staging/et131x/et1310_mac.c b/drivers/staging/et131x/et1310_mac.c
index 157462f..b4c9df1 100644
--- a/drivers/staging/et131x/et1310_mac.c
+++ b/drivers/staging/et131x/et1310_mac.c
@@ -6,6 +6,8 @@
  * All rights reserved.
  *   http://www.agere.com
  *
+ * Copyright (c) 2011 Mark Einon <mark.einon@gmail.com>
+ *
  *------------------------------------------------------------------------------
  *
  * et1310_mac.c - All code and routines pertaining to the MAC
diff --git a/drivers/staging/et131x/et1310_phy.c b/drivers/staging/et131x/et1310_phy.c
index a72046b..145ec76 100644
--- a/drivers/staging/et131x/et1310_phy.c
+++ b/drivers/staging/et131x/et1310_phy.c
@@ -6,6 +6,8 @@
  * All rights reserved.
  *   http://www.agere.com
  *
+ * Copyright (c) 2011 Mark Einon <mark.einon@gmail.com>
+ *
  *------------------------------------------------------------------------------
  *
  * et1310_phy.c - Routines for configuring and accessing the PHY
diff --git a/drivers/staging/et131x/et1310_phy.h b/drivers/staging/et131x/et1310_phy.h
index 82037ac..2803bdf 100644
--- a/drivers/staging/et131x/et1310_phy.h
+++ b/drivers/staging/et131x/et1310_phy.h
@@ -6,6 +6,8 @@
  * All rights reserved.
  *   http://www.agere.com
  *
+ * Copyright (c) 2011 Mark Einon <mark.einon@gmail.com>
+ *
  *------------------------------------------------------------------------------
  *
  * et1310_phy.h - Defines, structs, enums, prototypes, etc. pertaining to the
diff --git a/drivers/staging/et131x/et1310_pm.c b/drivers/staging/et131x/et1310_pm.c
index 55f2d36..fd1eb6f 100644
--- a/drivers/staging/et131x/et1310_pm.c
+++ b/drivers/staging/et131x/et1310_pm.c
@@ -6,6 +6,8 @@
  * All rights reserved.
  *   http://www.agere.com
  *
+ * Copyright (c) 2011 Mark Einon <mark.einon@gmail.com>
+ *
  *------------------------------------------------------------------------------
  *
  * et1310_pm.c - All power management related code (not completely implemented)
diff --git a/drivers/staging/et131x/et1310_rx.c b/drivers/staging/et131x/et1310_rx.c
index c402c5e..600a8f1 100644
--- a/drivers/staging/et131x/et1310_rx.c
+++ b/drivers/staging/et131x/et1310_rx.c
@@ -6,6 +6,8 @@
  * All rights reserved.
  *   http://www.agere.com
  *
+ * Copyright (c) 2011 Mark Einon <mark.einon@gmail.com>
+ *
  *------------------------------------------------------------------------------
  *
  * et1310_rx.c - Routines used to perform data reception
diff --git a/drivers/staging/et131x/et1310_rx.h b/drivers/staging/et131x/et1310_rx.h
index 1448aa9..a19fab9 100644
--- a/drivers/staging/et131x/et1310_rx.h
+++ b/drivers/staging/et131x/et1310_rx.h
@@ -6,6 +6,8 @@
  * All rights reserved.
  *   http://www.agere.com
  *
+ * Copyright (c) 2011 Mark Einon <mark.einon@gmail.com>
+ *
  *------------------------------------------------------------------------------
  *
  * et1310_rx.h - Defines, structs, enums, prototypes, etc. pertaining to data
diff --git a/drivers/staging/et131x/et1310_tx.c b/drivers/staging/et131x/et1310_tx.c
index 1f80651..2ecb934 100644
--- a/drivers/staging/et131x/et1310_tx.c
+++ b/drivers/staging/et131x/et1310_tx.c
@@ -6,6 +6,8 @@
  * All rights reserved.
  *   http://www.agere.com
  *
+ * Copyright (c) 2011 Mark Einon <mark.einon@gmail.com>
+ *
  *------------------------------------------------------------------------------
  *
  * et1310_tx.c - Routines used to perform data transmission.
diff --git a/drivers/staging/et131x/et131x_adapter.h b/drivers/staging/et131x/et131x_adapter.h
index b5195ef..b062e6d 100644
--- a/drivers/staging/et131x/et131x_adapter.h
+++ b/drivers/staging/et131x/et131x_adapter.h
@@ -6,6 +6,8 @@
  * All rights reserved.
  *   http://www.agere.com
  *
+ * Copyright (c) 2011 Mark Einon <mark.einon@gmail.com>
+ *
  *------------------------------------------------------------------------------
  *
  * et131x_adapter.h - Header which includes the private adapter structure, along
diff --git a/drivers/staging/et131x/et131x_defs.h b/drivers/staging/et131x/et131x_defs.h
index 3d5193f..872a5af 100644
--- a/drivers/staging/et131x/et131x_defs.h
+++ b/drivers/staging/et131x/et131x_defs.h
@@ -6,6 +6,8 @@
  * All rights reserved.
  *   http://www.agere.com
  *
+ * Copyright (c) 2011 Mark Einon <mark.einon@gmail.com>
+ *
  *------------------------------------------------------------------------------
  *
  * et131x_defs.h - Defines, structs, enums, prototypes, etc. to assist with OS
diff --git a/drivers/staging/et131x/et131x_ethtool.c b/drivers/staging/et131x/et131x_ethtool.c
index c4555b9..903b5a0 100644
--- a/drivers/staging/et131x/et131x_ethtool.c
+++ b/drivers/staging/et131x/et131x_ethtool.c
@@ -1,5 +1,5 @@
 /*
- *  Copyright (C) 2011 Mark Einon
+ *  Copyright (c) 2011 Mark Einon <mark.einon@gmail.com>
  *
  *  This program is free software; you can redistribute it and/or modify
  *  it under the terms of the GNU General Public License as published by
@@ -14,8 +14,6 @@
  *  You should have received a copy of the GNU General Public License
  *  along with this program; if not, write to the Free Software
  *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
- *
- *  Mark Einon <mark.einon@gmail.com>
  */
 #include "et131x_version.h"
 #include "et131x_defs.h"
diff --git a/drivers/staging/et131x/et131x_initpci.c b/drivers/staging/et131x/et131x_initpci.c
index 8bff4a0..ed22615 100644
--- a/drivers/staging/et131x/et131x_initpci.c
+++ b/drivers/staging/et131x/et131x_initpci.c
@@ -6,6 +6,8 @@
  * All rights reserved.
  *   http://www.agere.com
  *
+ * Copyright (c) 2011 Mark Einon <mark.einon@gmail.com>
+ *
  *------------------------------------------------------------------------------
  *
  * et131x_initpci.c - Routines and data used to register the driver with the
@@ -945,5 +947,6 @@ module_exit(et131x_cleanup_module);
 
 /* Modinfo parameters (filled out using defines from et131x_version.h) */
 MODULE_AUTHOR(DRIVER_AUTHOR);
+MODULE_AUTHOR(DRIVER_AUTHOR2);
 MODULE_DESCRIPTION(DRIVER_INFO);
 MODULE_LICENSE(DRIVER_LICENSE);
diff --git a/drivers/staging/et131x/et131x_isr.c b/drivers/staging/et131x/et131x_isr.c
index fb108d2..bccd0e5 100644
--- a/drivers/staging/et131x/et131x_isr.c
+++ b/drivers/staging/et131x/et131x_isr.c
@@ -6,6 +6,8 @@
  * All rights reserved.
  *   http://www.agere.com
  *
+ * Copyright (c) 2011 Mark Einon <mark.einon@gmail.com>
+ *
  *------------------------------------------------------------------------------
  *
  * et131x_isr.c - File which contains the ISR, ISR handler, and related routines
diff --git a/drivers/staging/et131x/et131x_netdev.c b/drivers/staging/et131x/et131x_netdev.c
index 2184682..79127de 100644
--- a/drivers/staging/et131x/et131x_netdev.c
+++ b/drivers/staging/et131x/et131x_netdev.c
@@ -6,6 +6,8 @@
  * All rights reserved.
  *   http://www.agere.com
  *
+ * Copyright (c) 2011 Mark Einon <mark.einon@gmail.com>
+ *
  *------------------------------------------------------------------------------
  *
  * et131x_netdev.c - Routines and data required by all Linux network devices.
diff --git a/drivers/staging/et131x/et131x_version.h b/drivers/staging/et131x/et131x_version.h
index 2aa9bda..c08b5e5 100644
--- a/drivers/staging/et131x/et131x_version.h
+++ b/drivers/staging/et131x/et131x_version.h
@@ -59,6 +59,7 @@
 #define __ET131X_VERSION_H__
 
 #define DRIVER_AUTHOR		"Victor Soriano (vjsoriano@agere.com)"
+#define DRIVER_AUTHOR2		"Mark Einon (mark.einon@gmail.com)"
 #define DRIVER_LICENSE		"Dual BSD/GPL"
 #define DRIVER_DEVICE_STRING	"ET1310"
 #define DRIVER_NAME		"et131x"
-- 
1.7.6.4

