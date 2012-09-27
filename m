Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757196Ab2I0Hc0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 03:32:26 -0400
Received: from mga14.intel.com ([143.182.124.37]:55115 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757069Ab2I0HcO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 03:32:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,494,1344236400"; 
   d="scan'208";a="149719440"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Viresh Kumar <viresh.linux@gmail.com>, Vinod Koul <vinod.koul@intel.com>,
        linux-kernel@vger.kernel.org, spear-devel <spear-devel@list.st.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCHv3 7/7] MAINTAINERS: add recently created files to dw_dmac section
Date: Thu, 27 Sep 2012 10:32:01 +0300
Message-Id: <1348731121-2515-8-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1348731121-2515-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1348731121-2515-1-git-send-email-andriy.shevchenko@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Append myself to the mail entry of the section as well.

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

