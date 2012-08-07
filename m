Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753472Ab2HGJSA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 05:18:00 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:37305 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752843Ab2HGJR7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 05:17:59 -0400
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: myungjoo.ham@samsung.com, cw00.choi@samsung.com, sachin.kamat@linaro.org,
        patches@linaro.org
Subject: [PATCH] extcon: Remove duplicate inclusion of extcon.h header file
Date: Tue,  7 Aug 2012 14:46:32 +0530
Message-Id: <1344330992-20849-1-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

extcon.h header file was included twice.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
Signed-off-by: Sachin Kamat <sachin.kamat@samsung.com>
---
 drivers/extcon/extcon_gpio.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/extcon/extcon_gpio.c b/drivers/extcon/extcon_gpio.c
index fe3db45..25b6c11 100644
--- a/drivers/extcon/extcon_gpio.c
+++ b/drivers/extcon/extcon_gpio.c
@@ -26,7 +26,6 @@
 #include <linux/interrupt.h>
 #include <linux/platform_device.h>
 #include <linux/slab.h>
-#include <linux/extcon.h>
 #include <linux/workqueue.h>
 #include <linux/gpio.h>
 #include <linux/extcon.h>
-- 
1.7.4.1

