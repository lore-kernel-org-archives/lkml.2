Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753598Ab1EXHOr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 03:14:47 -0400
Received: from eu1sys200aog111.obsmtp.com ([207.126.144.131]:52058 "EHLO
	eu1sys200aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752282Ab1EXHOq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 03:14:46 -0400
From: Viresh Kumar <viresh.kumar@st.com>
To: <vinod.koul@intel.com>, <dan.j.williams@intel.com>
Cc: <linux-kernel@vger.kernel.org>, <shiraz.hashim@st.com>,
        <armando.visconti@st.com>, <viresh.linux@gmail.com>,
        Viresh Kumar <viresh.kumar@st.com>
Subject: [PATCH] dmaengine/dw_dmac: Update maintainer-ship
Date: Tue, 24 May 2011 12:44:27 +0530
Message-ID: <f7a8ea363d81ddbfab43272711cb482e700540e5.1306220852.git.viresh.kumar@st.com>
X-Mailer: git-send-email 1.7.2.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nobody is currently maintaining dw_dmac. We are using dw_dmac for SPEAr13xx and
are currently maintaining it. After discussing with Vinod, sending this patch to
update maintainer-ship of dw_dmac.

Signed-off-by: Viresh Kumar <viresh.kumar@st.com>
---
 MAINTAINERS                |    7 +++++++
 drivers/dma/dw_dmac.c      |    2 ++
 drivers/dma/dw_dmac_regs.h |    1 +
 include/linux/dw_dmac.h    |    1 +
 4 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 0b41524..a911177 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5430,6 +5430,13 @@ L:	linux-serial@vger.kernel.org
 S:	Maintained
 F:	drivers/tty/serial
 
+SYNOPSYS DESIGNWARE DMAC DRIVER
+M:	Viresh Kumar <viresh.kumar@st.com>
+S:	Maintained
+F:	include/linux/dw_dmac.h
+F:	drivers/dma/dw_dmac_regs.h
+F:	drivers/dma/dw_dmac.c
+
 TIMEKEEPING, NTP
 M:	John Stultz <johnstul@us.ibm.com>
 M:	Thomas Gleixner <tglx@linutronix.de>
diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c
index 2a2e2fa..08e2202 100644
--- a/drivers/dma/dw_dmac.c
+++ b/drivers/dma/dw_dmac.c
@@ -3,6 +3,7 @@
  * AVR32 systems.)
  *
  * Copyright (C) 2007-2008 Atmel Corporation
+ * Copyright (c) 2011-2012 Viresh Kumar <viresh.kumar@st.com>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -1487,3 +1488,4 @@ module_exit(dw_exit);
 MODULE_LICENSE("GPL v2");
 MODULE_DESCRIPTION("Synopsys DesignWare DMA Controller driver");
 MODULE_AUTHOR("Haavard Skinnemoen (Atmel)");
+MODULE_AUTHOR("Viresh Kumar <viresh.kumar@st.com>");
diff --git a/drivers/dma/dw_dmac_regs.h b/drivers/dma/dw_dmac_regs.h
index 720f821..6cb1da1 100644
--- a/drivers/dma/dw_dmac_regs.h
+++ b/drivers/dma/dw_dmac_regs.h
@@ -2,6 +2,7 @@
  * Driver for the Synopsys DesignWare AHB DMA Controller
  *
  * Copyright (C) 2005-2007 Atmel Corporation
+ * Copyright (c) 2011-2012 Viresh Kumar <viresh.kumar@st.com>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
diff --git a/include/linux/dw_dmac.h b/include/linux/dw_dmac.h
index 6998d93..ea57c4b 100644
--- a/include/linux/dw_dmac.h
+++ b/include/linux/dw_dmac.h
@@ -3,6 +3,7 @@
  * AVR32 systems.)
  *
  * Copyright (C) 2007 Atmel Corporation
+ * Copyright (c) 2011-2012 Viresh Kumar <viresh.kumar@st.com>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
-- 
1.7.2.2

