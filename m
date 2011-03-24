Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933992Ab1CXT15 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 15:27:57 -0400
Received: from mail-px0-f179.google.com ([209.85.212.179]:63376 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933988Ab1CXT1n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 15:27:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=xMiQyDQ2FoPjzKhya3kdzqZCt5VALLZa2XbXukY7pCQcZcK11XqrWixW20uJa6FWiw
         uaJIe/mUW7C+Kqy+UDUIL9r+pjWtf/A7+bmPb+4Ma6ajne+ik59FfL2tE2kNsLG9OhP3
         b9hAqz0vUOBrLmImDhb4q6tiGcE4lQKxvs4sA=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [RFC 10/21]drivers:gpio:langwell_gpio.c Remove extra comma.
Date: Thu, 24 Mar 2011 12:26:48 -0700
Message-Id: <1300994819-30930-10-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1300994819-30930-1-git-send-email-justinmattock@gmail.com>
References: <1300994819-30930-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch below removes an extra comma from various parts 
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

