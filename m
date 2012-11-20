Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751901Ab2KTF27 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 00:28:59 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:61866 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750930Ab2KTF24 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 00:28:56 -0500
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: myungjoo.ham@samsung.com, cw00.choi@samsung.com, sachin.kamat@linaro.org,
        patches@linaro.org
Subject: [PATCH 1/7] extcon: max8997: Fix checkpatch error
Date: Tue, 20 Nov 2012 10:52:37 +0530
Message-Id: <1353388963-23761-2-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1353388963-23761-1-git-send-email-sachin.kamat@linaro.org>
References: <1353388963-23761-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixes the following checkpatch error:
ERROR: space required after that ',' (ctx:VxV)
460: FILE: extcon/extcon-max8997.c:460:
		ret = request_threaded_irq(virq, NULL,max8997_muic_irq_handler,
		                                     ^

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/extcon/extcon-max8997.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/extcon/extcon-max8997.c b/drivers/extcon/extcon-max8997.c
index 77b66b0..c364794 100644
--- a/drivers/extcon/extcon-max8997.c
+++ b/drivers/extcon/extcon-max8997.c
@@ -457,7 +457,7 @@ static int __devinit max8997_muic_probe(struct platform_device *pdev)
 			goto err_irq;
 		muic_irq->virq = virq;
 
-		ret = request_threaded_irq(virq, NULL,max8997_muic_irq_handler,
+		ret = request_threaded_irq(virq, NULL, max8997_muic_irq_handler,
 				0, muic_irq->name, info);
 		if (ret) {
 			dev_err(&pdev->dev,
-- 
1.7.4.1

