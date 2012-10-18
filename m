Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756829Ab2JRQ7n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 12:59:43 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:63212 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757012Ab2JRQ7l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 12:59:41 -0400
From: Sangho Yi <antiroot@gmail.com>
To: paul.gortmaker@windriver.com, stefan.xk.nilsson@stericsson.com,
        linus.walleij@linaro.org, ulf.hansson@stericsson.com, rjw@sisk.pl,
        girish.shivananjappa@linaro.org, cjb@laptop.org
Cc: linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org,
        Sangho Yi <antiroot@gmail.com>
Subject: [PATCH 1/6] mmc: core: sdio_io.c: Fixed lines with > 80 chars
Date: Fri, 19 Oct 2012 01:58:18 +0900
Message-Id: <1350579503-3100-1-git-send-email-antiroot@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <n>
References: <n>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I fixed lines over 80 characters per line.

Signed-off-by: Sangho Yi <antiroot@gmail.com>
---
 drivers/mmc/core/sdio_io.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/mmc/core/sdio_io.c b/drivers/mmc/core/sdio_io.c
index 8f6f5ac..c5f53d8 100644
--- a/drivers/mmc/core/sdio_io.c
+++ b/drivers/mmc/core/sdio_io.c
@@ -80,7 +80,8 @@ int sdio_enable_func(struct sdio_func *func)
 	timeout = jiffies + msecs_to_jiffies(func->enable_timeout);
 
 	while (1) {
-		ret = mmc_io_rw_direct(func->card, 0, 0, SDIO_CCCR_IORx, 0, &reg);
+		ret = mmc_io_rw_direct(func->card, 0, 0, SDIO_CCCR_IORx, 0,
+				&reg);
 		if (ret)
 			goto err;
 		if (reg & (1 << func->num))
@@ -664,7 +665,8 @@ void sdio_f0_writeb(struct sdio_func *func, unsigned char b, unsigned int addr,
 
 	BUG_ON(!func);
 
-	if ((addr < 0xF0 || addr > 0xFF) && (!mmc_card_lenient_fn0(func->card))) {
+	if ((addr < 0xF0 || addr > 0xFF) &&
+	    (!mmc_card_lenient_fn0(func->card))) {
 		if (err_ret)
 			*err_ret = -EINVAL;
 		return;
-- 
1.7.9.5

