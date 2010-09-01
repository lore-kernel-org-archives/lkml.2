Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754882Ab0IANlY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Sep 2010 09:41:24 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:38948 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754808Ab0IANlU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Sep 2010 09:41:20 -0400
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 2/6] staging/trivial: fix typos concerning "access"
Date: Wed,  1 Sep 2010 15:40:23 +0200
Message-Id: <1283348427-6183-2-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1283348427-6183-1-git-send-email-u.kleine-koenig@pengutronix.de>
References: <1283348427-6183-1-git-send-email-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
 .../comedi/drivers/addi-data/hwdrv_APCI1710.c      |    2 +-
 .../comedi/drivers/addi-data/hwdrv_apci035.c       |    2 +-
 .../comedi/drivers/addi-data/hwdrv_apci1032.c      |    2 +-
 .../comedi/drivers/addi-data/hwdrv_apci1500.c      |    2 +-
 .../comedi/drivers/addi-data/hwdrv_apci1516.c      |    2 +-
 .../comedi/drivers/addi-data/hwdrv_apci1564.c      |    2 +-
 .../comedi/drivers/addi-data/hwdrv_apci2016.c      |    2 +-
 .../comedi/drivers/addi-data/hwdrv_apci2032.c      |    2 +-
 .../comedi/drivers/addi-data/hwdrv_apci2200.c      |    2 +-
 .../comedi/drivers/addi-data/hwdrv_apci3200.c      |    2 +-
 .../comedi/drivers/addi-data/hwdrv_apci3501.c      |    2 +-
 drivers/staging/comedi/drivers/aio_aio12_8.c       |    6 +++---
 drivers/staging/comedi/drivers/aio_iiro_16.c       |    6 +++---
 drivers/staging/iio/accel/sca3000.h                |    2 +-
 drivers/staging/octeon/cvmx-fpa.c                  |    2 +-
 drivers/staging/octeon/cvmx-fpa.h                  |    2 +-
 16 files changed, 20 insertions(+), 20 deletions(-)

diff --git a/drivers/staging/comedi/drivers/addi-data/hwdrv_APCI1710.c b/drivers/staging/comedi/drivers/addi-data/hwdrv_APCI1710.c
index 129b2f9..7bd931c 100644
--- a/drivers/staging/comedi/drivers/addi-data/hwdrv_APCI1710.c
+++ b/drivers/staging/comedi/drivers/addi-data/hwdrv_APCI1710.c
@@ -33,7 +33,7 @@ You should also find the complete GPL in the COPYING file accompanying this sour
   +-------------------------------+---------------------------------------+
   | Project manager: Eric Stolz   | Date       :  02/12/2002              |
   +-------------------------------+---------------------------------------+
-  | Description :   Hardware Layer Acces For APCI-1710                    |
+  | Description :   Hardware Layer Access For APCI-1710                   |
   +-----------------------------------------------------------------------+
   |                             UPDATES                                   |
   +----------+-----------+------------------------------------------------+
diff --git a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci035.c b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci035.c
index 1369e22..cf63db6 100644
--- a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci035.c
+++ b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci035.c
@@ -34,7 +34,7 @@ You should also find the complete GPL in the COPYING file accompanying this sour
   +-------------------------------+---------------------------------------+
   | Project manager: Eric Stolz   | Date       :  02/12/2002              |
   +-------------------------------+---------------------------------------+
-  | Description :   Hardware Layer Acces For APCI-035                     |
+  | Description :   Hardware Layer Access For APCI-035                    |
   +-----------------------------------------------------------------------+
   |                             UPDATES                                   |
   +----------+-----------+------------------------------------------------+
diff --git a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1032.c b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1032.c
index faea003..fdcbdd8 100644
--- a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1032.c
+++ b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1032.c
@@ -34,7 +34,7 @@ You should also find the complete GPL in the COPYING file accompanying this sour
   +-------------------------------+---------------------------------------+
   | Project manager: Eric Stolz   | Date       :  02/12/2002              |
   +-------------------------------+---------------------------------------+
-  | Description :   Hardware Layer Acces For APCI-1032                    |
+  | Description :   Hardware Layer Access For APCI-1032                   |
   +-----------------------------------------------------------------------+
   |                             UPDATES                                   |
   +----------+-----------+------------------------------------------------+
diff --git a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1500.c b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1500.c
index b3b9218..ab492fb 100644
--- a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1500.c
+++ b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1500.c
@@ -34,7 +34,7 @@ You should also find the complete GPL in the COPYING file accompanying this sour
   +-------------------------------+---------------------------------------+
   | Project manager: Eric Stolz   | Date       :  02/12/2002              |
   +-------------------------------+---------------------------------------+
-  | Description :   Hardware Layer Acces For APCI-1500                    |
+  | Description :   Hardware Layer Access For APCI-1500                   |
   +-----------------------------------------------------------------------+
   |                             UPDATES                                   |
   +----------+-----------+------------------------------------------------+
