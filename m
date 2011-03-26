Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752464Ab1CZP2u (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Mar 2011 11:28:50 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:34123 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751823Ab1CZP2t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Mar 2011 11:28:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=r6rlJvD1Y9PVF9+R+SKstSyoSYXHTgBHNoQME4PsCZp4TahuQ4lftj8P58nmvktItQ
         P5Kwz6s1WrjUSwkDv7mskk2jbW8l3biAVNLVE12JGE76wYkjic0y+MGo/TVJmqhD+JeG
         48GgoBpRwK1HCnnV3ks6ewVGWwKeJefhln13I=
Subject: [PATCH] regulator: Add MODULE_DEVICE_TABLE to max8997 and max8998
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: MyungJoo Ham <myungjoo.ham@smasung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        MyungJoo Ham <myungjoo.ham@smasung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 26 Mar 2011 23:28:42 +0800
Message-ID: <1301153322.3302.3.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The device table is required to load modules based on modaliases.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
Cc: MyungJoo Ham <myungjoo.ham@smasung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>

---
 drivers/regulator/max8997.c |    1 +
 drivers/regulator/max8998.c |    1 +
 2 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/regulator/max8997.c b/drivers/regulator/max8997.c
index 01ef7e9..77e0cfb 100644
--- a/drivers/regulator/max8997.c
+++ b/drivers/regulator/max8997.c
@@ -1185,6 +1185,7 @@ static const struct platform_device_id max8997_pmic_id[] = {
 	{ "max8997-pmic", 0},
 	{ },
 };
+MODULE_DEVICE_TABLE(platform, max8997_pmic_id);
 
 static struct platform_driver max8997_pmic_driver = {
 	.driver = {
diff --git a/drivers/regulator/max8998.c b/drivers/regulator/max8998.c
index 0ec49ca..4341026 100644
--- a/drivers/regulator/max8998.c
+++ b/drivers/regulator/max8998.c
@@ -887,6 +887,7 @@ static const struct platform_device_id max8998_pmic_id[] = {
 	{ "lp3974-pmic", TYPE_LP3974 },
 	{ }
 };
+MODULE_DEVICE_TABLE(platform, max8998_pmic_id);
 
 static struct platform_driver max8998_pmic_driver = {
 	.driver = {
-- 
1.7.1



