Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756153Ab2IYMNl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 08:13:41 -0400
Received: from mga03.intel.com ([143.182.124.21]:18847 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755932Ab2IYMNh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 08:13:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,481,1344236400"; 
   d="scan'208";a="148805907"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Viresh Kumar <viresh.linux@gmail.com>, Vinod Koul <vinod.koul@intel.com>,
        linux-kernel@vger.kernel.org
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCHv1 6/6] MAINTAINERS: add recently created files to dw_dmac section
Date: Tue, 25 Sep 2012 15:13:10 +0300
Message-Id: <1348575190-11761-7-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1348575190-11761-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1348575190-11761-1-git-send-email-andriy.shevchenko@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 MAINTAINERS |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 479a655..1a169f6 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6007,10 +6007,13 @@ F:	drivers/tty/serial
 
 SYNOPSYS DESIGNWARE DMAC DRIVER
 M:	Viresh Kumar <viresh.linux@gmail.com>
+M:	Andy Shevchenko <andriy.shevchenko@linux.intel.com>
 S:	Maintained
 F:	include/linux/dw_dmac.h
 F:	drivers/dma/dw_dmac_regs.h
 F:	drivers/dma/dw_dmac.c
+F:	drivers/dma/dw_dmac_at32.c
+F:	drivers/dma/dw_dmac_pci.c
 
 TIMEKEEPING, NTP
 M:	John Stultz <johnstul@us.ibm.com>
-- 
1.7.10.4

