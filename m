Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756800Ab2DFAYf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 20:24:35 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:32854 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753203Ab2DFAYd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 20:24:33 -0400
Message-ID: <1333671867.2777.2.camel@phoenix>
Subject: [PATCH 1/6] regulator: max1586: Constify regulator_desc
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Robert Jarzmik <robert.jarzmik@free.fr>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Fri, 06 Apr 2012 08:24:27 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/max1586.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/regulator/max1586.c b/drivers/regulator/max1586.c
index 282d2ee..fad0bee 100644
--- a/drivers/regulator/max1586.c
+++ b/drivers/regulator/max1586.c
@@ -161,7 +161,7 @@ static struct regulator_ops max1586_v6_ops = {
 	.list_voltage = max1586_v6_list,
 };
 
-static struct regulator_desc max1586_reg[] = {
+static const struct regulator_desc max1586_reg[] = {
 	{
 		.name = "Output_V3",
 		.id = MAX1586_V3,
-- 
1.7.5.4



