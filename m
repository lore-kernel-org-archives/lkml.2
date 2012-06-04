Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756196Ab2FDSqD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 14:46:03 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:34919 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752503Ab2FDSp7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 14:45:59 -0400
From: Giuseppe Bilotta <giuseppe.bilotta@gmail.com>
To: David Herrmann <dh.herrmann@googlemail.com>
Cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        trivial@kernel.org, Giuseppe Bilotta <giuseppe.bilotta@gmail.com>
Subject: [PATCH][trivial] HID: wiimote-ext: trivial spelling fix
Date: Mon,  4 Jun 2012 20:45:40 +0200
Message-Id: <1338835541-9217-1-git-send-email-giuseppe.bilotta@gmail.com>
X-Mailer: git-send-email 1.7.10.rc3.204.g95589
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Giuseppe Bilotta <giuseppe.bilotta@gmail.com>
---
 drivers/hid/hid-wiimote-ext.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hid/hid-wiimote-ext.c b/drivers/hid/hid-wiimote-ext.c
index aa95870..0a1805c 100644
--- a/drivers/hid/hid-wiimote-ext.c
+++ b/drivers/hid/hid-wiimote-ext.c
@@ -77,7 +77,7 @@ static __u16 wiiext_keymap[] = {
 	BTN_TR,		/* WIIEXT_KEY_RT */
 };
 
-/* diable all extensions */
+/* disable all extensions */
 static void ext_disable(struct wiimote_ext *ext)
 {
 	unsigned long flags;
-- 
1.7.10.rc3.204.g95589

