Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756880Ab0EKSIo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 14:08:44 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:60721 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756861Ab0EKSIm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 14:08:42 -0400
From: "Arce, Abraham" <x0066660@ti.com>
To: "trivial@kernel.org" <trivial@kernel.org>
CC: "bgardner@wabtec.com" <bgardner@wabtec.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Tue, 11 May 2010 13:08:37 -0500
Subject: [PATCH 3/3] EEPROM: max6875: Header file cleanup
Thread-Topic: [PATCH 3/3] EEPROM: max6875: Header file cleanup
Thread-Index: AcrxNPoZdIc9z/tHSy6ccu4fTfkvtA==
Message-ID: <27F9C60D11D683428E133F85D2BB4A53043DFD580B@dlee03.ent.ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change max6875.c  header file to format as in conventions

Signed-off-by: Abraham Arce <x0066660@ti.com>
---
 drivers/misc/eeprom/max6875.c |   52 ++++++++++++++++++++--------------------
 1 files changed, 26 insertions(+), 26 deletions(-)

diff --git a/drivers/misc/eeprom/max6875.c b/drivers/misc/eeprom/max6875.c
index 5a6b2bc..fe29092 100644
--- a/drivers/misc/eeprom/max6875.c
+++ b/drivers/misc/eeprom/max6875.c
@@ -1,30 +1,30 @@
 /*
-    max6875.c - driver for MAX6874/MAX6875
-
-    Copyright (C) 2005 Ben Gardner <bgardner@wabtec.com>
-
-    Based on eeprom.c
-
-    The MAX6875 has a bank of registers and two banks of EEPROM.
-    Address ranges are defined as follows:
-     * 0x0000 - 0x0046 = configuration registers
-     * 0x8000 - 0x8046 = configuration EEPROM
-     * 0x8100 - 0x82FF = user EEPROM
-
-    This driver makes the user EEPROM available for read.
-
-    The registers & config EEPROM should be accessed via i2c-dev.
-
-    The MAX6875 ignores the lowest address bit, so each chip responds to
-    two addresses - 0x50/0x51 and 0x52/0x53.
-
-    Note that the MAX6875 uses i2c_smbus_write_byte_data() to set the read
-    address, so this driver is destructive if loaded for the wrong EEPROM chip.
-
-    This program is free software; you can redistribute it and/or modify
-    it under the terms of the GNU General Public License as published by
-    the Free Software Foundation; version 2 of the License.
-*/
+ * max6875.c - driver for MAX6874/MAX6875
+ *
+ * Copyright (C) 2005 Ben Gardner <bgardner@wabtec.com>
+ *
+ * Based on eeprom.c
+ *
+ * The MAX6875 has a bank of registers and two banks of EEPROM.
+ * Address ranges are defined as follows:
+ *  * 0x0000 - 0x0046 = configuration registers
+ *  * 0x8000 - 0x8046 = configuration EEPROM
+ *  * 0x8100 - 0x82FF = user EEPROM
+ *
+ * This driver makes the user EEPROM available for read.
+ *
+ * The registers & config EEPROM should be accessed via i2c-dev.
+ *
+ * The MAX6875 ignores the lowest address bit, so each chip responds to
+ * two addresses - 0x50/0x51 and 0x52/0x53.
+ *
+ * Note that the MAX6875 uses i2c_smbus_write_byte_data() to set the read
+ * address, so this driver is destructive if loaded for the wrong EEPROM chip.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; version 2 of the License.
+ */
 
 #include <linux/kernel.h>
 #include <linux/init.h>
-- 
1.5.4.3

