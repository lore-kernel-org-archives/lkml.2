Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752157Ab1GUAVd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jul 2011 20:21:33 -0400
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:40597 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751818Ab1GUAVc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jul 2011 20:21:32 -0400
From: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
To: Grant Likely <grant.likely@secretlab.ca>, linux-kernel@vger.kernel.org,
        alexander.stein@systec-electronic.com
Cc: qi.wang@intel.com, yong.y.wang@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com, toshiharu-linux@dsn.okisemi.com,
        Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
Subject: [PATCH 1/6 v2] gpio-pch: Delete invalid "restore" code in suspend()
Date: Thu, 21 Jul 2011 09:19:54 +0900
Message-Id: <1311207599-2553-1-git-send-email-tomoya-linux@dsn.okisemi.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
---
 drivers/gpio/gpio-pch.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/gpio/gpio-pch.c b/drivers/gpio/gpio-pch.c
index 36919e7..ca9c7b0 100644
--- a/drivers/gpio/gpio-pch.c
+++ b/drivers/gpio/gpio-pch.c
@@ -241,7 +241,6 @@ static int pch_gpio_suspend(struct pci_dev *pdev, pm_message_t state)
 	struct pch_gpio *chip = pci_get_drvdata(pdev);
 
 	pch_gpio_save_reg_conf(chip);
-	pch_gpio_restore_reg_conf(chip);
 
 	ret = pci_save_state(pdev);
 	if (ret) {
-- 
1.7.4.4

