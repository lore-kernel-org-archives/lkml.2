Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758438Ab2JSN70 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 09:59:26 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:42000 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758346Ab2JSN7X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 09:59:23 -0400
From: Sangho Yi <antiroot@gmail.com>
To: prakity@nvidia.com, aaron.lu@amd.com, linus.walleij@linaro.org,
        paul.gortmaker@windriver.com, chuanxiao.dong@intel.com, cjb@laptop.org
Cc: linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org,
        Sangho Yi <antiroot@gmail.com>
Subject: [PATCH 2/2] mmc: core: bus.c: re-aligned the line over 80 chars
Date: Fri, 19 Oct 2012 22:58:58 +0900
Message-Id: <1350655138-2252-2-git-send-email-antiroot@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1350655138-2252-1-git-send-email-antiroot@gmail.com>
References: <n>
 <1350655138-2252-1-git-send-email-antiroot@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I made a correction on a line which has > 80 characters
also, aligned the consecutive line to meet the --strict rule.

Signed-off-by: Sangho Yi <antiroot@gmail.com>
---
 drivers/mmc/core/bus.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/mmc/core/bus.c b/drivers/mmc/core/bus.c
index 420cb67..66bac9f 100644
--- a/drivers/mmc/core/bus.c
+++ b/drivers/mmc/core/bus.c
@@ -269,8 +269,8 @@ int mmc_add_card(struct mmc_card *card)
 		[UHS_DDR50_BUS_SPEED] = "DDR50 ",
 	};
 
-
-	dev_set_name(&card->dev, "%s:%04x", mmc_hostname(card->host), card->rca);
+	dev_set_name(&card->dev, "%s:%04x", mmc_hostname(card->host),
+		     card->rca);
 
 	switch (card->type) {
 	case MMC_TYPE_MMC:
-- 
1.7.9.5

