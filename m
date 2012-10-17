Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757242Ab2JQOPZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 10:15:25 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:59306 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757124Ab2JQOPV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 10:15:21 -0400
From: Sangho Yi <antiroot@gmail.com>
To: prakity@marvell.com, aaron.lu@amd.com, linus.walleij@linaro.org,
        ulf.hansson@stericsson.com, cjb@laptop.org
Cc: linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org,
        Sangho Yi <antiroot@gmail.com>
Subject: [PATCH 3/3] drivers: mmc: core: sdio.c: fixed from pr_warning(... to pr_warn(...
Date: Wed, 17 Oct 2012 23:13:18 +0900
Message-Id: <1350483199-3048-3-git-send-email-antiroot@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1350483199-3048-1-git-send-email-antiroot@gmail.com>
References: <n>
 <1350483199-3048-1-git-send-email-antiroot@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replaced pr_warning(... to pr_warn(... on sdio.c

Signed-off-by: Sangho Yi <antiroot@gmail.com>
---
 drivers/mmc/core/sdio.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/mmc/core/sdio.c b/drivers/mmc/core/sdio.c
index df09b63..889d3da 100644
--- a/drivers/mmc/core/sdio.c
+++ b/drivers/mmc/core/sdio.c
@@ -220,7 +220,7 @@ static int sdio_enable_wide(struct mmc_card *card)
 		return ret;
 
 	if ((ctrl & SDIO_BUS_WIDTH_MASK) == SDIO_BUS_WIDTH_RESERVED)
-		pr_warning("%s: SDIO_CCCR_IF is invalid: 0x%02x\n",
+		pr_warn("%s: SDIO_CCCR_IF is invalid: 0x%02x\n",
 			   mmc_hostname(card->host), ctrl);
 
 	/* set as 4-bit bus width */
@@ -1068,7 +1068,7 @@ int mmc_attach_sdio(struct mmc_host *host)
 	 * support.
 	 */
 	if (ocr & 0x7F) {
-		pr_warning("%s: card claims to support voltages "
+		pr_warn("%s: card claims to support voltages "
 		       "below the defined range. These will be ignored.\n",
 		       mmc_hostname(host));
 		ocr &= ~0x7F;
-- 
1.7.9.5

