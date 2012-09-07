Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753330Ab2IGE2A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 00:28:00 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:48494 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752604Ab2IGE17 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 00:27:59 -0400
From: Toshiaki Yamane <yamanetoshi@gmail.com>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, Toshiaki Yamane <yamanetoshi@gmail.com>
Subject: [PATCH 15/57] staging/rts_pstor: remove braces {} in sd.c (sd_check_spec)
Date: Fri,  7 Sep 2012 13:27:54 +0900
Message-Id: <1346992074-16865-1-git-send-email-yamanetoshi@gmail.com>
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
 drivers/staging/rts_pstor/sd.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/rts_pstor/sd.c b/drivers/staging/rts_pstor/sd.c
index 67420f4..aae9c72 100644
--- a/drivers/staging/rts_pstor/sd.c
+++ b/drivers/staging/rts_pstor/sd.c
@@ -949,9 +949,8 @@ static int sd_check_spec(struct rtsx_chip *chip, u8 bus_width)
 	u8 cmd[5], buf[8];
 
 	retval = sd_send_cmd_get_rsp(chip, APP_CMD, sd_card->sd_addr, SD_RSP_TYPE_R1, NULL, 0);
-	if (retval != STATUS_SUCCESS) {
+	if (retval != STATUS_SUCCESS)
 		TRACE_RET(chip, STATUS_FAIL);
-	}
 
 	cmd[0] = 0x40 | SEND_SCR;
 	cmd[1] = 0;
@@ -967,9 +966,8 @@ static int sd_check_spec(struct rtsx_chip *chip, u8 bus_width)
 
 	memcpy(sd_card->raw_scr, buf, 8);
 
-	if ((buf[0] & 0x0F) == 0) {
+	if ((buf[0] & 0x0F) == 0)
 		TRACE_RET(chip, STATUS_FAIL);
-	}
 
 	return STATUS_SUCCESS;
 }
-- 
1.7.9.5

