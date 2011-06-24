Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756949Ab1FXO0p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jun 2011 10:26:45 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:39425 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753859Ab1FXO0o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jun 2011 10:26:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=vRJC4qMYCf3yjk3XYB7nEqdZCEJ6Vj2SXMXpxWTj5X6nRs9zi9X3E9Odkny2zwKxe5
         DSN8ERrBmz/bk20rofINYCr7PJidze56hd61rGfJJ3dTgVrme8XVOKNu6t1hru7CVeXG
         jutsG5KneOEmvXB8T4o1NC1wFg/9Qf60BJ6SA=
Subject: [PATCH] power_supply: max8903_charger: add "platform:" prefix for
 platform modalias
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Anton Vorontsov <cbouatmailru@gmail.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 24 Jun 2011 22:26:36 +0800
Message-ID: <1308925596.2628.1.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since 43cc71eed1250755986da4c0f9898f9a635cb3bf (platform: prefix MODALIAS
with "platform:"), the platform modalias is prefixed with "platform:".

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/power/max8903_charger.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/power/max8903_charger.c b/drivers/power/max8903_charger.c
index 33ff0e3..a3c97ea 100644
--- a/drivers/power/max8903_charger.c
+++ b/drivers/power/max8903_charger.c
@@ -388,4 +388,4 @@ module_exit(max8903_exit);
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("MAX8903 Charger Driver");
 MODULE_AUTHOR("MyungJoo Ham <myungjoo.ham@samsung.com>");
-MODULE_ALIAS("max8903-charger");
+MODULE_ALIAS("platform:max8903-charger");
-- 
1.7.4.1



