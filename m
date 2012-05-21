Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754950Ab2EUPdb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 11:33:31 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:35389 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754272Ab2EUPd2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 11:33:28 -0400
Message-ID: <1337614402.15342.1.camel@phoenix>
Subject: [PATCH] mfd: Add terminating entry for i2c_device_id table
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Graeme Gregory <gg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Samuel Ortiz <sameo@linux.intel.com>
Date: Mon, 21 May 2012 23:33:22 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The i2c_device_id table is supposed to be zero-terminated.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/mfd/palmas.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/mfd/palmas.c b/drivers/mfd/palmas.c
index 00c0aba..5d896b3 100644
--- a/drivers/mfd/palmas.c
+++ b/drivers/mfd/palmas.c
@@ -472,6 +472,7 @@ static const struct i2c_device_id palmas_i2c_id[] = {
 	{ "twl6035", },
 	{ "twl6037", },
 	{ "tps65913", },
+	{ /* end */ }
 };
 MODULE_DEVICE_TABLE(i2c, palmas_i2c_id);
 
-- 
1.7.5.4



