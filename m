Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755860Ab1DPPog (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Apr 2011 11:44:36 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:42384 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751811Ab1DPPo3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Apr 2011 11:44:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=P9xZYdDGnDwwWHNsnmpGsNm+qBZMc+ShHev2IdCAwpoF0rbZBy/xjAlBK/xJCLYTZI
         sfrQku2i1dF/b10MORpCVrKYIpP2FfU30BaM8Abxtn2Ap/ou8od4qxFrTzUzF7eK2PrK
         a9adXO1Y5wfIF6YOSoROUQYwt+TnLfHMWG8L0=
From: wanlong.gao@gmail.com
To: linux-kernel@vger.kernel.org, trivial@kernel.org
Cc: lrg@slimlogic.co.uk, broonie@opensource.wolfsonmicro.com,
        Wanlong Gao <wanlong.gao@gmail.com>
Subject: [PATCH]drivers:regulator:change the dev_dbg in the probe function
Date: Sat, 16 Apr 2011 23:42:23 +0800
Message-Id: <1302968543-3150-1-git-send-email-wanlong.gao@gmail.com>
X-Mailer: git-send-email 1.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wanlong Gao <wanlong.gao@gmail.com>

change the function name string to "%s".

Signed-off-by: Wanlong Gao <wanlong.gao@gmail.com>
---
 drivers/regulator/mc13783-regulator.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/regulator/mc13783-regulator.c b/drivers/regulator/mc13783-regulator.c
index 23249cb..b8a00c7 100644
--- a/drivers/regulator/mc13783-regulator.c
+++ b/drivers/regulator/mc13783-regulator.c
@@ -341,7 +341,7 @@ static int __devinit mc13783_regulator_probe(struct platform_device *pdev)
 	struct mc13783_regulator_init_data *init_data;
 	int i, ret;
 
-	dev_dbg(&pdev->dev, "mc13783_regulator_probe id %d\n", pdev->id);
+	dev_dbg(&pdev->dev, "%s id %d\n", __func__, pdev->id);
 
 	priv = kzalloc(sizeof(*priv) +
 			pdata->num_regulators * sizeof(priv->regulators[0]),
-- 
1.7.3

