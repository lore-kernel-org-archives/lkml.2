Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933503Ab2GFLPe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 07:15:34 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:48477 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933021Ab2GFLPc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 07:15:32 -0400
Message-ID: <1341573327.6611.2.camel@phoenix>
Subject: [PATCH 2/2] regulator: aat2870: Remove unused min_uV and max_uV
 from struct aat2870_regulator
From: Axel Lin <axel.lin@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Jin Park <jinyoungp@nvidia.com>, Liam Girdwood <lrg@ti.com>,
        linux-kernel@vger.kernel.org
Date: Fri, 06 Jul 2012 19:15:27 +0800
In-Reply-To: <1341573272.6611.1.camel@phoenix>
References: <1341573272.6611.1.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Both min_uV and max_uV are not used in the code, remove them.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/aat2870-regulator.c |    5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/regulator/aat2870-regulator.c b/drivers/regulator/aat2870-regulator.c
index 6644e83..6f45bfd 100644
--- a/drivers/regulator/aat2870-regulator.c
+++ b/drivers/regulator/aat2870-regulator.c
@@ -33,9 +33,6 @@ struct aat2870_regulator {
 	struct aat2870_data *aat2870;
 	struct regulator_desc desc;
 
-	int min_uV;
-	int max_uV;
-
 	u8 enable_addr;
 	u8 enable_shift;
 	u8 enable_mask;
@@ -127,8 +124,6 @@ static const unsigned int aat2870_ldo_voltages[] = {
 			.type = REGULATOR_VOLTAGE,	\
 			.owner = THIS_MODULE,		\
 		},					\
-		.min_uV = 1200000,			\
-		.max_uV = 3300000,			\
 	}
 
 static struct aat2870_regulator aat2870_regulators[] = {
-- 
1.7.9.5



