Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933564Ab2HWAMB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 20:12:01 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:25666 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933540Ab2HWAL4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 20:11:56 -0400
X-AuditID: cbfee61b-b7faf6d00000476a-c4-5035754ad9fa
From: Chanwoo Choi <cw00.choi@samsung.com>
To: gregkh@linuxfoundation.org
Cc: pmeerw@pmeerw.net, myungjoo.ham@samsung.com, kyungmin.park@samsung.com,
        linux-kernel@vger.kernel.org, trivial@kernelg.org,
        Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCH 3/4] extcon: fix typos in extcon-arizona
Date: Thu, 23 Aug 2012 09:11:50 +0900
Message-id: <1345680710-5940-1-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.7.0.4
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrNJMWRmVeSWpSXmKPExsVy+t9jAV2vUtMAg+dvBSwu75rD5sDo8XmT
	XABjFJdNSmpOZllqkb5dAlfG1C3NLAXXOCr2n73I1MC4kL2LkZNDQsBE4mrjUlYIW0ziwr31
	bF2MXBxCAosYJV63H2eEcJYySfx60cUMUsUmoCWx/8UNNhBbREBO4sntP8wgRcwCyxklWm+9
	B0sIC1hI3Ly3mgXEZhFQlTh0oZ0JxOYVcJFouLmQGWKdgkTrskPsExi5FzAyrGIUTS1ILihO
	Ss810itOzC0uzUvXS87P3cQI9uIz6R2MqxosDjEKcDAq8fBmxJoGCLEmlhVX5h5ilOBgVhLh
	7SoCCvGmJFZWpRblxxeV5qQWH2KU5mBREufl7zMMEBJITyxJzU5NLUgtgskycXBKNTDyvfG8
	rLh7xZUzvfucJzQp1Zx+vd9EZd2WSXV7fpyoXn3KdWV02r4TBxaf9N41dctfXln2gxqSbQHs
	xTbNwXwz0wVi8xbvVVrs4fKQj9d5s78q4+udSYcsF227fvML09kZVxW3H9m/w2590TcFftFr
	rQstltrGvVdamxspe4pdeOOEBKbdkyWElFiKMxINtZiLihMBX3rykd4BAAA=
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Meerwald <pmeerw@pmeerw.net>

Signed-off-by: Peter Meerwald <pmeerw@pmeerw.net>
Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
---
 drivers/extcon/extcon-arizona.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/extcon/extcon-arizona.c b/drivers/extcon/extcon-arizona.c
index fa2114f..55fbc2f 100644
--- a/drivers/extcon/extcon-arizona.c
+++ b/drivers/extcon/extcon-arizona.c
@@ -348,7 +348,7 @@ static int __devinit arizona_extcon_probe(struct platform_device *pdev)
 
 	info = devm_kzalloc(&pdev->dev, sizeof(*info), GFP_KERNEL);
 	if (!info) {
-		dev_err(&pdev->dev, "failed to allocate memory\n");
+		dev_err(&pdev->dev, "Failed to allocate memory\n");
 		ret = -ENOMEM;
 		goto err;
 	}
@@ -385,7 +385,7 @@ static int __devinit arizona_extcon_probe(struct platform_device *pdev)
 
 	ret = extcon_dev_register(&info->edev, arizona->dev);
 	if (ret < 0) {
-		dev_err(arizona->dev, "extcon_dev_regster() failed: %d\n",
+		dev_err(arizona->dev, "extcon_dev_register() failed: %d\n",
 			ret);
 		goto err;
 	}
-- 
1.7.0.4

