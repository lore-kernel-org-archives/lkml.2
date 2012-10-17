Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757225Ab2JQOPU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 10:15:20 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:60871 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757124Ab2JQOPR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 10:15:17 -0400
From: Sangho Yi <antiroot@gmail.com>
To: prakity@marvell.com, aaron.lu@amd.com, linus.walleij@linaro.org,
        ulf.hansson@stericsson.com, cjb@laptop.org
Cc: linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org,
        Sangho Yi <antiroot@gmail.com>
Subject: [PATCH 2/3] drivers: mmc: core: sdio.c: fixed coding style error on for() statement
Date: Wed, 17 Oct 2012 23:13:17 +0900
Message-Id: <1350483199-3048-2-git-send-email-antiroot@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1350483199-3048-1-git-send-email-antiroot@gmail.com>
References: <n>
 <1350483199-3048-1-git-send-email-antiroot@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

add a whitespace after ";" on for statement, to follow a coding style guideline.

Signed-off-by: Sangho Yi <antiroot@gmail.com>
---
 drivers/mmc/core/sdio.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/mmc/core/sdio.c b/drivers/mmc/core/sdio.c
index 14326e8..df09b63 100644
--- a/drivers/mmc/core/sdio.c
+++ b/drivers/mmc/core/sdio.c
@@ -819,7 +819,7 @@ static void mmc_sdio_remove(struct mmc_host *host)
 	BUG_ON(!host);
 	BUG_ON(!host->card);
 
-	for (i = 0;i < host->card->sdio_funcs;i++) {
+	for (i = 0; i < host->card->sdio_funcs; i++) {
 		if (host->card->sdio_func[i]) {
 			sdio_remove_func(host->card->sdio_func[i]);
 			host->card->sdio_func[i] = NULL;
@@ -1151,7 +1151,7 @@ int mmc_attach_sdio(struct mmc_host *host)
 	/*
 	 * ...then the SDIO functions.
 	 */
-	for (i = 0;i < funcs;i++) {
+	for (i = 0; i < funcs; i++) {
 		err = sdio_add_func(host->card->sdio_func[i]);
 		if (err)
 			goto remove_added;
-- 
1.7.9.5

