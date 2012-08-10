Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752895Ab2HJEnu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2012 00:43:50 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:58112 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750926Ab2HJEnr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2012 00:43:47 -0400
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: thierry.reding@avionic-design.de, sachin.kamat@linaro.org,
        patches@linaro.org
Subject: [PATCH 2/2] pwm: core: Fix coding style issues
Date: Fri, 10 Aug 2012 10:12:10 +0530
Message-Id: <1344573730-21907-2-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1344573730-21907-1-git-send-email-sachin.kamat@linaro.org>
References: <1344573730-21907-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixes the following:
WARNING: line over 80 characters
ERROR: spaces required around that ':' (ctx:VxW)
WARNING: Prefer pr_warn(... to pr_warning(...

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/pwm/core.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/pwm/core.c b/drivers/pwm/core.c
index efc20f8..929be13 100644
--- a/drivers/pwm/core.c
+++ b/drivers/pwm/core.c
@@ -130,7 +130,7 @@ static int pwm_device_request(struct pwm_device *pwm, const char *label)
 }
 
 static struct pwm_device *of_pwm_simple_xlate(struct pwm_chip *pc,
-					      const struct of_phandle_args *args)
+					     const struct of_phandle_args *args)
 {
 	struct pwm_device *pwm;
 
@@ -549,7 +549,7 @@ void __init pwm_add_table(struct pwm_lookup *table, size_t num)
 struct pwm_device *pwm_get(struct device *dev, const char *con_id)
 {
 	struct pwm_device *pwm = ERR_PTR(-EPROBE_DEFER);
-	const char *dev_id = dev ? dev_name(dev): NULL;
+	const char *dev_id = dev ? dev_name(dev) : NULL;
 	struct pwm_chip *chip = NULL;
 	unsigned int index = 0;
 	unsigned int best = 0;
@@ -631,7 +631,7 @@ void pwm_put(struct pwm_device *pwm)
 	mutex_lock(&pwm_lock);
 
 	if (!test_and_clear_bit(PWMF_REQUESTED, &pwm->flags)) {
-		pr_warning("PWM device already freed\n");
+		pr_warn("PWM device already freed\n");
 		goto out;
 	}
 
-- 
1.7.4.1

