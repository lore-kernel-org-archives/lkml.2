Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754674Ab1EXIeY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 04:34:24 -0400
Received: from eu1sys200aog102.obsmtp.com ([207.126.144.113]:53957 "EHLO
	eu1sys200aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754530Ab1EXIeW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 04:34:22 -0400
From: Viresh Kumar <viresh.kumar@st.com>
To: <vinod.koul@intel.com>, <dan.j.williams@intel.com>
Cc: <linux-kernel@vger.kernel.org>, <shiraz.hashim@st.com>,
        <armando.visconti@st.com>, <viresh.linux@gmail.com>,
        Viresh Kumar <viresh.kumar@st.com>
Subject: [PATCH resend] dmaengine/dw_dmac: Update maintainer-ship
Date: Tue, 24 May 2011 14:04:09 +0530
Message-ID: <fd5b04cbce5c1051dee3faf0719f6db3ee706e60.1306226016.git.viresh.kumar@st.com>
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
index 2a2e2fa..da7e19c 100644
--- a/drivers/dma/dw_dmac.c
+++ b/drivers/dma/dw_dmac.c
@@ -3,6 +3,7 @@
  * AVR32 systems.)
  *
  * Copyright (C) 2007-2008 Atmel Corporation
+ * Copyright (C) 2010-2011 ST Microelectronics
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -1487,3 +1488,4 @@ module_exit(dw_exit);
 MODULE_LICENSE("GPL v2");
 MODULE_DESCRIPTION("Synopsys DesignWare DMA Controller driver");
 MODULE_AUTHOR("Haavard Skinnemoen (Atmel)");
+MODULE_AUTHOR("Viresh Kumar <viresh.kumar@st.com>");
diff --git a/drivers/dma/dw_dmac_regs.h b/drivers/dma/dw_dmac_regs.h
index 720f821..3df8027 100644
--- a/drivers/dma/dw_dmac_regs.h
+++ b/drivers/dma/dw_dmac_regs.h
@@ -2,6 +2,7 @@
  * Driver for the Synopsys DesignWare AHB DMA Controller
  *
  * Copyright (C) 2005-2007 Atmel Corporation
+ * Copyright (C) 2010-2011 ST Microelectronics
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
diff --git a/include/linux/dw_dmac.h b/include/linux/dw_dmac.h
index 6998d93..4bfe0a2 100644
--- a/include/linux/dw_dmac.h
+++ b/include/linux/dw_dmac.h
@@ -3,6 +3,7 @@
  * AVR32 systems.)
  *
  * Copyright (C) 2007 Atmel Corporation
+ * Copyright (C) 2010-2011 ST Microelectronics
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
-- 
1.7.2.2

