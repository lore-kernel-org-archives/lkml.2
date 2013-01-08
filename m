Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757079Ab3AHSkD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 13:40:03 -0500
Received: from mail-pb0-f50.google.com ([209.85.160.50]:34736 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757058Ab3AHSkA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 13:40:00 -0500
From: Lijo Antony <lijo.kernel@gmail.com>
To: gregkh@linuxfoundation.org
Cc: w.d.hubbs@gmail.com, chris@the-brannons.com, kirk@braille.uwo.ca,
        samuel.thibault@ens-lyon.org, linux-kernel@vger.kernel.org,
        Lijo Antony <lijo.kernel@gmail.com>
Subject: [PATCH 2/3] Staging: speakup: keyhelp.c: checkpatch.pl fixes
Date: Tue,  8 Jan 2013 22:39:02 +0400
Message-Id: <1357670343-15021-2-git-send-email-lijo.kernel@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1357670343-15021-1-git-send-email-lijo.kernel@gmail.com>
References: <1357670343-15021-1-git-send-email-lijo.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Breaking 2 lines to fit 80 char limit

Signed-off-by: Lijo Antony <lijo.kernel@gmail.com>
---
 drivers/staging/speakup/keyhelp.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/speakup/keyhelp.c b/drivers/staging/speakup/keyhelp.c
index 4c584ec..5091625 100644
--- a/drivers/staging/speakup/keyhelp.c
+++ b/drivers/staging/speakup/keyhelp.c
@@ -118,7 +118,8 @@ static void say_key(int key)
 			synth_printf(" %s", spk_msg_get(MSG_STATES_START + i));
 	}
 	if ((key > 0) && (key <= num_key_names))
-		synth_printf(" %s\n", spk_msg_get(MSG_KEYNAMES_START + (key - 1)));
+		synth_printf(" %s\n",
+				spk_msg_get(MSG_KEYNAMES_START + (key - 1)));
 }
 
 static int help_init(void)
@@ -169,7 +170,9 @@ int spk_handle_help(struct vc_data *vc, u_char type, u_char ch, u_short key)
 			cur_item--;
 		else
 			return -1;
-	} else if (type == KT_SPKUP && ch == SPEAKUP_HELP && !spk_special_handler) {
+	} else if (type == KT_SPKUP
+			&& ch == SPEAKUP_HELP
+			&& !spk_special_handler) {
 		spk_special_handler = spk_handle_help;
 		synth_printf("%s\n", spk_msg_get(MSG_HELP_INFO));
 		build_key_data(); /* rebuild each time in case new mapping */
-- 
1.7.10.4

