Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753551Ab2IGE2f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 00:28:35 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:46003 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752463Ab2IGE2d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 00:28:33 -0400
From: Toshiaki Yamane <yamanetoshi@gmail.com>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, Toshiaki Yamane <yamanetoshi@gmail.com>
Subject: [PATCH 17/57] staging/rts_pstor: remove braces {} in sd.c (downgrade_switch_mode)
Date: Fri,  7 Sep 2012 13:28:28 +0900
Message-Id: <1346992108-16931-1-git-send-email-yamanetoshi@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1346991387-16321-1-git-send-email-yamanetoshi@gmail.com>
References: <1346991387-16321-1-git-send-email-yamanetoshi@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fixed below checkpatch warnings.
-WARNING: braces {} are not necessary for single statement blocks

Signed-off-by: Toshiaki Yamane <yamanetoshi@gmail.com>
---
 drivers/staging/rts_pstor/sd.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/rts_pstor/sd.c b/drivers/staging/rts_pstor/sd.c
index 2b7a4e1..36b7f49 100644
--- a/drivers/staging/rts_pstor/sd.c
+++ b/drivers/staging/rts_pstor/sd.c
@@ -1160,13 +1160,12 @@ static int sd_check_switch_mode(struct rtsx_chip *chip, u8 mode,
 static u8 downgrade_switch_mode(u8 func_group, u8 func_to_switch)
 {
 	if (func_group == SD_FUNC_GROUP_1) {
-		if (func_to_switch > HS_SUPPORT) {
+		if (func_to_switch > HS_SUPPORT)
 			func_to_switch--;
-		}
+
 	} else if (func_group == SD_FUNC_GROUP_4) {
-		if (func_to_switch > CURRENT_LIMIT_200) {
+		if (func_to_switch > CURRENT_LIMIT_200)
 			func_to_switch--;
-		}
 	}
 
 	return func_to_switch;
-- 
1.7.9.5

