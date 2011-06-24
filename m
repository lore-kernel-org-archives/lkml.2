Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757896Ab1FXOaP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jun 2011 10:30:15 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:56032 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754091Ab1FXOaL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jun 2011 10:30:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=jdXjjtshjRpToRKH9OD1kf539fZGiISL+ew7RsSrmVU80Luzx/4ZxsFO8nDXDUim4w
         9PPqPS+djgPzqQ3eDtW/GUCSB2AS1fSlbulfjUIgVEWjuvFT4gUgvmptZdR+L74mrHYi
         utwrucb1XShNhugjvRrfQfIjVdVwDjSyX2G6U=
Subject: [PATCH] gpio: ab8500: fix MODULE_ALIAS for ab8500
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: BIBEK BASU <bibek.basu@stericsson.com>,
        Grant Likely <grant.likely@secretlab.ca>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 24 Jun 2011 22:30:06 +0800
Message-ID: <1308925806.2628.3.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since 43cc71eed1250755986da4c0f9898f9a635cb3bf (platform: prefix MODALIAS
with "platform:"), the platform modalias is prefixed with "platform:".

This patch changes the MODULE_ALIAS to "platform:ab8500-gpio".

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/gpio/gpio-ab8500.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/gpio/gpio-ab8500.c b/drivers/gpio/gpio-ab8500.c
index ed795e6..050c05d 100644
--- a/drivers/gpio/gpio-ab8500.c
+++ b/drivers/gpio/gpio-ab8500.c
@@ -516,5 +516,5 @@ module_exit(ab8500_gpio_exit);
 
 MODULE_AUTHOR("BIBEK BASU <bibek.basu@stericsson.com>");
 MODULE_DESCRIPTION("Driver allows to use AB8500 unused pins to be used as GPIO");
-MODULE_ALIAS("AB8500 GPIO driver");
+MODULE_ALIAS("platform:ab8500-gpio");
 MODULE_LICENSE("GPL v2");
-- 
1.7.4.1



