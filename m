Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757904Ab2ARPR2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 10:17:28 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:1393 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757719Ab2ARPR0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 10:17:26 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Wed, 18 Jan 2012 07:17:26 -0800
From: Laxman Dewangan <ldewangan@nvidia.com>
To: lrg@ti.com, broonie@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org
Cc: linux-tegra@vger.kernel.org, ldewangan@nvidia.com
Subject: [PATCH V1 2/2] regulator: tps65910: Initialize n_voltages for rails.
Date: Wed, 18 Jan 2012 20:47:16 +0530
Message-Id: <1326899836-14470-1-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Initializing the number of voltages supported by different
rails of pmic device tps65911.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
 drivers/regulator/tps65910-regulator.c |   11 +++++++++++
 1 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/drivers/regulator/tps65910-regulator.c b/drivers/regulator/tps65910-regulator.c
index 6742418..3ac5f91 100644
--- a/drivers/regulator/tps65910-regulator.c
+++ b/drivers/regulator/tps65910-regulator.c
@@ -188,56 +188,67 @@ static struct tps_info tps65911_regs[] = {
 		.name = "VDD1",
 		.min_uV = 600000,
 		.max_uV = 4500000,
+		.table_len = 73,
 	},
 	{
 		.name = "VDD2",
 		.min_uV = 600000,
 		.max_uV = 4500000,
+		.table_len = 73,
 	},
 	{
 		.name = "VDDCTRL",
 		.min_uV = 600000,
 		.max_uV = 1400000,
+		.table_len = 65,
 	},
 	{
 		.name = "LDO1",
 		.min_uV = 1000000,
 		.max_uV = 3300000,
+		.table_len = 47,
 	},
 	{
 		.name = "LDO2",
 		.min_uV = 1000000,
 		.max_uV = 3300000,
+		.table_len = 47,
 	},
 	{
 		.name = "LDO3",
 		.min_uV = 1000000,
 		.max_uV = 3300000,
+		.table_len = 24,
 	},
 	{
 		.name = "LDO4",
 		.min_uV = 1000000,
 		.max_uV = 3300000,
+		.table_len = 47,
 	},
 	{
 		.name = "LDO5",
 		.min_uV = 1000000,
 		.max_uV = 3300000,
+		.table_len = 24,
 	},
 	{
 		.name = "LDO6",
 		.min_uV = 1000000,
 		.max_uV = 3300000,
+		.table_len = 24,
 	},
 	{
 		.name = "LDO7",
 		.min_uV = 1000000,
 		.max_uV = 3300000,
+		.table_len = 24,
 	},
 	{
 		.name = "LDO8",
 		.min_uV = 1000000,
 		.max_uV = 3300000,
+		.table_len = 24,
 	},
 };
 
-- 
1.7.1.1

