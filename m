Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934248Ab1CXUWB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 16:22:01 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:49015 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757204Ab1CXUTK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 16:19:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=l60mvDaf06ZIdoxKlRERN2Ek8pS+hirTnMsVzYiZYjbgpRGVWeXsiQcaALhyyhJLST
         lSmMbPE5U3oojMKr6VPXCUkOsngSTB5EYi9TFzmX+Z1gO955op+fkTNbqmlBqLSYSS4H
         XBC6qxRDbrHMBAdqTCdTJLhqZz5P9nFs7KjfE=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [RFC V2 10/21]drivers:gpio:langwell_gpio.c Remove extra semi-colon.
Date: Thu, 24 Mar 2011 13:18:29 -0700
Message-Id: <1300997920-31573-10-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1300997920-31573-1-git-send-email-justinmattock@gmail.com>
References: <1300997920-31573-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch below removes an extra semi-colon from various parts 
of the kernel. Please have a look when you have time, and let
me know if its legit or not.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 drivers/gpio/langwell_gpio.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/gpio/langwell_gpio.c b/drivers/gpio/langwell_gpio.c
index 560ab64..1b06f67 100644
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
1.7.4.1

