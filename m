Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752160Ab2KSLrS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 06:47:18 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:63476 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751459Ab2KSLrR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 06:47:17 -0500
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: cbou@mail.ru, dwmw2@infradead.org, sachin.kamat@linaro.org,
        patches@linaro.org
Subject: [PATCH 1/1] ab8500_fg: Remove duplicate inclusion of linux/mfd/abx500.h
Date: Mon, 19 Nov 2012 17:11:10 +0530
Message-Id: <1353325270-415-1-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

linux/mfd/abx500.h was included twice.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/power/ab8500_fg.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/power/ab8500_fg.c b/drivers/power/ab8500_fg.c
index 2db8cc2..2f52c76 100644
--- a/drivers/power/ab8500_fg.c
+++ b/drivers/power/ab8500_fg.c
@@ -28,7 +28,6 @@
 #include <linux/mfd/abx500/ab8500-bm.h>
 #include <linux/delay.h>
 #include <linux/mfd/abx500/ab8500-gpadc.h>
-#include <linux/mfd/abx500.h>
 #include <linux/time.h>
 #include <linux/completion.h>
 
-- 
1.7.4.1

