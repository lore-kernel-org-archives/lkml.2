Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756234Ab1GAMKP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 08:10:15 -0400
Received: from mail.karo-electronics.de ([81.173.242.67]:49364 "EHLO
	mail.karo-electronics.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755547Ab1GAMKE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 08:10:04 -0400
From: =?utf-8?q?Lothar=20Wa=C3=9Fmann?= <LW@KARO-electronics.de>
To: linux-kernel@vger.kernel.org
Cc: Grant Likely <grant.likely@secretlab.ca>,
        =?utf-8?q?Lothar=20Wa=C3=9Fmann?= <LW@KARO-electronics.de>
Subject: [PATCH] add missing intialisation of bgc->dir
Date: Fri,  1 Jul 2011 14:08:51 +0200
Message-Id: <1309522131-2237-2-git-send-email-LW@KARO-electronics.de>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1309522131-2237-1-git-send-email-LW@KARO-electronics.de>
References: <1309522131-2237-1-git-send-email-LW@KARO-electronics.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---
 drivers/gpio/basic_mmio_gpio.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/gpio/basic_mmio_gpio.c b/drivers/gpio/basic_mmio_gpio.c
index 8152e9f..e69a453 100644
--- a/drivers/gpio/basic_mmio_gpio.c
+++ b/drivers/gpio/basic_mmio_gpio.c
@@ -399,6 +399,7 @@ int __devinit bgpio_init(struct bgpio_chip *bgc,
 		return ret;
 
 	bgc->data = bgc->read_reg(bgc->reg_dat);
+	bgc->dir = bgc->read_reg(bgc->reg_dir);
 
 	return ret;
 }
-- 
1.5.6.5

