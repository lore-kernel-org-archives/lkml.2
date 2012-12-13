Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933600Ab2LMOPq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 09:15:46 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:45202 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933583Ab2LMOPl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 09:15:41 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Florian Fainelli <florian@openwrt.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 241/241] Input: matrix-keymap - provide proper module license
Date: Thu, 13 Dec 2012 12:00:06 -0200
Message-Id: <1355407206-17100-242-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
References: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Florian Fainelli <florian@openwrt.org>

commit 55220bb3e5f917dd5fee1153c612f9a83599f639 upstream.

The matrix-keymap module is currently lacking a proper module license,
add one so we don't have this module tainting the entire kernel.  This
issue has been present since commit 1932811f426f ("Input: matrix-keymap
- uninline and prepare for device tree support")

Signed-off-by: Florian Fainelli <florian@openwrt.org>
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/input/matrix-keymap.c |    3 +++
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
1.7.9.5

