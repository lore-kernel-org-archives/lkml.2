Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757291Ab2DED6M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2012 23:58:12 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:38433 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752554Ab2DED6L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2012 23:58:11 -0400
Message-ID: <1333598286.10597.4.camel@phoenix>
Subject: [PATCH 2/6] regulator: isl6271a: Constify regulator_desc
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Marek Vasut <marek.vasut@gmail.com>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Thu, 05 Apr 2012 11:58:06 +0800
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
 drivers/regulator/isl6271a-regulator.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/regulator/isl6271a-regulator.c b/drivers/regulator/isl6271a-regulator.c
index 6539ef9..eee6f6b 100644
--- a/drivers/regulator/isl6271a-regulator.c
+++ b/drivers/regulator/isl6271a-regulator.c
@@ -112,7 +112,7 @@ static struct regulator_ops isl_fixed_ops = {
 	.list_voltage	= isl6271a_list_fixed_voltage,
 };
 
-static struct regulator_desc isl_rd[] = {
+static const struct regulator_desc isl_rd[] = {
 	{
 		.name		= "Core Buck",
 		.id		= 0,
-- 
1.7.5.4



