Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932687Ab0KODFg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Nov 2010 22:05:36 -0500
Received: from mail.perches.com ([173.55.12.10]:1153 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932652Ab0KODFe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Nov 2010 22:05:34 -0500
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: Chris Ball <cjb@laptop.org>, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 11/44] drivers/mmc: Remove unnecessary semicolons
Date: Sun, 14 Nov 2010 19:04:30 -0800
Message-Id: <6391af02ba7ec4a76c5c5f462d8013fc1f52f999.1289789604.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.1.g432b3.dirty
In-Reply-To: <cover.1289789604.git.joe@perches.com>
References: <cover.1289789604.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/mmc/host/davinci_mmc.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mmc/host/davinci_mmc.c b/drivers/mmc/host/davinci_mmc.c
index e15547c..b643dde 100644
--- a/drivers/mmc/host/davinci_mmc.c
+++ b/drivers/mmc/host/davinci_mmc.c
@@ -480,7 +480,7 @@ static void mmc_davinci_send_dma_request(struct mmc_davinci_host *host,
 	struct scatterlist	*sg;
 	unsigned		sg_len;
 	unsigned		bytes_left = host->bytes_left;
-	const unsigned		shift = ffs(rw_threshold) - 1;;
+	const unsigned		shift = ffs(rw_threshold) - 1;
 
 	if (host->data_dir == DAVINCI_MMC_DATADIR_WRITE) {
 		template = &host->tx_template;
-- 
1.7.3.1.g432b3.dirty

