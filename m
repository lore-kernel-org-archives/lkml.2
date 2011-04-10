Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753464Ab1DJOM4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Apr 2011 10:12:56 -0400
Received: from mail-iy0-f194.google.com ([209.85.210.194]:49406 "EHLO
	mail-iy0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752326Ab1DJOMy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Apr 2011 10:12:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=IoHjORZaH2rQiEuM6TkteLkkxr1ceWv8myyYBdZ3Iuwp4Mi9EKdykHrvo1WrWIxGoh
         9ztpkt66ORP6ClfZsF5NFc9rJ77c8xQoWXDMuZNmdNoRoH5eq2nZByDzGMeuEu7QUjzR
         8i31f6aDEcPQzCjzUF2S+cmPoMbQTkaUEbzdw=
From: wanlong.gao@gmail.com
To: broonie@opensource.wolfsonmicro.com, geert@linux-m68k.org,
        starvik@axis.com, jesper.nilsson@axis.com, sameo@linux.intel.com,
        ian@opensource.wolfsonmicro.com, dp@opensource.wolfsonmicro.com,
        lrg@slimlogic.co.uk, James.Bottomley@suse.de, aelder@sgi.com
Cc: linux-kernel@vger.kernel.org, Wanlong Gao <wanlong.gao@gmail.com>
Subject: [PATCH 4/5] scsi:removed the unused variable
Date: Sun, 10 Apr 2011 22:10:28 +0800
Message-Id: <1302444629-17043-4-git-send-email-wanlong.gao@gmail.com>
X-Mailer: git-send-email 1.7.3
In-Reply-To: <1302444629-17043-1-git-send-email-wanlong.gao@gmail.com>
References: <1302444629-17043-1-git-send-email-wanlong.gao@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wanlong Gao <wanlong.gao@gmail.com>

removed the unused variable "oldto" of atari_NCR5380.c .

Signed-off-by: Wanlong Gao <wanlong.gao@gmail.com>
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
1.7.3

