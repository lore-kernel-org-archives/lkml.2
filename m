Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752755Ab0JPDJT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 23:09:19 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:35312 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752364Ab0JPDJR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 23:09:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=rHbiJTI5fGVnOUb/zetJt2YMeRM3Ufsjm+1OPKxHmI+aSzO0xK//5m48R3LvmKrbfi
         jMaGpwKj3AANmWBdfeszBlqRQEI39XLd0jf4+x1++SZHuV1tpNHl9VjYdvfBF3pGVZX9
         0t71M7cXzCJk7Ri3AlknYVaOzuawzUlWhcP+A=
From: Tracey Dent <tdent48227@gmail.com>
To: greg@kroah.com
Cc: linux-kernel@vger.kernel.org, Tracey Dent <tdent48227@gmail.com>
Subject: [PATCH 1/2] Staging: speakup: main: Coding stlye fixes
Date: Fri, 15 Oct 2010 23:08:46 -0400
Message-Id: <1287198527-1696-1-git-send-email-tdent48227@gmail.com>
X-Mailer: git-send-email 1.7.3.1.104.gc752e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed coding style issues foung by checkpatch.pl

Signed-off-by: Tracey Dent <tdent48227@gmail.com>
---
 drivers/staging/speakup/main.c |   42 ++++++++++++++++++++--------------------
 1 files changed, 21 insertions(+), 21 deletions(-)

diff --git a/drivers/staging/speakup/main.c b/drivers/staging/speakup/main.c
index 2ef3b39..612142d 100644
--- a/drivers/staging/speakup/main.c
+++ b/drivers/staging/speakup/main.c
@@ -155,23 +155,23 @@ char *default_chars[256] = {
 /*138*/ "control", "control", "control", "control", "control", "control", "control", "control", "control", "control", "control", "control",
 /*150*/ "control", "control", "control", "control", "control", "control", "control", "control", "control", "control",
 /*160*/ "nbsp", "inverted bang",
-/*162*/ "cents", "pounds", "currency", "yen", "broken bar", "section", 
-/*168*/ "diaeresis", "copyright", "female ordinal", "double left angle", 
+/*162*/ "cents", "pounds", "currency", "yen", "broken bar", "section",
+/*168*/ "diaeresis", "copyright", "female ordinal", "double left angle",
 /*172*/ "not", "soft hyphen", "registered", "macron",
-/*176*/ "degrees", "plus or minus", "super two", "super three", 
-/*180*/ "acute accent", 	"micro", "pilcrow", "middle dot", 
+/*176*/ "degrees", "plus or minus", "super two", "super three",
+/*180*/ "acute accent",	"micro", "pilcrow", "middle dot",
 /*184*/ "cedilla", "super one", "male ordinal", "double right angle",
 /*188*/ "one quarter", "one half", "three quarters", "inverted question",
 /*192*/ "A GRAVE", "A ACUTE", "A CIRCUMFLEX", "A TILDE", "A OOMLAUT", "A RING",
-/*198*/ "AE", "C CIDELLA", "E GRAVE", "E ACUTE", "E CIRCUMFLEX", "E OOMLAUT", 
+/*198*/ "AE", "C CIDELLA", "E GRAVE", "E ACUTE", "E CIRCUMFLEX", "E OOMLAUT",
 /*204*/ "I GRAVE", "I ACUTE", "I CIRCUMFLEX", "I OOMLAUT", "ETH", "N TILDE",
 /*210*/ "O GRAVE", "O ACUTE", "O CIRCUMFLEX", "O TILDE", "O OOMLAUT",
-/*215*/ "multiplied by", "O STROKE", "U GRAVE", "U ACUTE", "U CIRCUMFLEX", 
+/*215*/ "multiplied by", "O STROKE", "U GRAVE", "U ACUTE", "U CIRCUMFLEX",
 /*220*/ "U OOMLAUT", "Y ACUTE", "THORN", "sharp s", "a grave",
 /*225*/ "a acute", "a circumflex", "a tilde", "a oomlaut", "a ring",
 /*230*/ "ae", "c cidella", "e grave", "e acute",
 /*234*/ "e circumflex", "e oomlaut", "i grave", "i acute", "i circumflex",
-/*239*/ "i oomlaut", "eth", "n tilde","o grave", "o acute", "o circumflex",
+/*239*/ "i oomlaut", "eth", "n tilde", "o grave", "o acute", "o circumflex",
 /*245*/"o tilde", "o oomlaut", "divided by", "o stroke", "u grave", "u acute",
 /* 251 */ "u circumflex", "u oomlaut", "y acute", "thorn", "y oomlaut"
 };
