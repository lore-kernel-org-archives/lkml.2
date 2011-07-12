Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755127Ab1GLGBn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 02:01:43 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:36030 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753985Ab1GLGBm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 02:01:42 -0400
Subject: [PATCH 2/2] mfd: aat2870-core: constify i2c_device_id table
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Jin Park <jinyoungp@nvidia.com>, Samuel Ortiz <sameo@linux.intel.com>
In-Reply-To: <1310450441.13592.1.camel@phoenix>
References: <1310450441.13592.1.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 12 Jul 2011 14:01:36 +0800
Message-ID: <1310450496.13592.2.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
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



