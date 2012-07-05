Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932292Ab2GELnJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 07:43:09 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:55476 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932083Ab2GELnH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 07:43:07 -0400
From: Sachin Kamat <sachin.kamat@linaro.org>
To: rtc-linux@googlegroups.com
Cc: linux-kernel@vger.kernel.org, a.zummo@towertech.it,
        akpm@linux-foundation.org, sachin.kamat@linaro.org, patches@linaro.org
Subject: [PATCH 1/1] rtc: rtc-s3c: Replace #include header files from asm/* to linux/*
Date: Thu,  5 Jul 2012 17:00:44 +0530
Message-Id: <1341487844-26689-1-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixes the following checkpatch warnings:
WARNING: Use #include <linux/uaccess.h> instead of <asm/uaccess.h>
WARNING: Use #include <linux/io.h> instead of <asm/io.h>

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/rtc/rtc-s3c.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/rtc/rtc-s3c.c b/drivers/rtc/rtc-s3c.c
index 7e6af0b..bfbd92c 100644
--- a/drivers/rtc/rtc-s3c.c
+++ b/drivers/rtc/rtc-s3c.c
@@ -26,10 +26,10 @@
 #include <linux/log2.h>
 #include <linux/slab.h>
 #include <linux/of.h>
+#include <linux/uaccess.h>
+#include <linux/io.h>
 
 #include <mach/hardware.h>
-#include <asm/uaccess.h>
-#include <asm/io.h>
 #include <asm/irq.h>
 #include <plat/regs-rtc.h>
 
-- 
1.7.4.1

