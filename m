Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932301Ab2KVS4f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 13:56:35 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:63222 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756049Ab2KVS4a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:56:30 -0500
From: Viresh Kumar <viresh.kumar@linaro.org>
To: sameo@linux.intel.com
Cc: devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        spear-devel@list.st.com, lee.jones@linaro.org,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH V1 1/3] mfd: stmpe: Arrange #include <header files> in alphabetical order
Date: Fri, 23 Nov 2012 00:26:18 +0530
Message-Id: <57384ebc52c7d39d1bae31ba3baa6f820b4ac696.1353610436.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This helps managing them better and also reduces chances of adding an header
file twice.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/mfd/stmpe-spi.c | 2 +-
 drivers/mfd/stmpe.c     | 6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/mfd/stmpe-spi.c b/drivers/mfd/stmpe-spi.c
index 9edfe86..f86e3fc 100644
--- a/drivers/mfd/stmpe-spi.c
+++ b/drivers/mfd/stmpe-spi.c
@@ -7,10 +7,10 @@
  * Author: Viresh Kumar <viresh.linux@gmail.com> for ST Microelectronics
  */
 
-#include <linux/spi/spi.h>
 #include <linux/interrupt.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
+#include <linux/spi/spi.h>
 #include <linux/types.h>
 #include "stmpe.h"
 
diff --git a/drivers/mfd/stmpe.c b/drivers/mfd/stmpe.c
index 8a4247b..6086481 100644
--- a/drivers/mfd/stmpe.c
+++ b/drivers/mfd/stmpe.c
@@ -7,15 +7,15 @@
  * Author: Rabin Vincent <rabin.vincent@stericsson.com> for ST-Ericsson
  */
 
-#include <linux/gpio.h>
 #include <linux/export.h>
-#include <linux/kernel.h>
+#include <linux/gpio.h>
 #include <linux/interrupt.h>
 #include <linux/irq.h>
 #include <linux/irqdomain.h>
+#include <linux/kernel.h>
+#include <linux/mfd/core.h>
 #include <linux/pm.h>
 #include <linux/slab.h>
-#include <linux/mfd/core.h>
 #include "stmpe.h"
 
 static int __stmpe_enable(struct stmpe *stmpe, unsigned int blocks)
-- 
1.7.12.rc2.18.g61b472e

