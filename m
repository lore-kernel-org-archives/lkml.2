Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751962Ab1BDUaL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Feb 2011 15:30:11 -0500
Received: from miraculix-out.informatik.uni-kiel.de ([134.245.248.209]:57464
	"EHLO miraculix.informatik.uni-kiel.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751212Ab1BDUaJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Feb 2011 15:30:09 -0500
From: Timo von Holtz <tvh@informatik.uni-kiel.de>
To: gregkh@suse.de
Cc: w.d.hubbs@gmail.com, tvh@informatik.uni-kiel.de,
        samuel.thibault@ens-lyon.org, tdent48227@gmail.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] staging: speakup: enlosed macros with complex values in parenthesis
Date: Fri,  4 Feb 2011 21:29:46 +0100
Message-Id: <1296851386-17342-1-git-send-email-tvh@informatik.uni-kiel.de>
X-Mailer: git-send-email 1.7.4
X-Null-Tag: 4d8395c5899596173175a1fe9037aaa7
X-Authenticated-Sender: user tvh from 86.103.152.235
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enclosed all macros with complex values in parenthesis

Signed-off-by: Timo von Holtz <tvh@informatik.uni-kiel.de>
---
 drivers/staging/speakup/spk_priv_keyinfo.h |   44 ++++++++++++++--------------
 drivers/staging/speakup/spk_types.h        |   18 ++++++------
 2 files changed, 31 insertions(+), 31 deletions(-)

diff --git a/drivers/staging/speakup/spk_priv_keyinfo.h b/drivers/staging/speakup/spk_priv_keyinfo.h
index 3fd4b82..95c473a 100644
--- a/drivers/staging/speakup/spk_priv_keyinfo.h
+++ b/drivers/staging/speakup/spk_priv_keyinfo.h
@@ -84,27 +84,27 @@
 
 /* keys for setting variables, must be ordered same as the enum for var_ids */
 /* with dec being even and inc being 1 greater */
-#define SPELL_DELAY_DEC VAR_START+0
-#define SPELL_DELAY_INC SPELL_DELAY_DEC+1
-#define PUNC_LEVEL_DEC SPELL_DELAY_DEC+2
-#define PUNC_LEVEL_INC PUNC_LEVEL_DEC+1
-#define READING_PUNC_DEC PUNC_LEVEL_DEC+2
-#define READING_PUNC_INC READING_PUNC_DEC+1
-#define ATTRIB_BLEEP_DEC READING_PUNC_DEC+2
-#define ATTRIB_BLEEP_INC ATTRIB_BLEEP_DEC+1
-#define BLEEPS_DEC ATTRIB_BLEEP_DEC+2
-#define BLEEPS_INC BLEEPS_DEC+1
-#define RATE_DEC BLEEPS_DEC+2
-#define RATE_INC RATE_DEC+1
-#define PITCH_DEC RATE_DEC+2
-#define PITCH_INC PITCH_DEC+1
-#define VOL_DEC PITCH_DEC+2
-#define VOL_INC VOL_DEC+1
-#define TONE_DEC VOL_DEC+2
-#define TONE_INC TONE_DEC+1
-#define PUNCT_DEC TONE_DEC+2
-#define PUNCT_INC PUNCT_DEC+1
-#define VOICE_DEC PUNCT_DEC+2
-#define VOICE_INC VOICE_DEC+1
+#define SPELL_DELAY_DEC (VAR_START+0)
+#define SPELL_DELAY_INC (SPELL_DELAY_DEC+1)
+#define PUNC_LEVEL_DEC (SPELL_DELAY_DEC+2)
+#define PUNC_LEVEL_INC (PUNC_LEVEL_DEC+1)
+#define READING_PUNC_DEC (PUNC_LEVEL_DEC+2)
+#define READING_PUNC_INC (READING_PUNC_DEC+1)
+#define ATTRIB_BLEEP_DEC (READING_PUNC_DEC+2)
+#define ATTRIB_BLEEP_INC (ATTRIB_BLEEP_DEC+1)
+#define BLEEPS_DEC (ATTRIB_BLEEP_DEC+2)
+#define BLEEPS_INC (BLEEPS_DEC+1)
+#define RATE_DEC (BLEEPS_DEC+2)
+#define RATE_INC (RATE_DEC+1)
+#define PITCH_DEC (RATE_DEC+2)
+#define PITCH_INC (PITCH_DEC+1)
+#define VOL_DEC (PITCH_DEC+2)
+#define VOL_INC (VOL_DEC+1)
+#define TONE_DEC (VOL_DEC+2)
+#define TONE_INC (TONE_DEC+1)
+#define PUNCT_DEC (TONE_DEC+2)
+#define PUNCT_INC (PUNCT_DEC+1)
+#define VOICE_DEC (PUNCT_DEC+2)
+#define VOICE_INC (VOICE_DEC+1)
 
 #endif
diff --git a/drivers/staging/speakup/spk_types.h b/drivers/staging/speakup/spk_types.h
index d36c90e..3ac552c 100644
--- a/drivers/staging/speakup/spk_types.h
+++ b/drivers/staging/speakup/spk_types.h
@@ -79,14 +79,14 @@ struct st_spk_t {
 };
 
 /* now some defines to make these easier to use. */
-#define spk_shut_up speakup_console[vc->vc_num]->shut_up
+#define spk_shut_up (speakup_console[vc->vc_num]->shut_up)
 #define spk_killed (speakup_console[vc->vc_num]->shut_up & 0x40)
-#define spk_x speakup_console[vc->vc_num]->reading_x
-#define spk_cx speakup_console[vc->vc_num]->cursor_x
-#define spk_y speakup_console[vc->vc_num]->reading_y
-#define spk_cy speakup_console[vc->vc_num]->cursor_y
+#define spk_x (speakup_console[vc->vc_num]->reading_x)
+#define spk_cx (speakup_console[vc->vc_num]->cursor_x)
+#define spk_y (speakup_console[vc->vc_num]->reading_y)
+#define spk_cy (speakup_console[vc->vc_num]->cursor_y)
 #define spk_pos (speakup_console[vc->vc_num]->reading_pos)
-#define spk_cp speakup_console[vc->vc_num]->cursor_pos
+#define spk_cp (speakup_console[vc->vc_num]->cursor_pos)
 #define goto_pos (speakup_console[vc->vc_num]->go_pos)
 #define goto_x (speakup_console[vc->vc_num]->go_x)
 #define win_top (speakup_console[vc->vc_num]->w_top)
@@ -95,9 +95,9 @@ struct st_spk_t {
 #define win_right (speakup_console[vc->vc_num]->w_right)
 #define win_start (speakup_console[vc->vc_num]->w_start)
 #define win_enabled (speakup_console[vc->vc_num]->w_enabled)
-#define spk_attr speakup_console[vc->vc_num]->reading_attr
-#define spk_old_attr speakup_console[vc->vc_num]->old_attr
-#define spk_parked speakup_console[vc->vc_num]->parked
+#define spk_attr (speakup_console[vc->vc_num]->reading_attr)
+#define spk_old_attr (speakup_console[vc->vc_num]->old_attr)
+#define spk_parked (speakup_console[vc->vc_num]->parked)
 
 struct st_var_header {
 	char *name;
-- 
1.7.4

