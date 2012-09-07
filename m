Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760117Ab2IGEjS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 00:39:18 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:53272 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753627Ab2IGEjO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 00:39:14 -0400
From: Toshiaki Yamane <yamanetoshi@gmail.com>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, Toshiaki Yamane <yamanetoshi@gmail.com>
Subject: [PATCH 55/57] staging/rts_pstor: remove braces {} in sd.c (sd_hw_rst)
Date: Fri,  7 Sep 2012 13:39:09 +0900
Message-Id: <1346992749-18161-1-git-send-email-yamanetoshi@gmail.com>
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
index 3fd1cce..cf054b6 100644
--- a/drivers/staging/rts_pstor/sd.c
+++ b/drivers/staging/rts_pstor/sd.c
@@ -4452,9 +4452,8 @@ int sd_hw_rst(struct scsi_cmnd *srb, struct rtsx_chip *chip)
 	switch (srb->cmnd[1] & 0x0F) {
 	case 0:
 #ifdef SUPPORT_SD_LOCK
-		if (0x64 == srb->cmnd[9]) {
+		if (0x64 == srb->cmnd[9])
 			sd_card->sd_lock_status |= SD_SDR_RST;
-		}
 #endif
 		retval = reset_sd_card(chip);
 		if (retval != STATUS_SUCCESS) {
-- 
1.7.9.5

