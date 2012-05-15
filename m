Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965708Ab2EOCco (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 22:32:44 -0400
Received: from mail1.windriver.com ([147.11.146.13]:53538 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965457Ab2EOCSE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 22:18:04 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [34-longterm 153/179] ALSA: snd-usb-caiaq: Fix keymap for RigKontrol3
Date: Mon, 14 May 2012 22:14:09 -0400
Message-ID: <1337048075-6132-154-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.6
In-Reply-To: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
References: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Daniel Mack <zonque@gmail.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit f4389489b5cbe60b3441869c68bb4afe760969c4 upstream.

Signed-off-by: Daniel Mack <zonque@gmail.com>
Reported-by: Renato <naretobh@gmail.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 sound/usb/caiaq/input.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/usb/caiaq/input.c b/sound/usb/caiaq/input.c
index a48d309..c93e1aa 100644
--- a/sound/usb/caiaq/input.c
+++ b/sound/usb/caiaq/input.c
@@ -28,7 +28,7 @@ static unsigned short keycode_ak1[] =  { KEY_C, KEY_B, KEY_A };
 static unsigned short keycode_rk2[] =  { KEY_1, KEY_2, KEY_3, KEY_4,
 					 KEY_5, KEY_6, KEY_7 };
 static unsigned short keycode_rk3[] =  { KEY_1, KEY_2, KEY_3, KEY_4,
-					 KEY_5, KEY_6, KEY_7, KEY_5, KEY_6 };
+					 KEY_5, KEY_6, KEY_7, KEY_8, KEY_9 };
 
 static unsigned short keycode_kore[] = {
 	KEY_FN_F1,      /* "menu"               */
-- 
1.7.9.6

