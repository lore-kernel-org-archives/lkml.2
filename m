Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758065Ab2EUOT0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 10:19:26 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:38917 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757076Ab2EUOTY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 10:19:24 -0400
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: gregkh@linuxfoundation.org
Cc: wei_wang@realsil.com.cn, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH NEXT]staging: "rts_pstor" Fix typos.
Date: Mon, 21 May 2012 07:19:15 -0700
Message-Id: <1337609955-15544-1-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Justin P. Mattock" <justinmattock@gmail.com>

 Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---

The below patch fixes some typos found while reading through rts_pstor.

 drivers/staging/rts_pstor/ms.c |    2 +-
 drivers/staging/rts_pstor/sd.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/rts_pstor/ms.c b/drivers/staging/rts_pstor/ms.c
index 0bf6d95..3b75739 100644
--- a/drivers/staging/rts_pstor/ms.c
+++ b/drivers/staging/rts_pstor/ms.c
@@ -2488,7 +2488,7 @@ int reset_ms_card(struct rtsx_chip *chip)
 
 	if (!CHK_MSPRO(ms_card)) {
 		/* Build table for the last segment,
-		 * to check if L2P talbe block exist,erasing it
+		 * to check if L2P table block exist,erasing it
 		 */
 		retval = ms_build_l2p_tbl(chip, ms_card->total_block / 512 - 1);
 		if (retval != STATUS_SUCCESS) {
diff --git a/drivers/staging/rts_pstor/sd.c b/drivers/staging/rts_pstor/sd.c
index aab6909..b9474a8 100644
--- a/drivers/staging/rts_pstor/sd.c
+++ b/drivers/staging/rts_pstor/sd.c
@@ -1169,7 +1169,7 @@ static int sd_check_switch_mode(struct rtsx_chip *chip, u8 mode,
 		RTSX_DEBUGP("func_group4_mask = 0x%02x\n", buf[0x07]);
 	} else {
 		/* Maximum current consumption, check whether current is acceptable;
-		 * bit[511:496] = 0x0000 means some error happaned.
+		 * bit[511:496] = 0x0000 means some error happened.
 		 */
 		u16 cc = ((u16)buf[0] << 8) | buf[1];
 		RTSX_DEBUGP("Maximum current consumption: %dmA\n", cc);
-- 
1.7.5.4