@@ -346,13 +346,13 @@ static void speakup_cut(struct vc_data *vc)
 	switch (ret) {
 	case 0:
 		break; /* no error */
-	case -EFAULT :
+	case -EFAULT:
 		pr_warn("%sEFAULT\n", err_buf);
 		break;
-	case -EINVAL :
+	case -EINVAL:
 		pr_warn("%sEINVAL\n", err_buf);
 		break;
-	case -ENOMEM :
+	case -ENOMEM:
 		pr_warn("%sENOMEM\n", err_buf);
 		break;
 	}
@@ -1190,18 +1190,18 @@ int set_key_info(const u_char *key_info, u_char *k_buffer)
 
 static struct var_t spk_vars[] = {
 	/* bell must be first to set high limit */
-	{ BELL_POS, .u.n = {NULL, 0, 0, 0, 0, 0, NULL }},
-	{ SPELL_DELAY, .u.n = {NULL, 0, 0, 4, 0, 0, NULL }},
-	{ ATTRIB_BLEEP, .u.n = {NULL, 1, 0, 3, 0, 0, NULL }},
-	{ BLEEPS, .u.n = {NULL, 3, 0, 3, 0, 0, NULL }},
-	{ BLEEP_TIME, .u.n = {NULL, 30, 1, 200, 0, 0, NULL }},
-	{ PUNC_LEVEL, .u.n = {NULL, 1, 0, 4, 0, 0, NULL }},
-	{ READING_PUNC, .u.n = {NULL, 1, 0, 4, 0, 0, NULL }},
-	{ CURSOR_TIME, .u.n = {NULL, 120, 50, 600, 0, 0, NULL }},
+	{ BELL_POS, .u.n = {NULL, 0, 0, 0, 0, 0, NULL } },
+	{ SPELL_DELAY, .u.n = {NULL, 0, 0, 4, 0, 0, NULL } },
+	{ ATTRIB_BLEEP, .u.n = {NULL, 1, 0, 3, 0, 0, NULL } },
+	{ BLEEPS, .u.n = {NULL, 3, 0, 3, 0, 0, NULL } },
+	{ BLEEP_TIME, .u.n = {NULL, 30, 1, 200, 0, 0, NULL } },
+	{ PUNC_LEVEL, .u.n = {NULL, 1, 0, 4, 0, 0, NULL } },
+	{ READING_PUNC, .u.n = {NULL, 1, 0, 4, 0, 0, NULL } },
+	{ CURSOR_TIME, .u.n = {NULL, 120, 50, 600, 0, 0, NULL } },
 	{ SAY_CONTROL, TOGGLE_0 },
 	{ SAY_WORD_CTL, TOGGLE_0 },
 	{ NO_INTERRUPT, TOGGLE_0 },
-	{ KEY_ECHO, .u.n = {NULL, 1, 0, 2, 0, 0, NULL }},
+	{ KEY_ECHO, .u.n = {NULL, 1, 0, 2, 0, 0, NULL } },
 	V_LAST_VAR
 };
 
@@ -2267,7 +2267,7 @@ static int __init speakup_init(void)
 
 	strlwr(synth_name);
 	spk_vars[0].u.n.high = vc->vc_cols;
-	for (var = spk_vars; var->var_id !=MAXVARS; var++) 
+	for (var = spk_vars; var->var_id != MAXVARS; var++) 
 		speakup_register_var(var);
 	for (var = synth_time_vars; (var->var_id >= 0) && (var->var_id < MAXVARS); var++)
 		speakup_register_var(var);
@@ -2291,7 +2291,7 @@ static int __init speakup_init(void)
 
 	speakup_task = kthread_create(speakup_thread, NULL, "speakup");
 	set_user_nice(speakup_task, 10);
-	if ( ! IS_ERR(speakup_task))
+	if (!IS_ERR(speakup_task))
 		wake_up_process(speakup_task);
 	else
 		return -ENOMEM;
-- 
1.7.3.1.104.gc752e

