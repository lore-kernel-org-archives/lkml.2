Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755717Ab1GQVjZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jul 2011 17:39:25 -0400
Received: from mail.perches.com ([173.55.12.10]:4102 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753393Ab1GQVjJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jul 2011 17:39:09 -0400
From: Joe Perches <joe@perches.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>, linux-kernel@vger.kernel.org
Cc: devel@linuxdriverproject.org, gregkh@suse.de, error27@gmail.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 2/2] ath6kl: Remove trailing unpaired close paren from ath6kl_err uses
Date: Sun, 17 Jul 2011 14:38:57 -0700
Message-Id: <6a83ad0030e3b0495468d8fcc44bb6cd913baa9f.1310938421.git.joe@perches.com>
X-Mailer: git-send-email 1.7.6.131.g99019
In-Reply-To: <4E2349D4.4000204@qca.qualcomm.com>
References: <4E2349D4.4000204@qca.qualcomm.com>
In-Reply-To: <cover.1310938421.git.joe@perches.com>
References: <cover.1310938421.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Unpaired parentheses are unsightly.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/net/wireless/ath/ath6kl/sdio.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/sdio.c b/drivers/net/wireless/ath/ath6kl/sdio.c
index c58a107..e399b17 100644
--- a/drivers/net/wireless/ath/ath6kl/sdio.c
+++ b/drivers/net/wireless/ath/ath6kl/sdio.c
@@ -511,7 +511,7 @@ static int ath6kl_sdio_power_on(struct ath6kl_sdio *ar_sdio)
 
 	ret = sdio_enable_func(func);
 	if (ret) {
-		ath6kl_err("Unable to enable sdio func: %d)\n", ret);
+		ath6kl_err("Unable to enable sdio func: %d\n", ret);
 		sdio_release_host(func);
 		return ret;
 	}
@@ -760,7 +760,7 @@ static int ath6kl_sdio_probe(struct sdio_func *func,
 
 	ret = sdio_set_block_size(func, HIF_MBOX_BLOCK_SIZE);
 	if (ret) {
-		ath6kl_err("Set sdio block size %d failed: %d)\n",
+		ath6kl_err("Set sdio block size %d failed: %d\n",
 			   HIF_MBOX_BLOCK_SIZE, ret);
 		sdio_release_host(func);
 		goto err_off;
-- 
1.7.6.131.g99019

