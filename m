Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752051Ab2GGGDN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jul 2012 02:03:13 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:35696 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751523Ab2GGGDL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jul 2012 02:03:11 -0400
From: Devendra Naga <devendra.aaru@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        wwang <wei_wang@realsil.com.cn>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Cc: Devendra Naga <devendra.aaru@gmail.com>
Subject: [PATCH 2/2] staging/rts_pstor: fix single statements block warning
Date: Sat,  7 Jul 2012 11:33:04 +0530
Message-Id: <1341640984-25208-1-git-send-email-devendra.aaru@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following warning is fixed up.
drivers/staging/rts_pstor/sd.c:190: WARNING: braces {} are not necessary for single statement blocks

Signed-off-by: Devendra Naga <devendra.aaru@gmail.com>
---
 drivers/staging/rts_pstor/sd.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/rts_pstor/sd.c b/drivers/staging/rts_pstor/sd.c
index ff9bf0f..3cc9a48 100644
--- a/drivers/staging/rts_pstor/sd.c
+++ b/drivers/staging/rts_pstor/sd.c
@@ -187,9 +187,9 @@ RTY_SEND_CMD:
 		     SD_TRANSFER_END | SD_STAT_IDLE, SD_TRANSFER_END | SD_STAT_IDLE);
 
 	if (rsp_type == SD_RSP_TYPE_R2) {
-		for (reg_addr = PPBUF_BASE2; reg_addr < PPBUF_BASE2 + 16; reg_addr++) {
+		for (reg_addr = PPBUF_BASE2; reg_addr < PPBUF_BASE2 + 16; reg_addr++)
 			rtsx_add_cmd(chip, READ_REG_CMD, reg_addr, 0, 0);
-		}
+
 		stat_idx = 16;
 	} else if (rsp_type != SD_RSP_TYPE_R0) {
 		for (reg_addr = REG_SD_CMD0; reg_addr <= REG_SD_CMD4; reg_addr++) {
-- 
1.7.9.5

