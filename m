Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753304Ab2IZHvM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 03:51:12 -0400
Received: from service87.mimecast.com ([91.220.42.44]:56872 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752809Ab2IZHvK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 03:51:10 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, spear-devel@list.st.com,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH] MAINTAINERS: fix indentation for Viresh Kumar
Date: Wed, 26 Sep 2012 13:20:59 +0530
Message-Id: <236507874d6759bd3dc2ec8feca89a5d2971222c.1348645812.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
X-OriginalArrivalTime: 26 Sep 2012 07:51:08.0700 (UTC) FILETIME=[B08F8DC0:01CD9BBB]
X-MC-Unique: 112092608510900201
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id q8Q7pGVY030246

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 MAINTAINERS | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index f9d40d1..7dfd0eb 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -572,7 +572,7 @@ F:	drivers/net/appletalk/
 F:	net/appletalk/
 
 ARASAN COMPACT FLASH PATA CONTROLLER
-M:     Viresh Kumar <viresh.linux@gmail.com>
+M:	Viresh Kumar <viresh.linux@gmail.com>
 L:	linux-ide@vger.kernel.org
 S:	Maintained
 F:	include/linux/pata_arasan_cf_data.h
@@ -5998,7 +5998,7 @@ S:	Maintained
 F:	drivers/tty/serial
 
 SYNOPSYS DESIGNWARE DMAC DRIVER
-M:     Viresh Kumar <viresh.linux@gmail.com>
+M:	Viresh Kumar <viresh.linux@gmail.com>
 S:	Maintained
 F:	include/linux/dw_dmac.h
 F:	drivers/dma/dw_dmac_regs.h
@@ -6146,7 +6146,7 @@ S:	Maintained
 F:	drivers/mmc/host/sdhci-s3c.c
 
 SECURE DIGITAL HOST CONTROLLER INTERFACE (SDHCI) ST SPEAR DRIVER
-M:     Viresh Kumar <viresh.linux@gmail.com>
+M:	Viresh Kumar <viresh.linux@gmail.com>
 L:	spear-devel@list.st.com
 L:	linux-mmc@vger.kernel.org
 S:	Maintained
@@ -6517,7 +6517,7 @@ S:	Maintained
 F:	include/linux/compiler.h
 
 SPEAR PLATFORM SUPPORT
-M:     Viresh Kumar <viresh.linux@gmail.com>
+M:	Viresh Kumar <viresh.linux@gmail.com>
 M:	Shiraz Hashim <shiraz.hashim@st.com>
 L:	spear-devel@list.st.com
 L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
@@ -6526,7 +6526,7 @@ S:	Maintained
 F:	arch/arm/plat-spear/
 
 SPEAR13XX MACHINE SUPPORT
-M:     Viresh Kumar <viresh.linux@gmail.com>
+M:	Viresh Kumar <viresh.linux@gmail.com>
 M:	Shiraz Hashim <shiraz.hashim@st.com>
 L:	spear-devel@list.st.com
 L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
@@ -6535,7 +6535,7 @@ S:	Maintained
 F:	arch/arm/mach-spear13xx/
 
 SPEAR3XX MACHINE SUPPORT
-M:     Viresh Kumar <viresh.linux@gmail.com>
+M:	Viresh Kumar <viresh.linux@gmail.com>
 M:	Shiraz Hashim <shiraz.hashim@st.com>
 L:	spear-devel@list.st.com
 L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
@@ -6546,7 +6546,7 @@ F:	arch/arm/mach-spear3xx/
 SPEAR6XX MACHINE SUPPORT
 M:	Rajeev Kumar <rajeev-dlh.kumar@st.com>
 M:	Shiraz Hashim <shiraz.hashim@st.com>
-M:     Viresh Kumar <viresh.linux@gmail.com>
+M:	Viresh Kumar <viresh.linux@gmail.com>
 L:	spear-devel@list.st.com
 L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 W:	http://www.st.com/spear
@@ -6554,7 +6554,7 @@ S:	Maintained
 F:	arch/arm/mach-spear6xx/
 
 SPEAR CLOCK FRAMEWORK SUPPORT
-M:     Viresh Kumar <viresh.linux@gmail.com>
+M:	Viresh Kumar <viresh.linux@gmail.com>
 L:	spear-devel@list.st.com
 L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 W:	http://www.st.com/spear
-- 
1.7.12.rc2.18.g61b472e


