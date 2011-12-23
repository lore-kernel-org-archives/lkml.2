Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756129Ab1LWChQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 21:37:16 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:57262 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753765Ab1LWChO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 21:37:14 -0500
From: Olof Johansson <olof@lixom.net>
To: Anton Vorontsov <cbouatmailru@gmail.com>
Cc: Rhyland Klein <rklein@nvidia.com>, linux-kernel@vger.kernel.org,
        Olof Johansson <olof@lixom.net>
Subject: [PATCH] bq20z75: fix devicetree match table
Date: Thu, 22 Dec 2011 18:37:04 -0800
Message-Id: <1324607824-2685-1-git-send-email-olof@lixom.net>
X-Mailer: git-send-email 1.7.8.GIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It should be an of module table, not i2c.

Signed-off-by: Olof Johansson <olof@lixom.net>
---
 drivers/power/bq20z75.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/power/bq20z75.c b/drivers/power/bq20z75.c
index ce95ff7..3efca54 100644
--- a/drivers/power/bq20z75.c
+++ b/drivers/power/bq20z75.c
@@ -622,7 +622,7 @@ static const struct of_device_id bq20z75_dt_ids[] = {
 	{ .compatible = "ti,bq20z75" },
 	{ }
 };
-MODULE_DEVICE_TABLE(i2c, bq20z75_dt_ids);
+MODULE_DEVICE_TABLE(of, bq20z75_dt_ids);
 
 static struct bq20z75_platform_data *bq20z75_of_populate_pdata(
 		struct i2c_client *client)
-- 
1.7.8.GIT

