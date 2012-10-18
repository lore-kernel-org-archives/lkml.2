Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932420Ab2JRQ7u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 12:59:50 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:46712 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932363Ab2JRQ7q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 12:59:46 -0400
From: Sangho Yi <antiroot@gmail.com>
To: paul.gortmaker@windriver.com, stefan.xk.nilsson@stericsson.com,
        linus.walleij@linaro.org, ulf.hansson@stericsson.com, rjw@sisk.pl,
        girish.shivananjappa@linaro.org, cjb@laptop.org
Cc: linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org,
        Sangho Yi <antiroot@gmail.com>
Subject: [PATCH 2/6] mmc: core: sdio_bus.c: Removed trailing whitespace error
Date: Fri, 19 Oct 2012 01:58:19 +0900
Message-Id: <1350579503-3100-2-git-send-email-antiroot@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1350579503-3100-1-git-send-email-antiroot@gmail.com>
References: <n>
 <1350579503-3100-1-git-send-email-antiroot@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removed the one unnecessary whitespace error from sdio_bus.c

Signed-off-by: Sangho Yi <antiroot@gmail.com>
---
 drivers/mmc/core/sdio_bus.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mmc/core/sdio_bus.c b/drivers/mmc/core/sdio_bus.c
index 6bf6879..13146d2 100644
--- a/drivers/mmc/core/sdio_bus.c
+++ b/drivers/mmc/core/sdio_bus.c
@@ -105,7 +105,7 @@ sdio_bus_uevent(struct device *dev, struct kobj_uevent_env *env)
 			"SDIO_CLASS=%02X", func->class))
 		return -ENOMEM;
 
-	if (add_uevent_var(env, 
+	if (add_uevent_var(env,
 			   "SDIO_ID=%04X:%04X", func->vendor, func->device))
 		return -ENOMEM;
 
-- 
1.7.9.5

