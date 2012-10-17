Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757236Ab2JQOfT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 10:35:19 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:41375 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756228Ab2JQOfS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 10:35:18 -0400
From: Sangho Yi <antiroot@gmail.com>
To: myungjoo.ham@samsung.com, cw00.choi@samsung.com
Cc: linux-kernel@vger.kernel.org, Sangho Yi <antiroot@gmail.com>
Subject: [PATCH] extcon: extcon-max8997.c: fixed coding style warning
Date: Wed, 17 Oct 2012 23:33:57 +0900
Message-Id: <1350484437-3492-1-git-send-email-antiroot@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <n>
References: <n>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added a whitespace after a comma (,) to follow the coding style.

Signed-off-by: Sangho Yi <antiroot@gmail.com>
---
 drivers/extcon/extcon-max8997.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/extcon/extcon-max8997.c b/drivers/extcon/extcon-max8997.c
index ef9090a..a094eee 100644
--- a/drivers/extcon/extcon-max8997.c
+++ b/drivers/extcon/extcon-max8997.c
@@ -459,8 +459,9 @@ static int __devinit max8997_muic_probe(struct platform_device *pdev)
 			goto err_irq;
 		muic_irq->virq = virq;
 
-		ret = request_threaded_irq(virq, NULL,max8997_muic_irq_handler,
-				0, muic_irq->name, info);
+		ret = request_threaded_irq(virq, NULL,
+			max8997_muic_irq_handler,
+			0, muic_irq->name, info);
 		if (ret) {
 			dev_err(&pdev->dev,
 				"failed: irq request (IRQ: %d,"
-- 
1.7.9.5