diff --git a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1516.c b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1516.c
index 7948c41..9f93bc3 100644
--- a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1516.c
+++ b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1516.c
@@ -34,7 +34,7 @@ You should also find the complete GPL in the COPYING file accompanying this sour
   +-------------------------------+---------------------------------------+
   | Project manager: Eric Stolz   | Date       :  02/12/2002              |
   +-------------------------------+---------------------------------------+
-  | Description :   Hardware Layer Acces For APCI-1516                    |
+  | Description :   Hardware Layer Access For APCI-1516                   |
   +-----------------------------------------------------------------------+
   |                             UPDATES                                   |
   +----------+-----------+------------------------------------------------+
diff --git a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.c b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.c
index 4299ff5..a264fff 100644
--- a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.c
+++ b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.c
@@ -34,7 +34,7 @@ You should also find the complete GPL in the COPYING file accompanying this sour
   +-------------------------------+---------------------------------------+
   | Project manager: Eric Stolz   | Date       :  02/12/2002              |
   +-------------------------------+---------------------------------------+
-  | Description :   Hardware Layer Acces For APCI-1564                    |
+  | Description :   Hardware Layer Access For APCI-1564                   |
   +-----------------------------------------------------------------------+
   |                             UPDATES                                   |
   +----------+-----------+------------------------------------------------+
diff --git a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci2016.c b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci2016.c
index 89783b1..1baf2bf 100644
--- a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci2016.c
+++ b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci2016.c
@@ -34,7 +34,7 @@ You should also find the complete GPL in the COPYING file accompanying this sour
   +-------------------------------+---------------------------------------+
   | Project manager: Eric Stolz   | Date       :  02/12/2002              |
   +-------------------------------+---------------------------------------+
-  | Description :   Hardware Layer Acces For APCI-2016                    |
+  | Description :   Hardware Layer Access For APCI-2016                   |
   +-----------------------------------------------------------------------+
   |                             UPDATES                                   |
   +----------+-----------+------------------------------------------------+
diff --git a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci2032.c b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci2032.c
index d7d2223..fd135a5 100644
--- a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci2032.c
+++ b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci2032.c
@@ -34,7 +34,7 @@ You should also find the complete GPL in the COPYING file accompanying this sour
   +-------------------------------+---------------------------------------+
   | Project manager: Eric Stolz   | Date       :  02/12/2002              |
   +-------------------------------+---------------------------------------+
-  | Description :   Hardware Layer Acces For APCI-2032                    |
+  | Description :   Hardware Layer Access For APCI-2032                   |
   +-----------------------------------------------------------------------+
   |                             UPDATES                                   |
   +----------+-----------+------------------------------------------------+
diff --git a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci2200.c b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci2200.c
index e01889c..2726d66 100644
--- a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci2200.c
+++ b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci2200.c
@@ -34,7 +34,7 @@ You should also find the complete GPL in the COPYING file accompanying this sour
   +-------------------------------+---------------------------------------+
   | Project manager: Eric Stolz   | Date       :  02/12/2002              |
   +-------------------------------+---------------------------------------+
-  | Description :   Hardware Layer Acces For APCI-2200                    |
+  | Description :   Hardware Layer Access For APCI-2200                   |
   +-----------------------------------------------------------------------+
   |                             UPDATES                                   |
   +----------+-----------+------------------------------------------------+
diff --git a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci3200.c b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci3200.c
index 560c848..86e88ed 100644
--- a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci3200.c
+++ b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci3200.c
@@ -34,7 +34,7 @@ You should also find the complete GPL in the COPYING file accompanying this sour
   +-------------------------------+---------------------------------------+
   | Project manager: Eric Stolz   | Date       :  02/12/2002              |
   +-------------------------------+---------------------------------------+
-  | Description :   Hardware Layer Acces For APCI-3200                    |
+  | Description :   Hardware Layer Access For APCI-3200                   |
   +-----------------------------------------------------------------------+
   |                             UPDATES                                   |
   +----------+-----------+------------------------------------------------+
diff --git a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci3501.c b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci3501.c
index 4ed441a..b9e1ada 100644
--- a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci3501.c
+++ b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci3501.c
@@ -34,7 +34,7 @@ You should also find the complete GPL in the COPYING file accompanying this sour
   +-------------------------------+---------------------------------------+
   | Project manager: Eric Stolz   | Date       :  02/12/2002              |
   +-------------------------------+---------------------------------------+
-  | Description :   Hardware Layer Acces For APCI-3501                    |
+  | Description :   Hardware Layer Access For APCI-3501                   |
   +-----------------------------------------------------------------------+
   |                             UPDATES                                   |
   +----------+-----------+------------------------------------------------+
