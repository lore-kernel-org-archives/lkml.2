Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752804Ab2KAGTm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 02:19:42 -0400
Received: from va3ehsobe003.messaging.microsoft.com ([216.32.180.13]:5362 "EHLO
	va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752691Ab2KAGTk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 02:19:40 -0400
X-Forefront-Antispam-Report: CIP:59.163.77.45;KIP:(null);UIP:(null);IPV:NLI;H:KCHJEXHC01.kpit.com;RD:59.163.77.45.static.vsnl.net.in;EFVD:NLI
X-SpamScore: 1
X-BigFish: VPS1(zzzz1202h1d1ah1d2ahzz8275bhz2dh2a8h668h839h93fhd24hd2bhf0ah1288h12a5h12a9h12bdh137ah139eh13b6h1441h1504h1537hbe9i1155h)
Subject: [patch v2 2/2] regulator: support for DA9053-BC
From: Ashish Jangam <ashish.jangam@kpitcummins.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Liam Girdwood <lrg@ti.com>, Samuel Ortiz <sameo@linux.intel.com>,
        David Dajun Chen <dchen@diasemi.com>, <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 1 Nov 2012 11:49:00 +0530
Message-ID: <1351750740.19193.17.camel@dhruva>
MIME-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.10.38.47]
X-OriginatorOrg: kpitcummins.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 7b2e8c26c995d775f17491fcce7258e662009d0d Mon Sep 17 00:00:00 2001
From: Ashish Jangam <ashish.jangam@kpitcummins.com>
Date: Thu, 1 Nov 2012 11:06:17 +0530
Subject: [PATCH 2/2] [patch v 2/1] regulator: support for DA9053-BC

This patch adds DA9053-BC PMIC support to the existing DA9052/53
regulator driver

Signed-off-by: David Dajun Chen <dchen@diasemi.com>
Signed-off-by: Ashish Jangam <ashish.jangam@kpitcummins.com>
---
 drivers/regulator/da9052-regulator.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/regulator/da9052-regulator.c b/drivers/regulator/da9052-regulator.c
index 27355b1..22fb8cf 100644
--- a/drivers/regulator/da9052-regulator.c
+++ b/drivers/regulator/da9052-regulator.c
@@ -354,6 +354,7 @@ static inline struct da9052_regulator_info *find_regulator_info(u8 chip_id,
 	case DA9053_AA:
 	case DA9053_BA:
 	case DA9053_BB:
+	case DA9053_BC:
 		for (i = 0; i < ARRAY_SIZE(da9053_regulator_info); i++) {
 			info = &da9053_regulator_info[i];
 			if (info->reg_desc.id == id)
-- 
1.7.0.4


