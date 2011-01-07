Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755385Ab1AGTs3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 14:48:29 -0500
Received: from mail.df.lth.se ([194.47.250.12]:49499 "EHLO df.lth.se"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753601Ab1AGTs2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 14:48:28 -0500
From: Linus Walleij <linus.walleij@stericsson.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Dan Carpenter <error27@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Linus Walleij <linus.walleij@stericsson.com>
Subject: [PATCH] input/tc3589x: fix compile error
Date: Fri,  7 Jan 2011 20:47:37 +0100
Message-Id: <1294429657-23678-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dan Carpenter <error27@gmail.com>

There was a semi-colon missing and it broke the compile.

Signed-off-by: Dan Carpenter <error27@gmail.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
---
Linus, det är Linus, kan du lägga på den här? Det fattas
ett semikolon, vet inte var det är, jag har förlagt det.
---
 drivers/input/keyboard/tc3589x-keypad.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/input/keyboard/tc3589x-keypad.c b/drivers/input/keyboard/tc3589x-keypad.c
index 69dc0cb..dbbe761 100644
--- a/drivers/input/keyboard/tc3589x-keypad.c
+++ b/drivers/input/keyboard/tc3589x-keypad.c
@@ -469,4 +469,4 @@ module_exit(tc3589x_keypad_exit);
 MODULE_LICENSE("GPL v2");
 MODULE_AUTHOR("Jayeeta Banerjee/Sundar Iyer");
 MODULE_DESCRIPTION("TC35893 Keypad Driver");
-MODULE_ALIAS("platform:tc3589x-keypad")
+MODULE_ALIAS("platform:tc3589x-keypad");
-- 
1.7.3.4

