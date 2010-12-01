Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757075Ab0LAUi1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 15:38:27 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:19557 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756924Ab0LAUiW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 15:38:22 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Wed, 01 Dec 2010 12:32:52 -0800
From: Stephen Warren <swarren@nvidia.com>
To: <linux-kernel@vger.kernel.org>
CC: <lrg@slimlogic.co.uk>, <broonie@opensource.wolfsonmicro.com>,
        <dahuang@nvidia.com>, <olofj@chromium.org>,
        Stephen Warren <swarren@nvidia.com>
Subject: [PATCH 4/4] regulator: tps6586x: correct register table
Date: Wed, 1 Dec 2010 13:37:31 -0700
Message-ID: <1291235851-29523-5-git-send-email-swarren@nvidia.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1291235851-29523-1-git-send-email-swarren@nvidia.com>
References: <1291235851-29523-1-git-send-email-swarren@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Danny Huang <dahuang@nvidia.com>

Correct the register table for SM2, LDO8, RTC

Change-Id: I45348cec5ffbb7da9bd7523764fb611b537236b8
Signed-off-by: Danny Huang <dahuang@nvidia.com>
Signed-off-by: Olof Johansson <olofj@chromium.org>
Signed-off-by: Stephen Warren <swarren@nvidia.com>
---
 drivers/regulator/tps6586x-regulator.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/regulator/tps6586x-regulator.c b/drivers/regulator/tps6586x-regulator.c
index c668944..6d20b04 100644
--- a/drivers/regulator/tps6586x-regulator.c
+++ b/drivers/regulator/tps6586x-regulator.c
@@ -274,11 +274,11 @@ static struct tps6586x_regulator tps6586x_regulator[] = {
 	TPS6586X_LDO(LDO_5, ldo, SUPPLYV6, 0, 3, ENE, 6, ENE, 6),
 	TPS6586X_LDO(LDO_6, ldo, SUPPLYV3, 0, 3, ENC, 4, END, 4),
 	TPS6586X_LDO(LDO_7, ldo, SUPPLYV3, 3, 3, ENC, 5, END, 5),
-	TPS6586X_LDO(LDO_8, ldo, SUPPLYV1, 5, 3, ENC, 6, END, 6),
+	TPS6586X_LDO(LDO_8, ldo, SUPPLYV2, 5, 3, ENC, 6, END, 6),
 	TPS6586X_LDO(LDO_9, ldo, SUPPLYV6, 3, 3, ENE, 7, ENE, 7),
-	TPS6586X_LDO(LDO_RTC, ldo, SUPPLYV4, 3, 3, ENE, 7, ENE, 7),
+	TPS6586X_LDO(LDO_RTC, ldo, SUPPLYV4, 3, 3, V4, 7, V4, 7),
 	TPS6586X_LDO(LDO_1, dvm, SUPPLYV1, 0, 5, ENC, 1, END, 1),
-	TPS6586X_LDO(SM_2, sm2, SUPPLYV2, 0, 5, ENC, 1, END, 1),
+	TPS6586X_LDO(SM_2, sm2, SUPPLYV2, 0, 5, ENC, 7, END, 7),
 
 	TPS6586X_DVM(LDO_2, dvm, LDO2BV1, 0, 5, ENA, 3, ENB, 3, VCC2, 6),
 	TPS6586X_DVM(LDO_4, ldo4, LDO4V1, 0, 5, ENC, 3, END, 3, VCC1, 6),
-- 
1.7.0.4
nvpublic

