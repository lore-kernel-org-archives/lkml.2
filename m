Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945922Ab2LNXSk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 18:18:40 -0500
Received: from mail.kernel.org ([198.145.19.201]:40488 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932691Ab2LNXCV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 18:02:21 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Florian Fainelli <florian@openwrt.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [ 07/37] Input: matrix-keymap - provide proper module license
Date: Fri, 14 Dec 2012 15:00:44 -0800
Message-Id: <20121214222254.526877609@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20121214222252.781413287@linuxfoundation.org>
References: <20121214222252.781413287@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/input/matrix-keymap.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/input/matrix-keymap.c
+++ b/drivers/input/matrix-keymap.c
@@ -23,6 +23,7 @@
 #include <linux/input.h>
 #include <linux/of.h>
 #include <linux/export.h>
+#include <linux/module.h>
 #include <linux/input/matrix_keypad.h>
 
 static bool matrix_keypad_map_key(struct input_dev *input_dev,
@@ -161,3 +162,5 @@ int matrix_keypad_build_keymap(const str
 	return 0;
 }
 EXPORT_SYMBOL(matrix_keypad_build_keymap);
+
+MODULE_LICENSE("GPL");


