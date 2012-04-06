Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756864Ab2DFA1H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 20:27:07 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:63435 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753287Ab2DFA1E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 20:27:04 -0400
Message-ID: <1333672019.2777.5.camel@phoenix>
Subject: [PATCH 3/6] regulator: max8660: Constify regulator_desc
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Wolfram Sang <w.sang@pengutronix.de>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Fri, 06 Apr 2012 08:26:59 +0800
In-Reply-To: <1333671867.2777.2.camel@phoenix>
References: <1333671867.2777.2.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/max8660.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/regulator/max8660.c b/drivers/regulator/max8660.c
index e42db53..0e32787 100644
--- a/drivers/regulator/max8660.c
+++ b/drivers/regulator/max8660.c
@@ -313,7 +313,7 @@ static struct regulator_ops max8660_ldo67_ops = {
 	.set_voltage = max8660_ldo67_set,
 };
 
-static struct regulator_desc max8660_reg[] = {
+static const struct regulator_desc max8660_reg[] = {
 	{
 		.name = "V3(DCDC)",
 		.id = MAX8660_V3,
-- 
1.7.5.4



