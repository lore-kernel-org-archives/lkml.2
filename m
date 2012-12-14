Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756726Ab2LNQUj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 11:20:39 -0500
Received: from mail-wg0-f46.google.com ([74.125.82.46]:37652 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756676Ab2LNQUU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 11:20:20 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: linus.walleij@linaro.org, Linus Walleij <linus.walleij@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 21/21] gpio: ab8500: Add explicit dependencies
Date: Fri, 14 Dec 2012 16:19:39 +0000
Message-Id: <1355501979-1157-22-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1355501979-1157-1-git-send-email-lee.jones@linaro.org>
References: <1355501979-1157-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Walleij <linus.walleij@stericsson.com>

This driver is using symbols from <linux/mfd/abx500/ab8500.h> so
include this file explicitly.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
Reviewed-by: Philippe LANGLAIS <philippe.langlais@stericsson.com>
---
 drivers/gpio/gpio-ab8500.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpio/gpio-ab8500.c b/drivers/gpio/gpio-ab8500.c
index ed5832e..d201de9 100644
--- a/drivers/gpio/gpio-ab8500.c
+++ b/drivers/gpio/gpio-ab8500.c
@@ -19,6 +19,7 @@
 #include <linux/irq.h>
 #include <linux/interrupt.h>
 #include <linux/mfd/abx500.h>
+#include <linux/mfd/abx500/ab8500.h>
 #include <linux/mfd/abx500/ab8500-gpio.h>
 
 
-- 
1.7.9.5

