Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760694Ab2BNOLf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 09:11:35 -0500
Received: from i118-21-156-233.s30.a048.ap.plala.or.jp ([118.21.156.233]:51152
	"EHLO rinabert.homeip.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1760162Ab2BNOLc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 09:11:32 -0500
From: Masanari Iida <standby24x7@gmail.com>
To: mchehab@infradead.org, linux-media@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, trivial@kernel.org, standby24x7@gmail.com
Subject: [PATCH] [trivial] media: Fix typo in radio-sf16fmr2.c
Date: Tue, 14 Feb 2012 23:06:09 +0900
Message-Id: <1329228369-1731-1-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 1.7.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Correct spelling "contrls" to "controls" in
drivers/media/radio/radio-sf16fmr2.c

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 drivers/media/radio/radio-sf16fmr2.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/radio/radio-sf16fmr2.c b/drivers/media/radio/radio-sf16fmr2.c
index 2dd4859..7ab9afa 100644
--- a/drivers/media/radio/radio-sf16fmr2.c
+++ b/drivers/media/radio/radio-sf16fmr2.c
@@ -172,7 +172,7 @@ static int fmr2_tea_ext_init(struct snd_tea575x *tea)
 		fmr2->volume = v4l2_ctrl_new_std(&tea->ctrl_handler, &fmr2_ctrl_ops, V4L2_CID_AUDIO_VOLUME, 0, 68, 2, 56);
 		fmr2->balance = v4l2_ctrl_new_std(&tea->ctrl_handler, &fmr2_ctrl_ops, V4L2_CID_AUDIO_BALANCE, -68, 68, 2, 0);
 		if (tea->ctrl_handler.error) {
-			printk(KERN_ERR "radio-sf16fmr2: can't initialize contrls\n");
+			printk(KERN_ERR "radio-sf16fmr2: can't initialize controls\n");
 			return tea->ctrl_handler.error;
 		}
 	}
-- 
1.7.6.5

