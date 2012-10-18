Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932461Ab2JRQ76 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 12:59:58 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:63212 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932202Ab2JRQ7x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 12:59:53 -0400
From: Sangho Yi <antiroot@gmail.com>
To: paul.gortmaker@windriver.com, stefan.xk.nilsson@stericsson.com,
        linus.walleij@linaro.org, ulf.hansson@stericsson.com, rjw@sisk.pl,
        girish.shivananjappa@linaro.org, cjb@laptop.org
Cc: linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org,
        Sangho Yi <antiroot@gmail.com>
Subject: [PATCH 4/6] mmc: core: sdio_bus.c: Removed space between func name and ()
Date: Fri, 19 Oct 2012 01:58:21 +0900
Message-Id: <1350579503-3100-4-git-send-email-antiroot@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1350579503-3100-1-git-send-email-antiroot@gmail.com>
References: <n>
 <1350579503-3100-1-git-send-email-antiroot@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed a coding style warning like this:
from foo (arg) --> to foo(arg)

Signed-off-by: Sangho Yi <antiroot@gmail.com>
---
 drivers/mmc/core/sdio_bus.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/mmc/core/sdio_bus.c b/drivers/mmc/core/sdio_bus.c
index efa30eb..1a1d96c 100644
--- a/drivers/mmc/core/sdio_bus.c
+++ b/drivers/mmc/core/sdio_bus.c
@@ -31,8 +31,8 @@ field##_show(struct device *dev, struct device_attribute *attr, char *buf)\
 {									\
 	struct sdio_func *func;						\
 									\
-	func = dev_to_sdio_func (dev);					\
-	return sprintf (buf, format_string, func->field);		\
+	func = dev_to_sdio_func(dev);					\
+	return sprintf(buf, format_string, func->field);		\
 }
 
 sdio_config_attr(class, "0x%02x\n");
@@ -42,7 +42,7 @@ sdio_config_attr(device, "0x%04x\n");
 static ssize_t modalias_show(struct device *dev, struct device_attribute *attr,
 		char *buf)
 {
-	struct sdio_func *func = dev_to_sdio_func (dev);
+	struct sdio_func *func = dev_to_sdio_func(dev);
 
 	return sprintf(buf, "sdio:c%02Xv%04Xd%04X\n",
 			func->class, func->vendor, func->device);
-- 
1.7.9.5

