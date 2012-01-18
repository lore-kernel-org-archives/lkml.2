Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757888Ab2ARPRJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 10:17:09 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:4440 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757719Ab2ARPRH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 10:17:07 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Wed, 18 Jan 2012 07:17:07 -0800
From: Laxman Dewangan <ldewangan@nvidia.com>
To: lrg@ti.com, broonie@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org
Cc: linux-tegra@vger.kernel.org, ldewangan@nvidia.com
Subject: [PATCH V1 1/2] regulator: tps65910: Add regulator info for RTC rail
Date: Wed, 18 Jan 2012 20:46:56 +0530
Message-Id: <1326899816-14436-1-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding missing regulator info for VRTC rail for device
tps65911. The regulator voltage rail index start from
VRTC which is defined as 0.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
 drivers/regulator/tps65910-regulator.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/regulator/tps65910-regulator.c b/drivers/regulator/tps65910-regulator.c
index 5c15ba0..6742418 100644
--- a/drivers/regulator/tps65910-regulator.c
+++ b/drivers/regulator/tps65910-regulator.c
@@ -175,6 +175,9 @@ static struct tps_info tps65910_regs[] = {
 
 static struct tps_info tps65911_regs[] = {
 	{
+		.name = "VRTC",
+	},
+	{
 		.name = "VIO",
 		.min_uV = 1500000,
 		.max_uV = 3300000,
-- 
1.7.1.1

