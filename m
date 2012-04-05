Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757004Ab2DED5D (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2012 23:57:03 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:38345 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752554Ab2DED5B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2012 23:57:01 -0400
Message-ID: <1333598216.10597.3.camel@phoenix>
Subject: [PATCH 1/6] regulator: ad5398: Constify regulator_desc
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Sonic Zhang <sonic.zhang@analog.com>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Thu, 05 Apr 2012 11:56:56 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/ad5398.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/regulator/ad5398.c b/drivers/regulator/ad5398.c
index 7d51793..9ba69c4 100644
--- a/drivers/regulator/ad5398.c
+++ b/drivers/regulator/ad5398.c
@@ -184,7 +184,7 @@ static struct regulator_ops ad5398_ops = {
 	.is_enabled = ad5398_is_enabled,
 };
 
-static struct regulator_desc ad5398_reg = {
+static const struct regulator_desc ad5398_reg = {
 	.name = "isink",
 	.id = 0,
 	.ops = &ad5398_ops,
-- 
1.7.5.4



