Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757359Ab2JRQxo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 12:53:44 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:37569 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757334Ab2JRQxl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 12:53:41 -0400
From: Sangho Yi <antiroot@gmail.com>
To: girish.shivananjappa@linaro.org, cjb@laptop.org, chuansheng.liu@intel.com
Cc: linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org,
        Sangho Yi <antiroot@gmail.com>
Subject: [PATCH 2/2] mmc: core: sdio_cis.c: Fixed the position of opening braces {
Date: Fri, 19 Oct 2012 01:52:12 +0900
Message-Id: <1350579132-3003-2-git-send-email-antiroot@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1350579132-3003-1-git-send-email-antiroot@gmail.com>
References: <n>
 <1350579132-3003-1-git-send-email-antiroot@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I fixed the following coding style error:
ERROR: that open brace { should be on the previous line

Signed-off-by: Sangho Yi <antiroot@gmail.com>
---
 drivers/mmc/core/sdio_cis.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/mmc/core/sdio_cis.c b/drivers/mmc/core/sdio_cis.c
index e4221df..c81cda3 100644
--- a/drivers/mmc/core/sdio_cis.c
+++ b/drivers/mmc/core/sdio_cis.c
@@ -93,11 +93,10 @@ static int cistpl_manfid(struct mmc_card *card, struct sdio_func *func,
 	return 0;
 }
 
-static const unsigned char speed_val[16] =
-	{ 0, 10, 12, 13, 15, 20, 25, 30, 35, 40, 45, 50, 55, 60, 70, 80 };
-static const unsigned int speed_unit[8] =
-	{ 10000, 100000, 1000000, 10000000, 0, 0, 0, 0 };
-
+static const unsigned char speed_val[16] = { 0, 10, 12, 13, 15, 20, 25, 30, 35,
+	40, 45, 50, 55, 60, 70, 80 };
+static const unsigned int speed_unit[8] = { 10000, 100000, 1000000, 10000000,
+	0, 0, 0, 0 };
 
 typedef int (tpl_parse_t)(struct mmc_card *, struct sdio_func *,
 			   const unsigned char *, unsigned);
-- 
1.7.9.5

