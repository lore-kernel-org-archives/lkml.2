Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752081Ab2LJUZi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 15:25:38 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:33063 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751402Ab2LJUZh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 15:25:37 -0500
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Florian Fainelli <florian@openwrt.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] Input: matrix-keymap - provide proper module license
Date: Mon, 10 Dec 2012 12:25:32 -0800
Message-Id: <1355171132-14951-1-git-send-email-dmitry.torokhov@gmail.com>
X-Mailer: git-send-email 1.7.11.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Florian Fainelli <florian@openwrt.org>

The matrix-keymap module is currently lacking a proper module license,
add one so we don't have this module tainting the entire kernel. This
issue has been present since commit 1932811f (Input: matrix-keymap -
uninline and prepare for device tree support)

Signed-off-by: Florian Fainelli <florian@openwrt.org>
CC: stable@vger.kernel.org
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
---

Hi Linus,

Please apply before 3.8 final if possible. Sending directly as my normal
branch has some extra stuff in it...

Thanks,
Dmitry


 drivers/input/matrix-keymap.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/input/matrix-keymap.c b/drivers/input/matrix-keymap.c
index 443ad64b..d88d9be 100644
--- a/drivers/input/matrix-keymap.c
+++ b/drivers/input/matrix-keymap.c
@@ -23,6 +23,7 @@
 #include <linux/input.h>
 #include <linux/of.h>
 #include <linux/export.h>
+#include <linux/module.h>
 #include <linux/input/matrix_keypad.h>
 
 static bool matrix_keypad_map_key(struct input_dev *input_dev,
@@ -161,3 +162,5 @@ int matrix_keypad_build_keymap(const struct matrix_keymap_data *keymap_data,
 	return 0;
 }
 EXPORT_SYMBOL(matrix_keypad_build_keymap);
+
+MODULE_LICENSE("GPL");
-- 
1.7.11.7

