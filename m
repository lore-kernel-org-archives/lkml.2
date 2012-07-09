Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754200Ab2GIOaj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 10:30:39 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:53018 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753705Ab2GIOah (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 10:30:37 -0400
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: w.d.hubbs@gmail.com
Cc: chris@the-brannons.com, gregkh@linuxfoundation.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH NEXT]staging "speakup" Fix typos.
Date: Mon,  9 Jul 2012 07:30:27 -0700
Message-Id: <1341844227-28455-1-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Justin P. Mattock" <justinmattock@gmail.com>

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---

The below patch fixes typos found while reading through staging "speakup".

 drivers/staging/speakup/i18n.c          |    2 +-
 drivers/staging/speakup/speakup_acnt.h  |    2 +-
 drivers/staging/speakup/speakup_decpc.c |    2 +-
 drivers/staging/speakup/synth.c         |    2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/speakup/i18n.c b/drivers/staging/speakup/i18n.c
index c211943..ca01734 100644
--- a/drivers/staging/speakup/i18n.c
+++ b/drivers/staging/speakup/i18n.c
@@ -71,7 +71,7 @@ static char *speakup_default_msgs[MSG_LAST_INDEX] = {
 	[MSG_CTL_SHIFT] = "shift",
 	[MSG_CTL_ALTGR] = "altgr",
 	[MSG_CTL_CONTROL] = "control",
-	[MSG_CTL_ALT] = "ault",
+	[MSG_CTL_ALT] = "alt",
 	[MSG_CTL_LSHIFT] = "l shift",
 	[MSG_CTL_SPEAKUP] = "speakup",
 	[MSG_CTL_LCONTROL] = "l control",
diff --git a/drivers/staging/speakup/speakup_acnt.h b/drivers/staging/speakup/speakup_acnt.h
index 2d88365..6376fca 100644
--- a/drivers/staging/speakup/speakup_acnt.h
+++ b/drivers/staging/speakup/speakup_acnt.h
@@ -12,5 +12,5 @@
 				   to accept a byte of data. */
 #define SYNTH_QUIET	'S' /* synth is not speaking */
 #define SYNTH_FULL	'F' /* synth is full. */
-#define SYNTH_ALMOST_EMPTY 'M' /* synth has les than 2 seconds of text left */
+#define SYNTH_ALMOST_EMPTY 'M' /* synth has less than 2 seconds of text left */
 #define SYNTH_SPEAKING	's' /* synth is speaking and has a fare way to go */
diff --git a/drivers/staging/speakup/speakup_decpc.c b/drivers/staging/speakup/speakup_decpc.c
index de25527..a09a0c9 100644
--- a/drivers/staging/speakup/speakup_decpc.c
+++ b/drivers/staging/speakup/speakup_decpc.c
@@ -66,7 +66,7 @@
 #define	CMD_null		0x0000	/* post status */
 #define	CMD_control		0x1000	/* hard control command */
 #define	CTRL_mask		0x0F00	/*   mask off control nibble */
-#define	CTRL_data		0x00FF	/*   madk to get data byte */
+#define	CTRL_data		0x00FF	/*   mask to get data byte */
 #define	CTRL_null		0x0000	/*   null control */
 #define	CTRL_vol_up		0x0100	/*   increase volume */
 #define	CTRL_vol_down		0x0200	/*   decrease volume */
diff --git a/drivers/staging/speakup/synth.c b/drivers/staging/speakup/synth.c
index 331eae7..df95337 100644
--- a/drivers/staging/speakup/synth.c
+++ b/drivers/staging/speakup/synth.c
@@ -64,7 +64,7 @@ EXPORT_SYMBOL_GPL(serial_synth_probe);
 /* Main loop of the progression thread: keep eating from the buffer
  * and push to the serial port, waiting as needed
  *
- * For devices that have a "full" notification mecanism, the driver can
+ * For devices that have a "full" notification mechanism, the driver can
  * adapt the loop the way they prefer.
  */
 void spk_do_catch_up(struct spk_synth *synth)
-- 
1.7.5.4

