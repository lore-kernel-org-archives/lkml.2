Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932979Ab0KODOp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Nov 2010 22:14:45 -0500
Received: from mail.perches.com ([173.55.12.10]:1136 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932550Ab0KODFa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Nov 2010 22:05:30 -0500
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 05/44] drivers/gpio: Remove unnecessary semicolons
Date: Sun, 14 Nov 2010 19:04:24 -0800
Message-Id: <a04f2c16a94e214f0a1828c4cea95f815a816853.1289789604.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.1.g432b3.dirty
In-Reply-To: <cover.1289789604.git.joe@perches.com>
References: <cover.1289789604.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/gpio/langwell_gpio.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/gpio/langwell_gpio.c b/drivers/gpio/langwell_gpio.c
index 64db9dc..ed05ecb 100644
--- a/drivers/gpio/langwell_gpio.c
+++ b/drivers/gpio/langwell_gpio.c
@@ -122,7 +122,7 @@ static int lnw_gpio_direction_output(struct gpio_chip *chip,
 	lnw_gpio_set(chip, offset, value);
 	spin_lock_irqsave(&lnw->lock, flags);
 	value = readl(gpdr);
-	value |= BIT(offset % 32);;
+	value |= BIT(offset % 32);
 	writel(value, gpdr);
 	spin_unlock_irqrestore(&lnw->lock, flags);
 	return 0;
-- 
1.7.3.1.g432b3.dirty

