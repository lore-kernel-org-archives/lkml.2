Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757024Ab2JRQIJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 12:08:09 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:49616 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753681Ab2JRQIF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 12:08:05 -0400
From: Sangho Yi <antiroot@gmail.com>
To: prakity@marvell.com, aaron.lu@amd.com, linus.walleij@linaro.org,
        ulf.hansson@stericsson.com, cjb@laptop.org
Cc: linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org,
        Sangho Yi <antiroot@gmail.com>
Subject: [PATCH 1/3] drivers: mmc: core: sdio.c: fixed lines with > 80 chars
Date: Fri, 19 Oct 2012 01:06:32 +0900
Message-Id: <1350576394-2008-1-git-send-email-antiroot@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <n>
References: <n>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed coding style warning cases for exceeding 80 chars per line on
sdio.c.

Signed-off-by: Sangho Yi <antiroot@gmail.com>
---
 drivers/mmc/core/sdio.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/mmc/core/sdio.c b/drivers/mmc/core/sdio.c
index 2273ce6..14326e8 100644
--- a/drivers/mmc/core/sdio.c
+++ b/drivers/mmc/core/sdio.c
@@ -47,7 +47,8 @@ static int sdio_read_fbr(struct sdio_func *func)
 
 	if (data == 0x0f) {
 		ret = mmc_io_rw_direct(func->card, 0, 0,
-			SDIO_FBR_BASE(func->num) + SDIO_FBR_STD_IF_EXT, 0, &data);
+			SDIO_FBR_BASE(func->num) + SDIO_FBR_STD_IF_EXT,
+			0, &data);
 		if (ret)
 			goto out;
 	}
@@ -619,7 +620,8 @@ static int mmc_sdio_init_card(struct mmc_host *host, u32 ocr,
 		card->type = MMC_TYPE_SD_COMBO;
 
 		if (oldcard && (oldcard->type != MMC_TYPE_SD_COMBO ||
-		    memcmp(card->raw_cid, oldcard->raw_cid, sizeof(card->raw_cid)) != 0)) {
+			memcmp(card->raw_cid, oldcard->raw_cid,
+				sizeof(card->raw_cid)) != 0)) {
 			mmc_remove_card(card);
 			return -ENOENT;
 		}
-- 
1.7.9.5

