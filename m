Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758053Ab1DYCac (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Apr 2011 22:30:32 -0400
Received: from mhqmail.moxa.com ([59.124.42.180]:14582 "EHLO
	mhqmail01.moxa.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758041Ab1DYCaP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Apr 2011 22:30:15 -0400
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="big5"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH 1/2] misc: add option in menu to support MOXA V2100 serial io driver
X-MimeOLE: Produced By Microsoft Exchange V6.5
Date: Mon, 25 Apr 2011 10:28:07 +0800
Message-ID: <ECB3782BB8F03341905DD923270296115D5ABC@mhqms01.moxa.com>
In-Reply-To: <ECB3782BB8F03341905DD923270296115D5A18@mhqms01.moxa.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 1/2] misc: add option in menu to support MOXA V2100 serial io driver
Thread-Index: AcwA0y++eDmjYMfeS5uFGN/WQ83uQQAAETrgAAA4trAAABnAcACGpmwQ
From: =?big5?B?SmltbXkgQ2hlbiAos6+lw7lGKQ==?= <jimmy.chen@moxa.com>
To: =?big5?B?SmltbXkgQ2hlbiAos6+lw7lGKQ==?= <jimmy.chen@moxa.com>,
        <linux-kernel@vger.kernel.org>
Cc: <gregkh@suse.de>
X-OriginalArrivalTime: 25 Apr 2011 02:28:07.0824 (UTC) FILETIME=[69DA9100:01CC02F0]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jimmy Chen <jimmy.chen@moxa.com>

Add selection and help in menu to support moxa_serial_io driver.

Signed-off-by: Jimmy Chen <jimmy.chen@moxa.com>
---
diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
index 45cc6f8..4e007c6 100644
--- a/drivers/misc/Kconfig
+++ b/drivers/misc/Kconfig
@@ -144,17 +144,6 @@ config PHANTOM
          If you choose to build module, its name will be phantom. If unsure,
          say N here.

-config MOXA_SERIAL_IO
-       tristate "V2100-LX Serial IO"
-       depends on X86
-       help
-         Say Y here if you want to build a driver for MOXA serial io device.
-
-         This driver is only for V2100-LX platform.
-
-         If you choose to build module, its name will be mxsio. If unsure,
-         say N here.
-
 config SGI_IOC4
        tristate "SGI IOC4 Base IO support"
        depends on PCI
diff --git a/drivers/misc/Makefile b/drivers/misc/Makefile
index 781fe3b..f546860 100644
--- a/drivers/misc/Makefile
+++ b/drivers/misc/Makefile
@@ -15,7 +15,6 @@ obj-$(CONFIG_LKDTM)           += lkdtm.o
 obj-$(CONFIG_TIFM_CORE)        += tifm_core.o
 obj-$(CONFIG_TIFM_7XX1)        += tifm_7xx1.o
 obj-$(CONFIG_PHANTOM)          += phantom.o
-obj-$(CONFIG_MOXA_SERIAL_IO)   += moxa_serial_io.o
 obj-$(CONFIG_SENSORS_BH1780)   += bh1780gli.o
 obj-$(CONFIG_SENSORS_BH1770)   += bh1770glc.o
 obj-$(CONFIG_SENSORS_APDS990X) += apds990x.o
diff --git a/drivers/misc/moxa_serial_io.c b/drivers/misc/moxa_serial_io.c
deleted file mode 100644
index e69de29..0000000
diff --git a/drivers/misc/moxa_serial_io.h b/drivers/misc/moxa_serial_io.h
deleted file mode 100644
index e69de29..0000000
--
To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/
