Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752306Ab2ALG6d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 01:58:33 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:64473 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751533Ab2ALG6c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 01:58:32 -0500
Message-ID: <1326351505.3471.2.camel@phoenix>
Subject: [PATCH 2/2] regulator: s5m8767: Remove redundant MODULE_ALIAS
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Sangbeom Kim <sbkim73@samsung.com>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Thu, 12 Jan 2012 14:58:25 +0800
In-Reply-To: <1326351429.3471.0.camel@phoenix>
References: <1326351429.3471.0.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The MODULE_DEVICE_TABLE will setup the modalias, thus adding
a MODULE_ALIAS for an entry already in s5m8767_pmic_id is redundant.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/s5m8767.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/regulator/s5m8767.c b/drivers/regulator/s5m8767.c
index 4061012..caf0117 100644
--- a/drivers/regulator/s5m8767.c
+++ b/drivers/regulator/s5m8767.c
@@ -835,4 +835,3 @@ module_exit(s5m8767_pmic_exit);
 MODULE_AUTHOR("Sangbeom Kim <sbkim73@samsung.com>");
 MODULE_DESCRIPTION("SAMSUNG S5M8767 Regulator Driver");
 MODULE_LICENSE("GPL");
-MODULE_ALIAS("platform:s5m8767-pmic");
-- 
1.7.5.4



