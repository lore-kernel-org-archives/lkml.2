Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759640Ab2IGEiY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 00:38:24 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:43598 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752537Ab2IGEiU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 00:38:20 -0400
From: Toshiaki Yamane <yamanetoshi@gmail.com>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, Toshiaki Yamane <yamanetoshi@gmail.com>
Subject: [PATCH 51/57] staging/rts_pstor: remove braces {} in sd.c (get_rsp_type)
Date: Fri,  7 Sep 2012 13:38:15 +0900
Message-Id: <1346992695-18031-1-git-send-email-yamanetoshi@gmail.com>
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
index b352f20..23090cb 100644
--- a/drivers/staging/rts_pstor/sd.c
+++ b/drivers/staging/rts_pstor/sd.c
@@ -3706,9 +3706,8 @@ int sd_pass_thru_mode(struct scsi_cmnd *srb, struct rtsx_chip *chip)
 
 static inline int get_rsp_type(struct scsi_cmnd *srb, u8 *rsp_type, int *rsp_len)
 {
-	if (!rsp_type || !rsp_len) {
+	if (!rsp_type || !rsp_len)
 		return STATUS_FAIL;
-	}
 
 	switch (srb->cmnd[10]) {
 	case 0x03:
-- 
1.7.9.5

