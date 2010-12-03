Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751872Ab0LCPGo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Dec 2010 10:06:44 -0500
Received: from eu1sys200aog117.obsmtp.com ([207.126.144.143]:37994 "EHLO
	eu1sys200aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750939Ab0LCPGl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Dec 2010 10:06:41 -0500
From: Sundar Iyer <sundar.iyer@stericsson.com>
To: <linux-arm-kernel@lists.infradead.org>, <dmitry.torokhov@gmail.com>,
        <sameo@linux.intel.com>, <ben-linux@fluff.org>
Cc: <linux-input@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Sundar Iyer <sundar.iyer@stericsson.com>
Subject: [PATCH 06/20] mfd/tc35892: rename tc35892 header to tc3589x
Date: Fri, 3 Dec 2010 20:35:39 +0530
Message-ID: <1291388753-14662-7-git-send-email-sundar.iyer@stericsson.com>
X-Mailer: git-send-email 1.7.2.dirty
In-Reply-To: <1291388753-14662-1-git-send-email-sundar.iyer@stericsson.com>
References: <1291388753-14662-1-git-send-email-sundar.iyer@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rename the header file to include further variants within
the same mfd core driver

Signed-off-by: Sundar Iyer <sundar.iyer@stericsson.com>
---
 drivers/gpio/tc35892-gpio.c                |    2 +-
 drivers/mfd/tc35892.c                      |    2 +-
 include/linux/mfd/{tc35892.h => tc3589x.h} |    0
 3 files changed, 2 insertions(+), 2 deletions(-)
 rename include/linux/mfd/{tc35892.h => tc3589x.h} (100%)

diff --git a/drivers/gpio/tc35892-gpio.c b/drivers/gpio/tc35892-gpio.c
index 7e10c93..027b857 100644
--- a/drivers/gpio/tc35892-gpio.c
+++ b/drivers/gpio/tc35892-gpio.c
@@ -13,7 +13,7 @@
 #include <linux/gpio.h>
 #include <linux/irq.h>
 #include <linux/interrupt.h>
-#include <linux/mfd/tc35892.h>
+#include <linux/mfd/tc3589x.h>
 
 /*
  * These registers are modified under the irq bus lock and cached to avoid
diff --git a/drivers/mfd/tc35892.c b/drivers/mfd/tc35892.c
index e619e2a..f230235 100644
--- a/drivers/mfd/tc35892.c
+++ b/drivers/mfd/tc35892.c
@@ -12,7 +12,7 @@
 #include <linux/slab.h>
 #include <linux/i2c.h>
 #include <linux/mfd/core.h>
-#include <linux/mfd/tc35892.h>
+#include <linux/mfd/tc3589x.h>
 
 /**
  * tc35892_reg_read() - read a single TC35892 register
diff --git a/include/linux/mfd/tc35892.h b/include/linux/mfd/tc3589x.h
similarity index 100%
rename from include/linux/mfd/tc35892.h
rename to include/linux/mfd/tc3589x.h
-- 
1.7.2.dirty

