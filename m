Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933886Ab1CXTbW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 15:31:22 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:60296 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933843Ab1CXT12 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 15:27:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=DFed5oC0SKZy0alC5qH0lFdHezx06OYpBBxgjNmcj28qPJ7AVTbXuyyIGYaJNpmGzJ
         7bripX8kutG3djtW4kqhiHCgGxGjrpfhXHj5C2TOxGFTUdBUYoE3I++JXOZe460jaJsz
         VHGHGiC1xN4j+YdMih9kkc8o16Fgb4XlOZv1g=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [RFC 06/21]drivers:leds:leds-mc13783.c Remove extra comma.
Date: Thu, 24 Mar 2011 12:26:44 -0700
Message-Id: <1300994819-30930-6-git-send-email-justinmattock@gmail.com>
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

