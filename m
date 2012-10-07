Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752514Ab2JGN0V (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2012 09:26:21 -0400
Received: from mail-qc0-f180.google.com ([209.85.216.180]:36258 "EHLO
	mail-qc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751550Ab2JGN0N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2012 09:26:13 -0400
MIME-Version: 1.0
Date: Sun, 7 Oct 2012 21:26:12 +0800
Message-ID: <CAPgLHd-rLYsjcSTJC-72aRnDQ=0oBMh-ESyCq+g=51VPd4bF1A@mail.gmail.com>
Subject: [PATCH] extcon: remove duplicated include from extcon-gpio.c
From: Wei Yongjun <weiyj.lk@gmail.com>
To: myungjoo.ham@samsung.com, cw00.choi@samsung.com
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
 drivers/extcon/extcon-gpio.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/extcon/extcon-gpio.c b/drivers/extcon/extcon-gpio.c
index 3cc152e..71d3ab7 100644
--- a/drivers/extcon/extcon-gpio.c
+++ b/drivers/extcon/extcon-gpio.c
@@ -26,7 +26,6 @@
 #include <linux/interrupt.h>
 #include <linux/platform_device.h>
 #include <linux/slab.h>
-#include <linux/extcon.h>
 #include <linux/workqueue.h>
 #include <linux/gpio.h>
 #include <linux/extcon.h>

