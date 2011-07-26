Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752615Ab1GZOR0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 10:17:26 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:45047 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752032Ab1GZORV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 10:17:21 -0400
Subject: [PATCH] backlight: fix module alias prefix for adp8870_bl
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Michael Hennerich <michael.hennerich@analog.com>,
        Richard Purdie <rpurdie@rpsys.net>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 26 Jul 2011 22:17:09 +0800
Message-ID: <1311689829.4014.1.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a i2c driver, not a platform driver,
thus use "i2c" prefix for the module alias.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/video/backlight/adp8870_bl.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/video/backlight/adp8870_bl.c b/drivers/video/backlight/adp8870_bl.c
index 383c4c3..98e0304 100644
--- a/drivers/video/backlight/adp8870_bl.c
+++ b/drivers/video/backlight/adp8870_bl.c
@@ -1008,4 +1008,4 @@ module_exit(adp8870_exit);
 MODULE_LICENSE("GPL v2");
 MODULE_AUTHOR("Michael Hennerich <hennerich@blackfin.uclinux.org>");
 MODULE_DESCRIPTION("ADP8870 Backlight driver");
-MODULE_ALIAS("platform:adp8870-backlight");
+MODULE_ALIAS("i2c:adp8870-backlight");
-- 
1.7.4.1



