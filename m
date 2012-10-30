Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933715Ab2J3McZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 08:32:25 -0400
Received: from mga01.intel.com ([192.55.52.88]:26720 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932922Ab2J3McX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 08:32:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,679,1344236400"; 
   d="scan'208";a="240265119"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Viresh Kumar <viresh.linux@gmail.com>, Vinod Koul <vinod.koul@intel.com>,
        linux-kernel@vger.kernel.org, spear-devel <spear-devel@list.st.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 3/3] MAINTAINERS: add recently created files to dw_dmac section
Date: Tue, 30 Oct 2012 14:32:12 +0200
Message-Id: <1351600332-29443-4-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1351600332-29443-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1351600332-29443-1-git-send-email-andriy.shevchenko@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The DesignWare DMAC driver is moved to an own directory. The patch updates
MAINTAINERS file accordingly.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 MAINTAINERS |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index a2a3434..edf99d0 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6293,8 +6293,7 @@ SYNOPSYS DESIGNWARE DMAC DRIVER
 M:	Viresh Kumar <viresh.linux@gmail.com>
 S:	Maintained
 F:	include/linux/dw_dmac.h
-F:	drivers/dma/dw_dmac_regs.h
-F:	drivers/dma/dw_dmac.c
+F:	drivers/dma/dw/
 
 TIMEKEEPING, NTP
 M:	John Stultz <johnstul@us.ibm.com>
-- 
1.7.10.4

