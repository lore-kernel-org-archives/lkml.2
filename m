Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754789Ab1CAJSq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 04:18:46 -0500
Received: from mail-yi0-f46.google.com ([209.85.218.46]:56207 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753489Ab1CAJSp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 04:18:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=SL6SfTPdrL0dD4q5/YRaWXcjes9W+JesQgwq1HH8N5XqmyHT3IkSe1rq0/U5MN7BuE
         41CsjHk5JWKcWD8l75miA4CWOnq3hjX11ZGHEGJELcJ2BMh/+naG0qXkH79O+g7zBrHC
         TsmXhOjmfNdATizlxJ8KIdfcwTeNYbeHO8KCM=
Subject: [PATCH 1/3] power: bq20z75: add MODULE_DEVICE_TABLE
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Rhyland Klein <rklein@nvidia.com>,
        Anton Vorontsov <cbouatmailru@gmail.com>
Content-Type: text/plain
Date: Tue, 01 Mar 2011 17:22:33 +0800
Message-Id: <1298971353.17825.1.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The device table is required to load modules based on modaliases.
After adding the MODULE_DEVICE_TABLE, below entry will be added to
modules.alias:
alias i2c:bq20z75 bq20z75

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/power/bq20z75.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/power/bq20z75.c b/drivers/power/bq20z75.c
index 4141775..1548de2 100644
--- a/drivers/power/bq20z75.c
+++ b/drivers/power/bq20z75.c
@@ -541,6 +541,7 @@ static const struct i2c_device_id bq20z75_id[] = {
 	{ "bq20z75", 0 },
 	{}
 };
+MODULE_DEVICE_TABLE(i2c, bq20z75_id);
 
 static struct i2c_driver bq20z75_battery_driver = {
 	.probe		= bq20z75_probe,
-- 
1.7.2



