Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756214Ab2DDKrG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2012 06:47:06 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:44722 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755854Ab2DDKrE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2012 06:47:04 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Liam Girdwood <lrg@ti.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 2/3] regulator: wm8350: Constify regulator_desc
Date: Wed,  4 Apr 2012 11:46:59 +0100
Message-Id: <1333536420-9639-2-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.9.1
In-Reply-To: <1333536420-9639-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1333536420-9639-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/regulator/wm8350-regulator.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/regulator/wm8350-regulator.c b/drivers/regulator/wm8350-regulator.c
index ab1e183..552b1ed 100644
--- a/drivers/regulator/wm8350-regulator.c
+++ b/drivers/regulator/wm8350-regulator.c
@@ -1269,7 +1269,7 @@ static struct regulator_ops wm8350_isink_ops = {
 	.enable_time = wm8350_isink_enable_time,
 };
 
-static struct regulator_desc wm8350_reg[NUM_WM8350_REGULATORS] = {
+static const struct regulator_desc wm8350_reg[NUM_WM8350_REGULATORS] = {
 	{
 		.name = "DCDC1",
 		.id = WM8350_DCDC_1,
-- 
1.7.9.1

