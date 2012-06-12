Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752194Ab2FLJS4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 05:18:56 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:61906 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751185Ab2FLJSz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 05:18:55 -0400
Message-ID: <1339492729.6743.4.camel@phoenix>
Subject: [PATCH] regulator: wm8350: Add missing min_uV and uV_step settings
 for DCDC4
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Tue, 12 Jun 2012 17:18:49 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/wm8350-regulator.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/regulator/wm8350-regulator.c b/drivers/regulator/wm8350-regulator.c
index ca678ee..53bf3df 100644
--- a/drivers/regulator/wm8350-regulator.c
+++ b/drivers/regulator/wm8350-regulator.c
@@ -1105,6 +1105,8 @@ static const struct regulator_desc wm8350_reg[NUM_WM8350_REGULATORS] = {
 		.irq = WM8350_IRQ_UV_DC4,
 		.type = REGULATOR_VOLTAGE,
 		.n_voltages = WM8350_DCDC_MAX_VSEL + 1,
+		.min_uV = 850000,
+		.uV_step = 25000,
 		.vsel_reg = WM8350_DCDC4_CONTROL,
 		.vsel_mask = WM8350_DC4_VSEL_MASK,
 		.enable_reg = WM8350_DCDC_LDO_REQUESTED,
-- 
1.7.9.5



