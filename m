Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752105Ab2IGEZ6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 00:25:58 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:51877 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750703Ab2IGEZ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 00:25:57 -0400
From: Toshiaki Yamane <yamanetoshi@gmail.com>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, Toshiaki Yamane <yamanetoshi@gmail.com>
Subject: [PATCH 09/57] staging/rts_pstor: remove braces {} in sd.c (sd_select_card)
Date: Fri,  7 Sep 2012 13:25:48 +0900
Message-Id: <1346991949-16673-1-git-send-email-yamanetoshi@gmail.com>
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
index 89d0487..4b1763c 100644
--- a/drivers/staging/rts_pstor/sd.c
+++ b/drivers/staging/rts_pstor/sd.c
@@ -717,9 +717,8 @@ int sd_select_card(struct rtsx_chip *chip, int select)
 	}
 
 	retval = sd_send_cmd_get_rsp(chip, cmd_idx, addr, cmd_type, NULL, 0);
-	if (retval != STATUS_SUCCESS) {
+	if (retval != STATUS_SUCCESS)
 		TRACE_RET(chip, STATUS_FAIL);
-	}
 
 	return STATUS_SUCCESS;
 }
-- 
1.7.9.5

