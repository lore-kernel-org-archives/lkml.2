Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756882Ab2DFAat (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 20:30:49 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:62303 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756300Ab2DFAas (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 20:30:48 -0400
Message-ID: <1333672242.2777.8.camel@phoenix>
Subject: [PATCH 5/6] regulator: tps6105x: Constify regulator_desc
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Fri, 06 Apr 2012 08:30:42 +0800
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
 drivers/regulator/tps6105x-regulator.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/regulator/tps6105x-regulator.c b/drivers/regulator/tps6105x-regulator.c
index d9278da..3b78897 100644
--- a/drivers/regulator/tps6105x-regulator.c
+++ b/drivers/regulator/tps6105x-regulator.c
@@ -123,7 +123,7 @@ static struct regulator_ops tps6105x_regulator_ops = {
 	.list_voltage	= tps6105x_regulator_list_voltage,
 };
 
-static struct regulator_desc tps6105x_regulator_desc = {
+static const struct regulator_desc tps6105x_regulator_desc = {
 	.name		= "tps6105x-boost",
 	.ops		= &tps6105x_regulator_ops,
 	.type		= REGULATOR_VOLTAGE,
-- 
1.7.5.4



