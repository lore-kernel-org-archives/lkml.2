Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755735Ab2DCXEN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2012 19:04:13 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:53226 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753684Ab2DCXEM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2012 19:04:12 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Liam Girdwood <lrg@ti.com>
Cc: linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] regulator: max8860: Remove announcement on probe
Date: Wed,  4 Apr 2012 00:04:08 +0100
Message-Id: <1333494249-22592-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The core already announces constraints and we're not adding any new
information such as the chip revision.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/regulator/max8660.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/regulator/max8660.c b/drivers/regulator/max8660.c
index 4c5b053..e42db53 100644
--- a/drivers/regulator/max8660.c
+++ b/drivers/regulator/max8660.c
@@ -461,7 +461,6 @@ static int __devinit max8660_probe(struct i2c_client *client,
 	}
 
 	i2c_set_clientdata(client, max8660);
-	dev_info(&client->dev, "Maxim 8660/8661 regulator driver loaded\n");
 	return 0;
 
 err_unregister:
-- 
1.7.9.1

