Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932270Ab2LNQUK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 11:20:10 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:63721 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932212Ab2LNQUC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 11:20:02 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: linus.walleij@linaro.org, Philippe Langlais <philippe.langlais@linaro.org>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 09/21] gpio: ab8500: Fix bad include name after renaming
Date: Fri, 14 Dec 2012 16:19:27 +0000
Message-Id: <1355501979-1157-10-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1355501979-1157-1-git-send-email-lee.jones@linaro.org>
References: <1355501979-1157-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Philippe Langlais <philippe.langlais@linaro.org>

Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Philippe Langlais <philippe.langlais@linaro.org>
---
 drivers/gpio/gpio-ab8500.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpio/gpio-ab8500.c b/drivers/gpio/gpio-ab8500.c
index a0253ad..273f7ca 100644
--- a/drivers/gpio/gpio-ab8500.c
+++ b/drivers/gpio/gpio-ab8500.c
@@ -18,9 +18,9 @@
 #include <linux/gpio.h>
 #include <linux/irq.h>
 #include <linux/interrupt.h>
-#include <linux/mfd/ab8500.h>
 #include <linux/mfd/abx500.h>
-#include <linux/mfd/ab8500/gpio.h>
+#include <linux/mfd/abx500/ab8500-gpio.h>
+
 
 /*
  * GPIO registers offset
-- 
1.7.9.5

