Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965100Ab2HVT2d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 15:28:33 -0400
Received: from ns.pmeerw.net ([87.118.82.44]:47027 "EHLO pmeerw.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757633Ab2HVT1u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 15:27:50 -0400
From: Peter Meerwald <pmeerw@pmeerw.net>
To: linux-kernel@vger.kernel.org
Cc: myungjoo.ham@samsung.com, cw00.choi@samsung.com,
        broonie@opensource.wolfsonmicro.com, trivial@kernel.org,
        Peter Meerwald <pmeerw@pmeerw.net>
Subject: [PATCH RESEND] extcon: fix typos in extcon-arizona
Date: Wed, 22 Aug 2012 21:27:43 +0200
Message-Id: <1345663663-4790-4-git-send-email-pmeerw@pmeerw.net>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1345663663-4790-1-git-send-email-pmeerw@pmeerw.net>
References: <1345663663-4790-1-git-send-email-pmeerw@pmeerw.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Peter Meerwald <pmeerw@pmeerw.net>
---
 drivers/extcon/extcon-arizona.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/extcon/extcon-arizona.c b/drivers/extcon/extcon-arizona.c
index 427a289..6d24822 100644
--- a/drivers/extcon/extcon-arizona.c
+++ b/drivers/extcon/extcon-arizona.c
@@ -313,7 +313,7 @@ static int __devinit arizona_extcon_probe(struct platform_device *pdev)
 
 	info = devm_kzalloc(&pdev->dev, sizeof(*info), GFP_KERNEL);
 	if (!info) {
-		dev_err(&pdev->dev, "failed to allocate memory\n");
+		dev_err(&pdev->dev, "Failed to allocate memory\n");
 		ret = -ENOMEM;
 		goto err;
 	}
@@ -350,7 +350,7 @@ static int __devinit arizona_extcon_probe(struct platform_device *pdev)
 
 	ret = extcon_dev_register(&info->edev, arizona->dev);
 	if (ret < 0) {
-		dev_err(arizona->dev, "extcon_dev_regster() failed: %d\n",
+		dev_err(arizona->dev, "extcon_dev_register() failed: %d\n",
 			ret);
 		goto err;
 	}
-- 
1.7.9.5

