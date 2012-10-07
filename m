Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752825Ab2JGN23 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2012 09:28:29 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:57797 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750794Ab2JGN2V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2012 09:28:21 -0400
MIME-Version: 1.0
Date: Sun, 7 Oct 2012 21:28:20 +0800
Message-ID: <CAPgLHd-C5NvpG7vo68kAjY4+CxDXenYU-Po-K4Z+uuvz_vZpxg@mail.gmail.com>
Subject: [PATCH] pinctrl: remove duplicated include from pinctrl-bcm2835.c
From: Wei Yongjun <weiyj.lk@gmail.com>
To: swarren@wwwdotorg.org, linus.walleij@linaro.org, grant.likely@secretlab.ca,
        rob.herring@calxeda.com
Cc: yongjun_wei@trendmicro.com.cn, linux-rpi-kernel@lists.infradead.org,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org
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
 drivers/pinctrl/pinctrl-bcm2835.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/pinctrl/pinctrl-bcm2835.c b/drivers/pinctrl/pinctrl-bcm2835.c
index a4adee6..f2534ed 100644
--- a/drivers/pinctrl/pinctrl-bcm2835.c
+++ b/drivers/pinctrl/pinctrl-bcm2835.c
@@ -29,7 +29,6 @@
 #include <linux/irq.h>
 #include <linux/irqdesc.h>
 #include <linux/irqdomain.h>
-#include <linux/irq.h>
 #include <linux/module.h>
 #include <linux/of_address.h>
 #include <linux/of.h>

