Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751134Ab2KUFbm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 00:31:42 -0500
Received: from mail-qa0-f53.google.com ([209.85.216.53]:38923 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750820Ab2KUFbl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 00:31:41 -0500
MIME-Version: 1.0
Date: Wed, 21 Nov 2012 13:31:40 +0800
Message-ID: <CAPgLHd8Vba4HSf4czzKKkaWUzch1gBpLi2C_=9gBmZNCFVwO3Q@mail.gmail.com>
Subject: [PATCH -next] mfd: twl6040: remove duplicated include from twl6040.c
From: Wei Yongjun <weiyj.lk@gmail.com>
To: sameo@linux.intel.com, peter.ujfalusi@ti.com
Cc: yongjun_wei@trendmicro.com.cn, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Remove duplicated include.

dpatch engine is used to auto generate this patch.
(https://github.com/weiyj/dpatch)

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/mfd/twl6040.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/mfd/twl6040.c b/drivers/mfd/twl6040.c
index e5f7b79..583be76 100644
--- a/drivers/mfd/twl6040.c
+++ b/drivers/mfd/twl6040.c
@@ -37,7 +37,6 @@
 #include <linux/delay.h>
 #include <linux/i2c.h>
 #include <linux/regmap.h>
-#include <linux/err.h>
 #include <linux/mfd/core.h>
 #include <linux/mfd/twl6040.h>
 #include <linux/regulator/consumer.h>


