Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759922Ab2IGEgb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 00:36:31 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:57482 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752664Ab2IGEg3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 00:36:29 -0400
From: Toshiaki Yamane <yamanetoshi@gmail.com>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, Toshiaki Yamane <yamanetoshi@gmail.com>
Subject: [PATCH 44/57] staging/rts_pstor: remove braces {} in sd.c (wait_data_buf_ready)
Date: Fri,  7 Sep 2012 13:36:24 +0900
Message-Id: <1346992584-17802-1-git-send-email-yamanetoshi@gmail.com>
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
 drivers/staging/rts_pstor/sd.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/staging/rts_pstor/sd.c b/drivers/staging/rts_pstor/sd.c
index f109bbc..918caf5 100644
--- a/drivers/staging/rts_pstor/sd.c
+++ b/drivers/staging/rts_pstor/sd.c
@@ -3106,9 +3106,8 @@ static int wait_data_buf_ready(struct rtsx_chip *chip)
 
 		retval = sd_send_cmd_get_rsp(chip, SEND_STATUS,
 				sd_card->sd_addr, SD_RSP_TYPE_R1, NULL, 0);
-		if (retval != STATUS_SUCCESS) {
+		if (retval != STATUS_SUCCESS)
 			TRACE_RET(chip, STATUS_FAIL);
-		}
 
 		if (sd_card->sd_data_buf_ready) {
 			return sd_send_cmd_get_rsp(chip, SEND_STATUS,
-- 
1.7.9.5

