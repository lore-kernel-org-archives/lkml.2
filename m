Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755244Ab1FFUBA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 16:01:00 -0400
Received: from juliette.telenet-ops.be ([195.130.137.74]:46676 "EHLO
	juliette.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757576Ab1FFUA7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 16:00:59 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org, linux-m68k@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ben Hutchings <ben@decadent.org.uk>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] scsi/atari_scsi: Remove obsolete variable oldto
Date: Mon,  6 Jun 2011 22:00:51 +0200
Message-Id: <1307390451-29536-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 8ce7955aa52c37db1425ea4bd4edcfa67e253454 ("[SCSI] atari_NCR5380:
update_timeout removal") removed all users, but not the avtual variable.

Suggested-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/scsi/atari_NCR5380.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/atari_NCR5380.c b/drivers/scsi/atari_NCR5380.c
index ea439f9..24652f1 100644
--- a/drivers/scsi/atari_NCR5380.c
+++ b/drivers/scsi/atari_NCR5380.c
@@ -914,7 +914,6 @@ static int NCR5380_queue_command_lck(Scsi_Cmnd *cmd, void (*done)(Scsi_Cmnd *))
 {
 	SETUP_HOSTDATA(cmd->device->host);
 	Scsi_Cmnd *tmp;
-	int oldto;
 	unsigned long flags;
 
 #if (NDEBUG & NDEBUG_NO_WRITE)
-- 
1.7.0.4

