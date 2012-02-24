Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756412Ab2BXMdW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 07:33:22 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:59698 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756043Ab2BXMdU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 07:33:20 -0500
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 2/2] vt: tidy a few bits of checkpatch noise
To: greg@kroah.com, linux-kernel@vger.kernel.org
Date: Fri, 24 Feb 2012 12:47:29 +0000
Message-ID: <20120224124725.32569.50389.stgit@bob.linux.org.uk>
In-Reply-To: <20120224124541.32569.24165.stgit@bob.linux.org.uk>
References: <20120224124541.32569.24165.stgit@bob.linux.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/tty/vt/keyboard.c |   18 +++++++++---------
 1 files changed, 9 insertions(+), 9 deletions(-)


diff --git a/drivers/tty/vt/keyboard.c b/drivers/tty/vt/keyboard.c
index bdf838d..0479114 100644
--- a/drivers/tty/vt/keyboard.c
+++ b/drivers/tty/vt/keyboard.c
@@ -55,8 +55,8 @@ extern void ctrl_alt_del(void);
 /*
  * Some laptops take the 789uiojklm,. keys as number pad when NumLock is on.
  * This seems a good reason to start with NumLock off. On HIL keyboards
- * of PARISC machines however there is no NumLock key and everyone expects the keypad
- * to be used for numbers.
+ * of PARISC machines however there is no NumLock key and everyone expects the
+ * keypad to be used for numbers.
  */
 
 #if defined(CONFIG_PARISC) && (defined(CONFIG_KEYBOARD_HIL) || defined(CONFIG_KEYBOARD_HIL_OLD))
@@ -1404,14 +1404,14 @@ static void kbd_start(struct input_handle *handle)
 
 static const struct input_device_id kbd_ids[] = {
 	{
-                .flags = INPUT_DEVICE_ID_MATCH_EVBIT,
-                .evbit = { BIT_MASK(EV_KEY) },
-        },
+		.flags = INPUT_DEVICE_ID_MATCH_EVBIT,
+		.evbit = { BIT_MASK(EV_KEY) },
+	},
 
 	{
-                .flags = INPUT_DEVICE_ID_MATCH_EVBIT,
-                .evbit = { BIT_MASK(EV_SND) },
-        },
+		.flags = INPUT_DEVICE_ID_MATCH_EVBIT,
+		.evbit = { BIT_MASK(EV_SND) },
+	},
 
 	{ },    /* Terminating entry */
 };
@@ -1433,7 +1433,7 @@ int __init kbd_init(void)
 	int i;
 	int error;
 
-        for (i = 0; i < MAX_NR_CONSOLES; i++) {
+	for (i = 0; i < MAX_NR_CONSOLES; i++) {
 		kbd_table[i].ledflagstate = KBD_DEFLEDS;
 		kbd_table[i].default_ledflagstate = KBD_DEFLEDS;
 		kbd_table[i].ledmode = LED_SHOW_FLAGS;

