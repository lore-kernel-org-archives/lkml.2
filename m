Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756127Ab2JJM7g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 08:59:36 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:38750 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755005Ab2JJM7d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 08:59:33 -0400
MIME-Version: 1.0
Date: Wed, 10 Oct 2012 20:59:32 +0800
Message-ID: <CAPgLHd_XnZU_E3zso2F1y1GFYHewrGUSSSf8yG9LRjVkbpGL=w@mail.gmail.com>
Subject: [PATCH] pinctrl: remove duplicated include from pinctrl-xway.c
From: Wei Yongjun <weiyj.lk@gmail.com>
To: linus.walleij@linaro.org, grant.likely@secretlab.ca,
        rob.herring@calxeda.com
Cc: yongjun_wei@trendmicro.com.cn, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org
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
 drivers/pinctrl/pinctrl-xway.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-xway.c b/drivers/pinctrl/pinctrl-xway.c
index f8d917d..b9bcaec 100644
--- a/drivers/pinctrl/pinctrl-xway.c
+++ b/drivers/pinctrl/pinctrl-xway.c
@@ -17,8 +17,6 @@
 #include <linux/ioport.h>
 #include <linux/io.h>
 #include <linux/device.h>
-#include <linux/module.h>
-#include <linux/io.h>
 #include <linux/platform_device.h>
 
 #include "pinctrl-lantiq.h"

