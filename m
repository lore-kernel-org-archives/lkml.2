Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752578Ab2HJEnp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2012 00:43:45 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:58112 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750877Ab2HJEno (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2012 00:43:44 -0400
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: thierry.reding@avionic-design.de, sachin.kamat@linaro.org,
        patches@linaro.org
Subject: [PATCH 1/2] pwm: vt8500: Fix coding style issue
Date: Fri, 10 Aug 2012 10:12:09 +0530
Message-Id: <1344573730-21907-1-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixes the following:
WARNING: Prefer pr_warn(... to pr_warning(...
	pr_warning("Waiting for status bits 0x%x to clear timed out\n",

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/pwm/pwm-vt8500.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/pwm/pwm-vt8500.c b/drivers/pwm/pwm-vt8500.c
index 5480214..ad14389 100644
--- a/drivers/pwm/pwm-vt8500.c
+++ b/drivers/pwm/pwm-vt8500.c
@@ -41,7 +41,7 @@ static inline void pwm_busy_wait(void __iomem *reg, u8 bitmask)
 		cpu_relax();
 
 	if (unlikely(!loops))
-		pr_warning("Waiting for status bits 0x%x to clear timed out\n",
+		pr_warn("Waiting for status bits 0x%x to clear timed out\n",
 			   bitmask);
 }
 
-- 
1.7.4.1

