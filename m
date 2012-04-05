Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752359Ab2DEECn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 00:02:43 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:48786 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750817Ab2DEECm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 00:02:42 -0400
Message-ID: <1333598556.10597.8.camel@phoenix>
Subject: [PATCH 6/6] regulator: pcf50633: Constify regulator_desc
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Lars-Peter Clausen <lars@metafoo.de>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Thu, 05 Apr 2012 12:02:36 +0800
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
 drivers/regulator/pcf50633-regulator.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/regulator/pcf50633-regulator.c b/drivers/regulator/pcf50633-regulator.c
index b62f4c8..43163f1 100644
--- a/drivers/regulator/pcf50633-regulator.c
+++ b/drivers/regulator/pcf50633-regulator.c
@@ -267,7 +267,7 @@ static struct regulator_ops pcf50633_regulator_ops = {
 	.is_enabled = pcf50633_regulator_is_enabled,
 };
 
-static struct regulator_desc regulators[] = {
+static const struct regulator_desc regulators[] = {
 	[PCF50633_REGULATOR_AUTO] =
 		PCF50633_REGULATOR("auto", PCF50633_REGULATOR_AUTO, 128),
 	[PCF50633_REGULATOR_DOWN1] =
-- 
1.7.5.4



