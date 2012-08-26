Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756628Ab2HZBvy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Aug 2012 21:51:54 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:54806 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756323Ab2HZBvw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Aug 2012 21:51:52 -0400
MIME-Version: 1.0
Date: Sun, 26 Aug 2012 09:51:51 +0800
Message-ID: <CAPgLHd-YphahRz97nAqJes_z0wNQyaf3QocUiRDK5rZtOWVr9w@mail.gmail.com>
Subject: [PATCH] mfd: remove duplicated include from twl6040-core.c
From: Wei Yongjun <weiyj.lk@gmail.com>
To: sameo@linux.intel.com
Cc: yongjun_wei@trendmicro.com.cn, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Remove duplicated include.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/mfd/twl6040-core.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/mfd/twl6040-core.c b/drivers/mfd/twl6040-core.c
index b0fad0f..fbb82ba 100644
--- a/drivers/mfd/twl6040-core.c
+++ b/drivers/mfd/twl6040-core.c
@@ -37,7 +37,6 @@
 #include <linux/delay.h>
 #include <linux/i2c.h>
 #include <linux/regmap.h>
-#include <linux/err.h>
 #include <linux/mfd/core.h>
 #include <linux/mfd/twl6040.h>
 #include <linux/regulator/consumer.h>

