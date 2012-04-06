Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756857Ab2DFA0N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 20:26:13 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:56269 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753287Ab2DFA0M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 20:26:12 -0400
Message-ID: <1333671966.2777.4.camel@phoenix>
Subject: [PATCH 2/6] regulator: max8649: Constify regulator_desc
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Jonghwan Choi <jhbird.choi@gmail.com>,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>
Date: Fri, 06 Apr 2012 08:26:06 +0800
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
 drivers/regulator/max8649.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/regulator/max8649.c b/drivers/regulator/max8649.c
index 2e9ffbe..dca7835 100644
--- a/drivers/regulator/max8649.c
+++ b/drivers/regulator/max8649.c
@@ -207,7 +207,7 @@ static struct regulator_ops max8649_dcdc_ops = {
 
 };
 
-static struct regulator_desc dcdc_desc = {
+static const struct regulator_desc dcdc_desc = {
 	.name		= "max8649",
 	.ops		= &max8649_dcdc_ops,
 	.type		= REGULATOR_VOLTAGE,
-- 
1.7.5.4



