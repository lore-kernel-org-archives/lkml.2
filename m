Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752127Ab1ECFg3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 01:36:29 -0400
Received: from mhqmail.moxa.com ([218.210.60.130]:41709 "EHLO
	mhqmail01.moxa.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751419Ab1ECFg2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 01:36:28 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="big5"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH 1/2] watchdog: add support for MOXA V2100 watchdog driver
Date: Tue, 3 May 2011 13:36:26 +0800
Message-ID: <ECB3782BB8F03341905DD923270296115F7122@mhqms01.moxa.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 1/2] watchdog: add support for MOXA V2100 watchdog driver
Thread-Index: AcwD/NBMCatjKIfPTFqwalST3J4LDgFVsldQAAANs0A=
From: =?big5?B?SmltbXkgQ2hlbiAos6+lw7lGKQ==?= <jimmy.chen@moxa.com>
To: =?big5?B?SmltbXkgQ2hlbiAos6+lw7lGKQ==?= <jimmy.chen@moxa.com>,
        <linux-kernel@vger.kernel.org>, <linux-watchdog@vger.kernel.org>,
        <wim@iguana.be>
X-OriginalArrivalTime: 03 May 2011 05:36:27.0165 (UTC) FILETIME=[0C172CD0:01CC0954]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jimmy Chen <jimmy.chen@moxa.com>

Add selection and help in menu to support watchdog driver

Signed-off-by: Jimmy Chen <jimmy.chen@moxa.com>
---
diff --git a/drivers/watchdog/Kconfig b/drivers/watchdog/Kconfig
index 1b0f98b..39a6c65 100644
--- a/drivers/watchdog/Kconfig
+++ b/drivers/watchdog/Kconfig
@@ -384,6 +384,18 @@ config ADVANTECH_WDT
 	  feature. More information can be found at
 	  <http://www.advantech.com.tw/products/>
 
+config MOXA_WDT
+	tristate "MOXA V2100 WATCHDOG driver"
+	depends on X86
+	default n
+	help
+	  If you say yes here you get support for the MOXA V2100 watchdog
+	  driver.
+
+	  This driver can also be built as a module.  If so, the module
+	  will be called moxa_swtd. More information can be found at
+	  <http://www.moxa.com>
+
 config ALIM1535_WDT
 	tristate "ALi M1535 PMU Watchdog Timer"
 	depends on X86 && PCI
diff --git a/drivers/watchdog/Makefile b/drivers/watchdog/Makefile
index 3f8608b..da1200e 100644
--- a/drivers/watchdog/Makefile
+++ b/drivers/watchdog/Makefile
@@ -65,6 +65,7 @@ obj-$(CONFIG_BFIN_WDT) += bfin_wdt.o
 # X86 (i386 + ia64 + x86_64) Architecture
 obj-$(CONFIG_ACQUIRE_WDT) += acquirewdt.o
 obj-$(CONFIG_ADVANTECH_WDT) += advantechwdt.o
+obj-$(CONFIG_MOXA_WDT)	+= moxa_wdt.o
 obj-$(CONFIG_ALIM1535_WDT) += alim1535_wdt.o
 obj-$(CONFIG_ALIM7101_WDT) += alim7101_wdt.o
 obj-$(CONFIG_F71808E_WDT) += f71808e_wdt.o
--
To unsubscribe from this list: send the line "unsubscribe 
linux-kernel" in the body of a message to majordomo@vger.kernel.org 
More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/
