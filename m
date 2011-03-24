Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934256Ab1CXUXJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 16:23:09 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:36255 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934100Ab1CXUTD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 16:19:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=YkyQg/ORlxuUvK7Qe6ERo97auD8Lf07zRPDeoYLTpaFdCicJuj7K32wvBk8Ru808TU
         tfG16XXuBJxCnSoiDa5iG8Lws1kq/bV+e4oYMGkcDXx51g0p6SyIo789B25K90c3UOHN
         MPyfmm8IQzVueQcB4NSazRlc0TydLn5AaHMFU=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [RFC V2 06/21]drivers:leds:leds-mc13783.c Remove extra semi-colon.
Date: Thu, 24 Mar 2011 13:18:25 -0700
Message-Id: <1300997920-31573-6-git-send-email-justinmattock@gmail.com>
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
 drivers/leds/leds-mc13783.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/leds/leds-mc13783.c b/drivers/leds/leds-mc13783.c
index 06a5bb4..126ca79 100644
--- a/drivers/leds/leds-mc13783.c
+++ b/drivers/leds/leds-mc13783.c
@@ -235,7 +235,7 @@ static int __devinit mc13783_leds_prepare(struct platform_device *pdev)
 							MC13783_LED_Cx_PERIOD;
 
 	if (pdata->flags & MC13783_LED_TRIODE_TC3)
-		reg |= MC13783_LED_Cx_TRIODE_TC_BIT;;
+		reg |= MC13783_LED_Cx_TRIODE_TC_BIT;
 
 	ret = mc13783_reg_write(dev, MC13783_REG_LED_CONTROL_5, reg);
 	if (ret)
-- 
1.7.4.1

