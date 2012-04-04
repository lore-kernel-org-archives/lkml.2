Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756228Ab2DDKrI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2012 06:47:08 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:44723 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756179Ab2DDKrE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2012 06:47:04 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Liam Girdwood <lrg@ti.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 3/3] regulator: wm8994: Constify regulator_desc
Date: Wed,  4 Apr 2012 11:47:00 +0100
Message-Id: <1333536420-9639-3-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.9.1
In-Reply-To: <1333536420-9639-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1333536420-9639-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/regulator/wm8994-regulator.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/regulator/wm8994-regulator.c b/drivers/regulator/wm8994-regulator.c
index 75ed402..8a4897a 100644
--- a/drivers/regulator/wm8994-regulator.c
+++ b/drivers/regulator/wm8994-regulator.c
@@ -209,7 +209,7 @@ static struct regulator_ops wm8994_ldo2_ops = {
 	.set_voltage = wm8994_ldo2_set_voltage,
 };
 
-static struct regulator_desc wm8994_ldo_desc[] = {
+static const struct regulator_desc wm8994_ldo_desc[] = {
 	{
 		.name = "LDO1",
 		.id = 1,
-- 
1.7.9.1

