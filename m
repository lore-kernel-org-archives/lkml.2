Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756340Ab2IZMlW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 08:41:22 -0400
Received: from mga11.intel.com ([192.55.52.93]:59302 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756198Ab2IZMkt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 08:40:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,490,1344236400"; 
   d="scan'208";a="227034195"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Viresh Kumar <viresh.linux@gmail.com>, Vinod Koul <vinod.koul@intel.com>,
        linux-kernel@vger.kernel.org
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCHv2 4/4] MAINTAINERS: add recently created files to dw_dmac section
Date: Wed, 26 Sep 2012 15:40:37 +0300
Message-Id: <1348663237-3237-5-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1348663237-3237-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1348575190-11761-1-git-send-email-andriy.shevchenko@linux.intel.com>
 <1348663237-3237-1-git-send-email-andriy.shevchenko@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Append myself to mail subsection as well.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 MAINTAINERS |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 7dfd0eb..b87cbb1d 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5999,10 +5999,10 @@ F:	drivers/tty/serial
 
 SYNOPSYS DESIGNWARE DMAC DRIVER
 M:	Viresh Kumar <viresh.linux@gmail.com>
+M:	Andy Shevchenko <andriy.shevchenko@linux.intel.com>
 S:	Maintained
 F:	include/linux/dw_dmac.h
-F:	drivers/dma/dw_dmac_regs.h
-F:	drivers/dma/dw_dmac.c
+F:	drivers/dma/dw/
 
 TIMEKEEPING, NTP
 M:	John Stultz <johnstul@us.ibm.com>
-- 
1.7.10.4

