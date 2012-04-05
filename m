Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751635Ab2DEEAh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 00:00:37 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:64269 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750817Ab2DEEAg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 00:00:36 -0400
Message-ID: <1333598432.10597.6.camel@phoenix>
Subject: [PATCH 4/6] regulator: lp3972: Constify regulator_desc
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Thu, 05 Apr 2012 12:00:32 +0800
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
 drivers/regulator/lp3972.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/regulator/lp3972.c b/drivers/regulator/lp3972.c
index 4f28d36..fbe3a58 100644
--- a/drivers/regulator/lp3972.c
+++ b/drivers/regulator/lp3972.c
@@ -444,7 +444,7 @@ static struct regulator_ops lp3972_dcdc_ops = {
 	.set_voltage_sel = lp3972_dcdc_set_voltage_sel,
 };
 
-static struct regulator_desc regulators[] = {
+static const struct regulator_desc regulators[] = {
 	{
 		.name = "LDO1",
 		.id = LP3972_LDO1,
-- 
1.7.5.4



