Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751511Ab1GTKMI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jul 2011 06:12:08 -0400
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:25846 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750936Ab1GTKMH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jul 2011 06:12:07 -0400
From: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
To: Grant Likely <grant.likely@secretlab.ca>, linux-kernel@vger.kernel.org,
        alexander.stein@systec-electronic.com
Cc: qi.wang@intel.com, yong.y.wang@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com, toshiharu-linux@dsn.okisemi.com,
        Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
Subject: [PATCH 1/6] pch_gpio: Delete invalid "restore" code in suspend()
Date: Wed, 20 Jul 2011 19:10:57 +0900
Message-Id: <1311156662-3044-1-git-send-email-tomoya-linux@dsn.okisemi.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
---
 drivers/gpio/pch_gpio.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/gpio/pch_gpio.c b/drivers/gpio/pch_gpio.c
index 36919e7..ca9c7b0 100644
--- a/drivers/gpio/pch_gpio.c
+++ b/drivers/gpio/pch_gpio.c
@@ -241,7 +241,6 @@ static int pch_gpio_suspend(struct pci_dev *pdev, pm_message_t state)
 	struct pch_gpio *chip = pci_get_drvdata(pdev);
 
 	pch_gpio_save_reg_conf(chip);
-	pch_gpio_restore_reg_conf(chip);
 
 	ret = pci_save_state(pdev);
 	if (ret) {
-- 
1.7.4.4

