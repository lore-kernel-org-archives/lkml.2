Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753765Ab1HAJkF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 05:40:05 -0400
Received: from eu1sys200aog101.obsmtp.com ([207.126.144.111]:58541 "EHLO
	eu1sys200aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753415Ab1HAJjZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 05:39:25 -0400
From: Viresh Kumar <viresh.kumar@st.com>
To: <linus.walleij@linaro.org>
Cc: <vinod.koul@intel.com>, <dan.j.williams@intel.com>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux@arm.linux.org.uk>, <armando.visconti@st.com>,
        <shiraz.hashim@st.com>, <vipin.kumar@st.com>,
        <rajeev-dlh.kumar@st.com>, <deepak.sikri@st.com>,
        <vipulkumar.samar@st.com>, <amit.virdi@st.com>, <viresh.kumar@st.com>,
        <pratyush.anand@st.com>, <bhupesh.sharma@st.com>,
        <viresh.linux@gmail.com>
Subject: [PATCH V2 03/20] dmaengine/amba-pl08x: Rearrange inclusion of header files in ascending order
Date: Mon, 1 Aug 2011 15:07:13 +0530
Message-ID: <16f5abd9452832860f3a11fe1ddabde05fa3ae8c.1312190881.git.viresh.kumar@st.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <cover.1312190881.git.viresh.kumar@st.com>
References: <cover.1312190881.git.viresh.kumar@st.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Header files included in driver are not present in alphabetical order. Rearrange
them in alphabetical order.

Signed-off-by: Viresh Kumar <viresh.kumar@st.com>
---
 drivers/dma/amba-pl08x.c |   17 ++++++++---------
 1 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/drivers/dma/amba-pl08x.c b/drivers/dma/amba-pl08x.c
index 4c4a309..8e2056b 100644
--- a/drivers/dma/amba-pl08x.c
+++ b/drivers/dma/amba-pl08x.c
@@ -74,19 +74,18 @@
  * Global TODO:
  * - Break out common code from arch/arm/mach-s3c64xx and share
  */
-#include <linux/device.h>
-#include <linux/init.h>
-#include <linux/module.h>
-#include <linux/interrupt.h>
-#include <linux/slab.h>
-#include <linux/delay.h>
-#include <linux/dmapool.h>
-#include <linux/dmaengine.h>
 #include <linux/amba/bus.h>
 #include <linux/amba/pl08x.h>
 #include <linux/debugfs.h>
+#include <linux/delay.h>
+#include <linux/device.h>
+#include <linux/dmaengine.h>
+#include <linux/dmapool.h>
+#include <linux/init.h>
+#include <linux/interrupt.h>
+#include <linux/module.h>
 #include <linux/seq_file.h>
-
+#include <linux/slab.h>
 #include <asm/hardware/pl080.h>
 
 #define DRIVER_NAME	"pl08xdmac"
-- 
1.7.2.2