diff --git a/drivers/staging/comedi/drivers/aio_aio12_8.c b/drivers/staging/comedi/drivers/aio_aio12_8.c
index 1728cc0..b0f98e5 100644
--- a/drivers/staging/comedi/drivers/aio_aio12_8.c
+++ b/drivers/staging/comedi/drivers/aio_aio12_8.c
@@ -2,7 +2,7 @@
 
     comedi/drivers/aio_aio12_8.c
 
-    Driver for Acces I/O Products PC-104 AIO12-8 Analog I/O Board
+    Driver for Access I/O Products PC-104 AIO12-8 Analog I/O Board
     Copyright (C) 2006 C&C Technologies, Inc.
 
     This program is free software; you can redistribute it and/or modify
@@ -23,10 +23,10 @@
 /*
 
 Driver: aio_aio12_8
-Description: Acces I/O Products PC-104 AIO12-8 Analog I/O Board
+Description: Access I/O Products PC-104 AIO12-8 Analog I/O Board
 Author: Pablo Mejia <pablo.mejia@cctechnol.com>
 Devices:
- [Acces I/O] PC-104 AIO12-8
+ [Access I/O] PC-104 AIO12-8
 Status: experimental
 
 Configuration Options:
diff --git a/drivers/staging/comedi/drivers/aio_iiro_16.c b/drivers/staging/comedi/drivers/aio_iiro_16.c
index 4875995..160b0a0 100644
--- a/drivers/staging/comedi/drivers/aio_iiro_16.c
+++ b/drivers/staging/comedi/drivers/aio_iiro_16.c
@@ -2,7 +2,7 @@
 
     comedi/drivers/aio_iiro_16.c
 
-    Driver for Acces I/O Products PC-104 AIO-IIRO-16 Digital I/O board
+    Driver for Access I/O Products PC-104 AIO-IIRO-16 Digital I/O board
     Copyright (C) 2006 C&C Technologies, Inc.
 
     This program is free software; you can redistribute it and/or modify
@@ -23,10 +23,10 @@
 /*
 
 Driver: aio_iiro_16
-Description: Acces I/O Products PC-104 IIRO16 Relay And Isolated Input Board
+Description: Access I/O Products PC-104 IIRO16 Relay And Isolated Input Board
 Author: Zachary Ware <zach.ware@cctechnol.com>
 Devices:
- [Acces I/O] PC-104 AIO12-8
+ [Access I/O] PC-104 AIO12-8
 Status: experimental
 
 Configuration Options:
diff --git a/drivers/staging/iio/accel/sca3000.h b/drivers/staging/iio/accel/sca3000.h
index 09d9470..2389284 100644
--- a/drivers/staging/iio/accel/sca3000.h
+++ b/drivers/staging/iio/accel/sca3000.h
@@ -91,7 +91,7 @@
 #define SCA3000_INT_STATUS_X_TRIGGER		0x02
 #define SCA3000_INT_STATUS_Z_TRIGGER		0x01
 
-/* Used to allow accesss to multiplexed registers */
+/* Used to allow access to multiplexed registers */
 #define SCA3000_REG_ADDR_CTRL_SEL		0x18
 /* Only available for SCA3000-D03 and SCA3000-D01 */
 #define SCA3000_REG_CTRL_SEL_I2C_DISABLE	0x01
diff --git a/drivers/staging/octeon/cvmx-fpa.c b/drivers/staging/octeon/cvmx-fpa.c
index 55d9147..ad44b8b 100644
--- a/drivers/staging/octeon/cvmx-fpa.c
+++ b/drivers/staging/octeon/cvmx-fpa.c
@@ -53,7 +53,7 @@ CVMX_SHARED cvmx_fpa_pool_info_t cvmx_fpa_pool_info[CVMX_FPA_NUM_POOLS];
  * @name:       Constant character string to name this pool.
  *                   String is not copied.
  * @buffer:     Pointer to the block of memory to use. This must be
- *                   accessable by all processors and external hardware.
+ *                   accessible by all processors and external hardware.
  * @block_size: Size for each block controlled by the FPA
  * @num_blocks: Number of blocks
  *
diff --git a/drivers/staging/octeon/cvmx-fpa.h b/drivers/staging/octeon/cvmx-fpa.h
index 1d7788f..50a8c91 100644
--- a/drivers/staging/octeon/cvmx-fpa.h
+++ b/drivers/staging/octeon/cvmx-fpa.h
@@ -264,7 +264,7 @@ static inline void cvmx_fpa_free(void *ptr, uint64_t pool,
  * @name:       Constant character string to name this pool.
  *                   String is not copied.
  * @buffer:     Pointer to the block of memory to use. This must be
- *                   accessable by all processors and external hardware.
+ *                   accessible by all processors and external hardware.
  * @block_size: Size for each block controlled by the FPA
  * @num_blocks: Number of blocks
  *
-- 
1.7.1

