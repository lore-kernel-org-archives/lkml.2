Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933526Ab2JZOsF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 10:48:05 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:44640 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932078Ab2JZOsD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 10:48:03 -0400
MIME-Version: 1.0
Date: Fri, 26 Oct 2012 22:48:02 +0800
Message-ID: <CAPgLHd9=dL_pNFc4-a7ifuoi9rCgJT=gtCiowF9hRmragvq6fg@mail.gmail.com>
Subject: [PATCH -next] ARM: at91: remove duplicated include from pinctrl-at91.c
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
 drivers/pinctrl/pinctrl-at91.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/pinctrl/pinctrl-at91.c b/drivers/pinctrl/pinctrl-at91.c
index 01bf924..7bfad34 100644
--- a/drivers/pinctrl/pinctrl-at91.c
+++ b/drivers/pinctrl/pinctrl-at91.c
@@ -20,7 +20,6 @@
 #include <linux/irqdomain.h>
 #include <linux/io.h>
 #include <linux/gpio.h>
-#include <linux/irqdomain.h>
 #include <linux/pinctrl/machine.h>
 #include <linux/pinctrl/pinconf.h>
 #include <linux/pinctrl/pinctrl.h>


