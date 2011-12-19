Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752863Ab1LSMCa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 07:02:30 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:54549 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752654Ab1LSMC2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 07:02:28 -0500
Message-ID: <1324296142.3350.7.camel@phoenix>
Subject: [PATCH] mfd: aat2870-core: constify i2c_device_id table
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Jin Park <jinyoungp@nvidia.com>, Samuel Ortiz <sameo@linux.intel.com>
Date: Mon, 19 Dec 2011 20:02:22 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/mfd/aat2870-core.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mfd/aat2870-core.c b/drivers/mfd/aat2870-core.c
index 345dc65..a7c1a1b 100644
--- a/drivers/mfd/aat2870-core.c
+++ b/drivers/mfd/aat2870-core.c
@@ -500,7 +500,7 @@ static int aat2870_i2c_resume(struct i2c_client *client)
 #define aat2870_i2c_resume	NULL
 #endif /* CONFIG_PM */
 
-static struct i2c_device_id aat2870_i2c_id_table[] = {
+static const struct i2c_device_id aat2870_i2c_id_table[] = {
 	{ "aat2870", 0 },
 	{ }
 };
-- 
1.7.4.1



