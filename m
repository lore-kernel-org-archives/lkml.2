Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752165Ab2LJGUf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 01:20:35 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:63158 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751792Ab2LJGUc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 01:20:32 -0500
X-AuditID: cbfee61a-b7fa66d0000004cf-02-50c57f2f6e73
From: Abhilash Kesavan <a.kesavan@samsung.com>
To: lrg@ti.com, broonie@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org
Cc: dianders@chromium.org, olof@lixom.net, grant.likely@secretlab.ca,
        thomas.abraham@linaro.org, kgene.kim@samsung.com,
        sameo@linux.intel.com, Abhilash Kesavan <a.kesavan@samsung.com>
Subject: [RFC PATCH 2/3] regulator: max77686: Add support for various operating
 modes
Date: Mon, 10 Dec 2012 11:56:23 +0530
Message-id: <1355120784-31118-3-git-send-email-a.kesavan@samsung.com>
X-Mailer: git-send-email 1.6.6.1
In-reply-to: <1355120784-31118-2-git-send-email-a.kesavan@samsung.com>
References: <1355120784-31118-1-git-send-email-a.kesavan@samsung.com>
 <1355120784-31118-2-git-send-email-a.kesavan@samsung.com>
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrNLMWRmVeSWpSXmKPExsWyRsSkVle//miAwdO9QhaXd81hc2D0+LxJ
	LoAxissmJTUnsyy1SN8ugSvj/LOnbAW9AhVneyMaGM/zdjFyckgImEg86JvOBGGLSVy4t56t
	i5GLQ0hgKaPElderGWGKfh7eygyRWMQosXriRVYIZzmTxOSFLSwgVWwCehIL/n1lBrFFBIIl
	Zv9sABvFLLCbUeLBmyVgCWGBcIkrsyYD2RwcLAKqEhNv8YGEeQVcJaZO/gh1hoLE6Q9r2UFK
	OAXcJFrX1kLsamSUeLxhJ9gYFgEBiW+TD7GA1EgIyEpsOgB2nITAZTaJg/dAekHmSEocXHGD
	ZQKj8AJGhlWMoqkFyQXFSem5hnrFibnFpXnpesn5uZsYgSF4+t8zqR2MKxssDjEKcDAq8fAG
	KB4NEGJNLCuuzD3EKMHBrCTCy3XsSIAQb0piZVVqUX58UWlOavEhRh+gSyYyS4km5wPjI68k
	3tDYxNzU2NTSyMjM1BSHsJI4b7NHSoCQQHpiSWp2ampBahHMOCYOTqkGRqY3jfNirZ9s7WL0
	eCakL7miTyfqoubiWd9ni6ftmTNt369DBkeUZri7VRxg7XQp/R1ywNhAVCNmf5pc7eWn7+qn
	vd+qeyBDqzK6SK0zxkxhQ96JqGLGbc3pd7TfaB0SuLhykfLvy0Y1xyz1+TyuCjcryy152HzK
	5G+8bZbnFTGH5ndbM107lFiKMxINtZiLihMBdh/3R24CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupikeLIzCtJLcpLzFFi42I5/e+xgK5+/dEAgy1HGS0u75rD5sDo8XmT
	XABjVAOjTUZqYkpqkUJqXnJ+SmZeuq2Sd3C8c7ypmYGhrqGlhbmSQl5ibqqtkotPgK5bZg7Q
	VCWFssScUqBQQGJxsZK+HaYJoSFuuhYwjRG6viFBcD1GBmggYQ1jxvlnT9kKegUqzvZGNDCe
	5+1i5OSQEDCR+Hl4KzOELSZx4d56ti5GLg4hgUWMEqsnXmSFcJYzSUxe2MICUsUmoCex4N9X
	sA4RgWCJ2T8bwDqYBXYzSjx4swQsISwQLnFl1mQgm4ODRUBVYuItPpAwr4CrxNTJH5kgtilI
	nP6wlh2khFPATaJ1bS3ErkZGiccbdjJPYORdwMiwilE0tSC5oDgpPddQrzgxt7g0L10vOT93
	EyM4wJ9J7WBc2WBxiFGAg1GJhzdA8WiAEGtiWXFl7iFGCQ5mJRFermNHAoR4UxIrq1KL8uOL
	SnNSiw8x+gAdNZFZSjQ5Hxh9eSXxhsYm5qbGppYmFiZmljiElcR5mz1SAoQE0hNLUrNTUwtS
	i2DGMXFwSjUw7lxoJLQxUPWd1QH/yWGPj+3WfKKwpzo1iOHqye0GQSWSqq6xYTvWdQsv0Xp/
	QX1RuKNpykn2x5u+64Z3/GOVOee4OXflzX9hfNt+quqZTQpKU/5RzlRz9PJHH7/fNm8cH/d1
	TQpS/Z60lakrqEtvyYe3ylWpFy85ecSmNrPWqE5zMl/1giFDiaU4I9FQi7moOBEAFkbMPp0C	AAA=
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, we cannot specify the regulator suspend state via device
tree. Add an optional operating mode property which can be used to
set initially the regulator mode.
We are currently bypassing the set_suspend_disable and set_suspend_mode
call-backs.

Signed-off-by: Abhilash Kesavan <a.kesavan@samsung.com>
---
 drivers/regulator/max77686.c |   11 ++++++++++-
 include/linux/mfd/max77686.h |    1 +
 2 files changed, 11 insertions(+), 1 deletions(-)

diff --git a/drivers/regulator/max77686.c b/drivers/regulator/max77686.c
index b85040c..7f16bc7 100644
--- a/drivers/regulator/max77686.c
+++ b/drivers/regulator/max77686.c
@@ -410,6 +410,12 @@ static int max77686_pmic_dt_parse_pdata(struct max77686_dev *iodev,
 		of_regulator_match(iodev->dev, regulators_np, &rmatch, 1);
 		rdata[i].initdata = rmatch.init_data;
 		rdata[i].of_node = rmatch.of_node;
+		if (of_property_read_u32(rdata[i].of_node, "max77686-opmode",
+			&rdata[i].opmode)) {
+			dev_warn(iodev->dev, "no op_mode property property at %s\n",
+			rmatch.name);
+			rdata[i].opmode = regulators[i].enable_mask;
+		}
 	}
 
 	pdata->regulators = rdata;
@@ -465,7 +471,10 @@ static int max77686_pmic_probe(struct platform_device *pdev)
 		config.init_data = pdata->regulators[i].initdata;
 		config.of_node = pdata->regulators[i].of_node;
 
-		max77686->opmode[i] = regulators[i].enable_mask;
+		if (config.of_node)
+			max77686->opmode[i] = pdata->regulators[i].opmode;
+		else
+			max77686->opmode[i] = regulators[i].enable_mask;
 		max77686->rdev[i] = regulator_register(&regulators[i], &config);
 		if (IS_ERR(max77686->rdev[i])) {
 			ret = PTR_ERR(max77686->rdev[i]);
diff --git a/include/linux/mfd/max77686.h b/include/linux/mfd/max77686.h
index 46c0f32..e8bd83b 100644
--- a/include/linux/mfd/max77686.h
+++ b/include/linux/mfd/max77686.h
@@ -73,6 +73,7 @@ enum max77686_regulators {
 
 struct max77686_regulator_data {
 	int id;
+	int opmode;
 	struct regulator_init_data *initdata;
 	struct device_node *of_node;
 };
-- 
1.7.8.6

