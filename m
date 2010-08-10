Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932191Ab0HJPCU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 11:02:20 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:40257 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932070Ab0HJPCQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 11:02:16 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Liam Girdwood <lrg@slimlogic.co.uk>
Cc: Mike Rapoport <mike@compulab.co.il>, linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] regulator: Remove default DEBUG define from TPS6586x
Date: Tue, 10 Aug 2010 16:02:13 +0100
Message-Id: <1281452533-9341-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/regulator/tps6586x-regulator.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/regulator/tps6586x-regulator.c b/drivers/regulator/tps6586x-regulator.c
index 3c2eee8..fd14c59 100644
--- a/drivers/regulator/tps6586x-regulator.c
+++ b/drivers/regulator/tps6586x-regulator.c
@@ -13,7 +13,6 @@
  * published by the Free Software Foundation.
  */
 
-#define DEBUG
 #include <linux/kernel.h>
 #include <linux/init.h>
 #include <linux/err.h>
-- 
1.7.1

