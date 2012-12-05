Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754127Ab2LEM7M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 07:59:12 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:62325 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752801Ab2LEM7L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 07:59:11 -0500
Message-ID: <1354712340.4261.0.camel@phoenix>
Subject: [PATCH] mfd: tps80031: Add terminating entry for tps80031_id_table
From: Axel Lin <axel.lin@ingics.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Laxman Dewangan <ldewangan@nvidia.com>, linux-kernel@vger.kernel.org
Date: Wed, 05 Dec 2012 20:59:00 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The i2c_device_id table is supposed to be zero-terminated.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/mfd/tps80031.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/mfd/tps80031.c b/drivers/mfd/tps80031.c
index f64005e..10b51f7 100644
--- a/drivers/mfd/tps80031.c
+++ b/drivers/mfd/tps80031.c
@@ -543,6 +543,7 @@ static int __devexit tps80031_remove(struct i2c_client *client)
 static const struct i2c_device_id tps80031_id_table[] = {
 	{ "tps80031", TPS80031 },
 	{ "tps80032", TPS80032 },
+	{ }
 };
 MODULE_DEVICE_TABLE(i2c, tps80031_id_table);
 
-- 
1.7.9.5



