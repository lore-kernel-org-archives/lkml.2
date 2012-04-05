Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757437Ab2DED71 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2012 23:59:27 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:44524 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753160Ab2DED70 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2012 23:59:26 -0400
Message-ID: <1333598360.10597.5.camel@phoenix>
Subject: [PATCH 3/6] regulator: lp3971: Constify regulator_desc
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Thu, 05 Apr 2012 11:59:20 +0800
In-Reply-To: <1333598216.10597.3.camel@phoenix>
References: <1333598216.10597.3.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/lp3971.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/regulator/lp3971.c b/drivers/regulator/lp3971.c
index 2013525..499986e 100644
--- a/drivers/regulator/lp3971.c
+++ b/drivers/regulator/lp3971.c
@@ -281,7 +281,7 @@ static struct regulator_ops lp3971_dcdc_ops = {
 	.set_voltage_sel = lp3971_dcdc_set_voltage_sel,
 };
 
-static struct regulator_desc regulators[] = {
+static const struct regulator_desc regulators[] = {
 	{
 		.name = "LDO1",
 		.id = LP3971_LDO1,
-- 
1.7.5.4



