Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758389Ab2HUUlg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 16:41:36 -0400
Received: from juliette.telenet-ops.be ([195.130.137.74]:47849 "EHLO
	juliette.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756311Ab2HUUle (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 16:41:34 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: =?UTF-8?q?Bruno=20Pr=C3=A9mont?= <bonbons@linux-vserver.org>,
        Jiri Kosina <jkosina@suse.cz>
Cc: linux-input@vger.kernel.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-fbdev@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH -next] HID: picoLCD: Add missing #include <linux/uaccess.h>
Date: Tue, 21 Aug 2012 22:41:23 +0200
Message-Id: <1345581683-2099-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

m68k/allmodconfig:

drivers/hid/hid-picolcd_debugfs.c: In function ‘picolcd_debug_reset_write’:
drivers/hid/hid-picolcd_debugfs.c:54: error: implicit declaration of function ‘copy_from_user’
drivers/hid/hid-picolcd_debugfs.c: In function ‘picolcd_debug_eeprom_read’:
drivers/hid/hid-picolcd_debugfs.c:112: error: implicit declaration of function ‘copy_to_user’

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
http://kisskb.ellerman.id.au/kisskb/buildresult/6990818/

 drivers/hid/hid-picolcd_debugfs.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/hid/hid-picolcd_debugfs.c b/drivers/hid/hid-picolcd_debugfs.c
index f2491fa..15c22f2 100644
--- a/drivers/hid/hid-picolcd_debugfs.c
+++ b/drivers/hid/hid-picolcd_debugfs.c
@@ -27,6 +27,7 @@
 #include <linux/debugfs.h>
 
 #include <linux/module.h>
+#include <linux/uaccess.h>
 
 #include "hid-picolcd.h"
 
-- 
1.7.0.4

