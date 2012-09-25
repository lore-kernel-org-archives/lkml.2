Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756124Ab2IYMNj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 08:13:39 -0400
Received: from mga02.intel.com ([134.134.136.20]:45702 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751708Ab2IYMNg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 08:13:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,481,1344236400"; 
   d="scan'208";a="197405217"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Viresh Kumar <viresh.linux@gmail.com>, Vinod Koul <vinod.koul@intel.com>,
        linux-kernel@vger.kernel.org
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCHv1 5/6] MAINTAINERS: fix indentation for Viresh Kumar
Date: Tue, 25 Sep 2012 15:13:09 +0300
Message-Id: <1348575190-11761-6-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1348575190-11761-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1348575190-11761-1-git-send-email-andriy.shevchenko@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Viresh Kumar <viresh.linux@gmail.com>
---
 MAINTAINERS |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 8fa0255..479a655 100644
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
@@ -6006,7 +6006,7 @@ S:	Maintained
 F:	drivers/tty/serial
 
 SYNOPSYS DESIGNWARE DMAC DRIVER
-M:     Viresh Kumar <viresh.linux@gmail.com>
+M:	Viresh Kumar <viresh.linux@gmail.com>
 S:	Maintained
 F:	include/linux/dw_dmac.h
 F:	drivers/dma/dw_dmac_regs.h
@@ -6154,7 +6154,7 @@ S:	Maintained
 F:	drivers/mmc/host/sdhci-s3c.c
 
 SECURE DIGITAL HOST CONTROLLER INTERFACE (SDHCI) ST SPEAR DRIVER
-M:     Viresh Kumar <viresh.linux@gmail.com>
+M:	Viresh Kumar <viresh.linux@gmail.com>
 L:	spear-devel@list.st.com
 L:	linux-mmc@vger.kernel.org
 S:	Maintained
@@ -6524,7 +6524,7 @@ S:	Maintained
 F:	include/linux/compiler.h
 
 SPEAR PLATFORM SUPPORT
-M:     Viresh Kumar <viresh.linux@gmail.com>
+M:	Viresh Kumar <viresh.linux@gmail.com>
 M:	Shiraz Hashim <shiraz.hashim@st.com>
 L:	spear-devel@list.st.com
 L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
@@ -6533,7 +6533,7 @@ S:	Maintained
 F:	arch/arm/plat-spear/
 
 SPEAR13XX MACHINE SUPPORT
-M:     Viresh Kumar <viresh.linux@gmail.com>
+M:	Viresh Kumar <viresh.linux@gmail.com>
 M:	Shiraz Hashim <shiraz.hashim@st.com>
 L:	spear-devel@list.st.com
 L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
@@ -6542,7 +6542,7 @@ S:	Maintained
 F:	arch/arm/mach-spear13xx/
 
 SPEAR3XX MACHINE SUPPORT
-M:     Viresh Kumar <viresh.linux@gmail.com>
+M:	Viresh Kumar <viresh.linux@gmail.com>
 M:	Shiraz Hashim <shiraz.hashim@st.com>
 L:	spear-devel@list.st.com
 L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
@@ -6553,7 +6553,7 @@ F:	arch/arm/mach-spear3xx/
 SPEAR6XX MACHINE SUPPORT
 M:	Rajeev Kumar <rajeev-dlh.kumar@st.com>
 M:	Shiraz Hashim <shiraz.hashim@st.com>
-M:     Viresh Kumar <viresh.linux@gmail.com>
+M:	Viresh Kumar <viresh.linux@gmail.com>
 L:	spear-devel@list.st.com
 L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 W:	http://www.st.com/spear
@@ -6561,7 +6561,7 @@ S:	Maintained
 F:	arch/arm/mach-spear6xx/
 
 SPEAR CLOCK FRAMEWORK SUPPORT
-M:     Viresh Kumar <viresh.linux@gmail.com>
+M:	Viresh Kumar <viresh.linux@gmail.com>
 L:	spear-devel@list.st.com
 L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 W:	http://www.st.com/spear
-- 
1.7.10.4

